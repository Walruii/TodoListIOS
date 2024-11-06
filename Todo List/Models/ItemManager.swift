//
//  ItemManager.swift
//  Todo List
//
//  Created by Inderpreet Bhatti on 07/11/24.
//

import Foundation

struct ItemManager {
    var items: [Item]  = []
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    func getCount() -> Int {
        return items.count
    }
    
    func getItemText(index: Int) -> String {
        return items[index].text
    }
    
    func getItemDone(index: Int) -> Bool {
        return items[index].done
    }
    
    mutating func toggleItemDone(index: Int) {
        items[index].done.toggle()
    }
    
    mutating func addItem(_ itemText: String) {
        let item = Item(text: itemText, done: false)
        items.append(item)
    }
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(items)
            try data.write(to: dataFilePath!)
        } catch {
            print(error)
        }
    }
    
    mutating func loadItems() {
        let decoder = PropertyListDecoder()
        do {
            let data = try Data(contentsOf: dataFilePath!)
            items = try decoder.decode([Item].self, from: data)
        } catch {
            print(error)
        }
    }
}
