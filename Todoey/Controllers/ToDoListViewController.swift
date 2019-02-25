//
//  ViewController.swift
//  Todoey
//
//  Created by Churong Zhang on 1/20/19.
//  Copyright © 2019 Churong Zhang. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    let defaults = UserDefaults.standard
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self;
       // self.navigationItem.backBarButtonItem?.tintColor = UIColor.white
        
        
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
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        savaItems()
       
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false;
            newItem.parentCategory = self.selectedCategory
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
        do {
            try context.save()
        }
        catch {
            print ("error saving \(error)")
            
        }
        self.tableView.reloadData()
    }
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest())
    {
        let predicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let pre2 = request.predicate
        {
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [pre2, predicate])
            request.predicate = compoundPredicate
        }
        else
        {
            request.predicate = predicate
        }
        
        
        do {
            itemArray = try context.fetch(request)
        }
        catch{
            print("error fetching data from context \(error)")
        }
        tableView.reloadData()
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
            let request : NSFetchRequest<Item> = Item.fetchRequest()
           
            request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            loadItems(with: request)

    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
//        else
//        {
//            let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//            request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//            loadItems(with: request)
//        }
        
    }
}

