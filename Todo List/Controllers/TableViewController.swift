//
//  TableViewController.swift
//  Todo List
//
//  Created by Inderpreet Bhatti on 06/11/24.
//

import UIKit

class TableViewController: UITableViewController {
    
    var itemManager = ItemManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        itemManager.loadItems()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemManager.getCount()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemManager.getItemText(index: indexPath.row)
        cell.accessoryType = itemManager.getItemDone(index: indexPath.row) ? .checkmark : .none
        return cell;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemManager.toggleItemDone(index: indexPath.row)
        itemManager.saveItems()
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Todo", message: "", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let todoItem = alert.textFields?.first?.text {
                self.itemManager.addItem(todoItem)
                self.itemManager.saveItems()
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


