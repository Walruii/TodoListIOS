//
//  TableViewController.swift
//  Todo List
//
//  Created by Inderpreet Bhatti on 06/11/24.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    var category: TodoCategory?
    var itemManager = ItemManager()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        if let catTitle = category?.title {
            title = catTitle
            itemManager.loadItems(categoryName: catTitle)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemManager.getCount()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemManager.getItemTitle(index: indexPath.row)
        cell.accessoryType = itemManager.getItemDone(index: indexPath.row) ? .checkmark : .none
        return cell;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemManager.toggleItemDone(index: indexPath.row)
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Todo", message: "", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let todoItem = alert.textFields?.first?.text, let cat = self.category {
                self.itemManager.addItem(title: todoItem, category: cat)
                self.tableView.reloadData()
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            print(alertTextField.text!)
        }
        
        alert.addAction(alertAction)
        
        
        present(alert, animated: true, completion: nil)
    }
    
    
}

//MARK: - Search Bar Delegate

extension TableViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let catTitle = category?.title {
            let request : NSFetchRequest<Item> = Item.fetchRequest()
            
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
            request.predicate = predicate
            
            let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
            request.sortDescriptors = [sortDescriptor]
            itemManager.loadItems(with: request, categoryName: catTitle, predicate: predicate)
            tableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text?.count == 0) {
            if let catTitle = category?.title {
                itemManager.loadItems(categoryName: catTitle)
                tableView.reloadData()
                DispatchQueue.main.async {
                    searchBar.resignFirstResponder()
                }
            }
        }
    }
}
