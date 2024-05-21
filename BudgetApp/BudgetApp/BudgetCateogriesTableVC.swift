//
//  BudgetCateogriesTableVC.swift
//  BudgetApp
//
//  Created by Raghavendra Mirajkar on 20/05/24.
//

import UIKit
import CoreData

class BudgetCateogriesTableVC: UITableViewController {
    
    private var persistentContainer: NSPersistentContainer
    private var fetchedResultsController: NSFetchedResultsController<BudgetCateogry>!
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
        super.init(nibName: nil, bundle: nil)
        
        let request = BudgetCateogry.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        // register cell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BudgetTableViewCell")
    }
    
    @objc func showAddBudgetCategory(_ sender: UIBarButtonItem) {
        let navController = UINavigationController(rootViewController: AddBudgetCategoryVC(persistentContainer: persistentContainer))
        present(navController, animated: true)
    }
    
    private func setupUI() {
        
        let addBudgetCategoryButton = UIBarButtonItem(title: "Add Category", style: .done, target: self, action: #selector(showAddBudgetCategory))
        self.navigationItem.rightBarButtonItem = addBudgetCategoryButton
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Budget"
    }
    
    // UITableViewDataSource delegate functions
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (fetchedResultsController.fetchedObjects ?? []).count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let budgetCateogory = fetchedResultsController.object(at: indexPath)
        
        self.navigationController?.pushViewController(BudgetDetailVC(persistentContainer: persistentContainer, budgetCategory: budgetCateogory), animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BudgetTableViewCell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        
        let budgetCategory = fetchedResultsController.object(at: indexPath)
        
        var configuration = cell.defaultContentConfiguration()
        configuration.text = budgetCategory.name
        cell.contentConfiguration = configuration
        
        return cell
    }

}

extension BudgetCateogriesTableVC : NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
    
}


#Preview {
    let persistentContainer : NSPersistentContainer = {
       let container = NSPersistentContainer(name: "BudgetModel")
        container.loadPersistentStores { description , error  in
            if let error = error {
                fatalError("Unable to load persistent stores : \(error)")
            }
        }
        return container
    }()
    return BudgetCateogriesTableVC(persistentContainer: persistentContainer)
}
