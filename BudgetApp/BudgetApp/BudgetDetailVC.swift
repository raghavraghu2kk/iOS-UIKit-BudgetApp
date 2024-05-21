//
//  BudgetDetailVC.swift
//  BudgetApp
//
//  Created by Raghavendra Mirajkar on 21/05/24.
//

import UIKit
import CoreData
import Foundation

class BudgetDetailVC: UIViewController {
    
    private var persistentContainer: NSPersistentContainer
    private var fetchResultsController : NSFetchedResultsController<Transaction>!
    private var budgetCategory : BudgetCateogry
    
    init(persistentContainer: NSPersistentContainer, budgetCategory: BudgetCateogry) {
        self.persistentContainer = persistentContainer
        self.budgetCategory = budgetCategory
        super.init(nibName: nil, bundle: nil)
        
        //
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    private var isFormValid : Bool {
        guard let name = nameTextField.text, let amount = amountTextField.text else {
            return false
        }
        
        return !name.isEmpty && !amount.isEmpty && amount.isNumeric && amount.isGreaterThan(0)
    }
    
    private func saveTransaction() {
        guard let name = nameTextField.text, let amount = amountTextField.text else {
            return
        }
        
        let transaction = Transaction(context: persistentContainer.viewContext)
        transaction.name = name
        transaction.amount = Double(amount) ?? 0.0
        transaction.category = budgetCategory
        transaction.dateCreated = .now
        
//        budgetCategory.addToTransaction(transaction)
        
        do {
            try persistentContainer.viewContext.save()
            tableView.reloadData()
        } catch {
            errorMessageLabel.text = "Unable to save transaction."
        }
    }
    
    @objc func saveTransactionButtonPressed(_ sender: UIButton) {
        if isFormValid {
            saveTransaction()
        } else {
            errorMessageLabel.text = "Make sure name and amount is valid"
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        title = budgetCategory.name
        
        // stackview
        
        let stackview = UIStackView()
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.axis = .vertical
        stackview.spacing = UIStackView.spacingUseSystem
        stackview.isLayoutMarginsRelativeArrangement = true
        stackview.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        
        stackview.addArrangedSubview(amountLabel)
        stackview.setCustomSpacing(30, after: amountLabel)
        stackview.addArrangedSubview(nameTextField)
        stackview.addArrangedSubview(amountTextField)
        stackview.addArrangedSubview(saveTransactionButton)
        stackview.addArrangedSubview(errorMessageLabel)
        stackview.addArrangedSubview(tableView)
        
        view.addSubview(stackview)
        
        // add constraints
        
        nameTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        amountTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        saveTransactionButton.centerXAnchor.constraint(equalTo: stackview.centerXAnchor).isActive = true
        saveTransactionButton.addTarget(self, action: #selector(saveTransactionButtonPressed), for: .touchUpInside)
        
        stackview.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        stackview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//        tableView.heightAnchor.constraint(equalToConstant: 600).isActive = true
        
    }
    
    lazy var nameTextField : UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Transaction name"
        textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textfield.leftViewMode = .always
        textfield.borderStyle = .roundedRect
        return textfield
    }()
    
    lazy var amountTextField : UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Amount"
        textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textfield.leftViewMode = .always
        textfield.borderStyle = .roundedRect
        return textfield
    }()
    
    lazy var tableView : UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TransactionTableViewCell")
        return tableView
    }()
    
    lazy var saveTransactionButton : UIButton = {
        var config = UIButton.Configuration.bordered()
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Save Transaction", for: .normal)
        return button
    }()
    
    lazy var errorMessageLabel : UILabel = {
       let label = UILabel()
        label.textColor = .red
        label.text = ""
        label.numberOfLines = 0
        return label
    }()
    
    lazy var amountLabel : UILabel = {
        let label = UILabel()
        label.text = budgetCategory.amount.formatted(.currency(code: "USD"))
        return label
    }()
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension BudgetDetailVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTableView", for: indexPath)
        return cell
    }
    
    
}

extension BudgetDetailVC : UITableViewDelegate {
    
}


#Preview {
    lazy var persistentContainer : NSPersistentContainer = {
       let container = NSPersistentContainer(name: "BudgetModel")
        container.loadPersistentStores { description , error  in
            if let error = error {
                fatalError("Unable to load persistent stores : \(error)")
            }
        }
        return container
    }()
    return UINavigationController(rootViewController: BudgetCateogriesTableVC(persistentContainer: persistentContainer))
}
