//
//  BudgetCateogriesTableVC.swift
//  BudgetApp
//
//  Created by Raghavendra Mirajkar on 20/05/24.
//

import UIKit
import CoreData
import SwiftUI

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
        self.viewDidLoad()
    }
    
    private func setupUI() {
        
        let addBudgetCategoryButton = UIBarButtonItem(title: "Add Category", style: .done, target: self, action: #selector(showAddBudgetCategory))
        self.navigationItem.rightBarButtonItem = addBudgetCategoryButton
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Budget"
    }
    
    func deleteCategory(_ budgetCategory : BudgetCateogry){
        persistentContainer.viewContext.delete(budgetCategory)
        do {
            try persistentContainer.viewContext.save()
        } catch {
            let alert =  Alert(title: Text("Error"), message: Text("Unable to delete"))
        }
    }
    
    // UITableViewDataSource delegate functions
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (fetchedResultsController.fetchedObjects ?? []).count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let budgetCateogory = fetchedResultsController.object(at: indexPath)
        
        self.navigationController?.pushViewController(BudgetDetailVC(budgetCategory: budgetCateogory, persistentContainer: persistentContainer), animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let budgetCategory = fetchedResultsController.object(at: indexPath)
            deleteCategory(budgetCategory)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BudgetTableViewCell") else {
            fatalError("You forgot to register your table view cell")
        }
        let budgetCategory = fetchedResultsController.object(at: indexPath)
        let name = budgetCategory.name!
        let amount = String(budgetCategory.amount)
        let remainingAmount = String(budgetCategory.remainingAmount)
        
        cell.contentConfiguration = UIHostingConfiguration {
            // For demo purposes the SwiftUI code below isn't in a separate file/view
            BudgetCategoryTableViewCell(nameLabel: name, amountLabel: amount, remainingLabel: remainingAmount)
        }

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
