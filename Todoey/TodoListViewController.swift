//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

@available(iOS 14.0, *)
class TodoListViewController: UITableViewController {
    
    struct Constant {
        static let newItem = "Add New Item"
        static let addItem = "Add Item"
        static let todoeyItem = "Add new Todoey Item"
        static let cellIdentifier = "ToDoItemCell"
    }

    var itemArray = [DataModel]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }

    @IBAction func addItem(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: Constant.todoeyItem, message: String(), preferredStyle: .alert)
        
        alert.addTextField { alertText in
            alertText.placeholder = Constant.newItem
            textField = alertText
        }
        
        let action = UIAlertAction(title: Constant.addItem, style: .default) { action in
            let newItem = DataModel()
            newItem.name = textField.text!
            
            self.itemArray.append(newItem)
            
            self.saveItems()
        }

        alert.addAction(action)
        present(alert, animated: true)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        itemArray[indexPath.row].isSelected = !itemArray[indexPath.row].isSelected
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.cellIdentifier, for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = itemArray[indexPath.row].name
        cell.contentConfiguration = content
        
        let item = itemArray[indexPath.row]
        cell.accessoryType = item.isSelected ? .checkmark : .none
        
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.dataFilePath!)
        } catch {
            print("Error encoding item array \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            do {
                let decoder = PropertyListDecoder()
                itemArray = try decoder.decode([DataModel].self, from: data)
            } catch {
                print("Error decoding \(error)")
            }
 
        }
        
    }

}

