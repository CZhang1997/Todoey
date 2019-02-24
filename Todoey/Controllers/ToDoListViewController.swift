//
//  ViewController.swift
//  Todoey
//
//  Created by Churong Zhang on 1/20/19.
//  Copyright © 2019 Churong Zhang. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        

    loadItems()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.accessoryType = item.done ? .checkmark : .none
        
        cell.textLabel!.text = item.title
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //    print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        savaItems()
       
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            
            
            
            self.savaItems()
        }
        
        alert.addTextField { (alertTextField ) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
       
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func savaItems()
    {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(self.itemArray)
            
            try data.write(to: self.dataFilePath!)
        }
        catch {
            print("Error encoding item array, \(error)")
            
        }
        self.tableView.reloadData()
    }
    func loadItems()
    {
        if let data  = try? Data(contentsOf:  dataFilePath!)
        {
            let decoder = PropertyListDecoder()
            do {
                itemArray =  try decoder.decode([Item].self, from: data)
                
            } catch {
                print ("Decode error \(error)")
            }
        }
        
    }

}

