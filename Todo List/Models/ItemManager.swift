//
//  ItemManager.swift
//  Todo List
//
//  Created by Inderpreet Bhatti on 07/11/24.
//

import Foundation
import UIKit
import CoreData

struct ItemManager {
    var items = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    func getCount() -> Int {
        return items.count
    }
    
    func getItemTitle(index: Int) -> String {
        return items[index].title ?? ""
    }
    
    func getItemDone(index: Int) -> Bool {
        return items[index].done
    }
    
    mutating func toggleItemDone(index: Int) {
         items[index].done.toggle()
//        context.delete(items[index])
//        items.remove(at: index)
        saveItems()
    }
    
    mutating func addItem(title: String, category: TodoCategory) {
        let newitem = Item(context: context)
        newitem.title = title
        newitem.category = category
        newitem.done = false
        items.append(newitem)
        saveItems()
    }
    
    private func saveItems() {
        do {
            try context.save()
        } catch {
            print("error saving context \(error)")
        }
    }
    
    mutating func loadItems(categoryName: String) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "category.title == %@", categoryName)
        request.predicate = predicate
        do {
            items = try context.fetch(request)
        } catch {
            print("error getting items \(error)")
        }
    }

    mutating func loadItems(with request: NSFetchRequest<Item>, categoryName: String, predicate: NSPredicate? = nil) {
        let categoryPredicate = NSPredicate(format: "category.title == %@", categoryName)
        if let additionalPredicate = predicate {
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [additionalPredicate, categoryPredicate])
            request.predicate = compoundPredicate
        } else {
            request.predicate = categoryPredicate
        }
        do {
            items = try context.fetch(request)
        } catch {
            print("error getting items \(error)")
        }
    }
}
