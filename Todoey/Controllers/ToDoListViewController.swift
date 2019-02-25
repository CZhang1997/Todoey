//
//  ViewController.swift
//  Todoey
//
//  Created by Churong Zhang on 1/20/19.
//  Copyright © 2019 Churong Zhang. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    var todoItems : Results<Item>?
    let realm = try! Realm()
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    let defaults = UserDefaults.standard
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self;
       // self.navigationItem.backBarButtonItem?.tintColor = UIColor.white
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        if let item = todoItems?[indexPath.row] {
           
            cell.accessoryType = item.done ? .checkmark : .none
            cell.textLabel!.text = item.title
            
        }else {
            cell.textLabel?.text = "No Item Added"
        }
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //    print(itemArray[indexPath.row])
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print ("error saving done status, \(error)")
            }
        }
//        todoItems?[indexPath.row].done = !todoItems?[indexPath.row].done
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)

        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCatergory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCatergory.items.append(newItem)
                    }
                }catch {
                    print ("error saving new items, \(error)")
                }
               self.tableView.reloadData()
            }

        }
        
        alert.addTextField { (alertTextField ) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
       
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
  
    
    func loadItems()
    {

        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
//        tableView.reloadData()
    }
//    func savaItems()
//    {
//        let encoder = PropertyListEncoder()
//
//        do {
//            let data = try encoder.encode(self.itemArray)
//
//            try data.write(to: self.dataFilePath!)
//        }
//        catch {
//            print("Error encoding item array, \(error)")
//
//        }
//        self.tableView.reloadData()
//    }
//    func loadItems()
//    {
//        if let data  = try? Data(contentsOf:  dataFilePath!)
//        {
//            let decoder = PropertyListDecoder()
//            do {
//                itemArray =  try decoder.decode([Item].self, from: data)
//
//            } catch {
//                print ("Decode error \(error)")
//            }
//        }
//
//    }

}

//MARK: - Search Bar
extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchBar.text?.count == 0 {
            loadItems()

        }
        else
        {
            todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
//            let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//            request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//            loadItems(with: request)
        }
        tableView.reloadData()
        
    }
}

