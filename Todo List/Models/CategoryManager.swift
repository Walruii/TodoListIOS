//
//  ItemManager.swift
//  Todo List
//
//  Created by Inderpreet Bhatti on 07/11/24.
//

import Foundation
import UIKit
import CoreData

struct CategoryManager {
    var categories = [TodoCategory]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    func getCount() -> Int {
        return categories.count
    }
    
    func getCategoryText(index: Int) -> String {
        return categories[index].title ?? ""
    }
    
    mutating func addCategory(_ itemText: String) {
        let newCategory = TodoCategory(context: context)
        newCategory.title = itemText
        categories.append(newCategory)
        saveCategories()
    }
    
    private func saveCategories() {
        do {
            try context.save()
        } catch {
            print("error saving context \(error)")
        }
    }
    
    mutating func loadCategories(_ request: NSFetchRequest<TodoCategory> = TodoCategory.fetchRequest()) {
        do {
            categories = try context.fetch(request)
        } catch {
            print("error getting categories \(error)")
        }
    }
}

