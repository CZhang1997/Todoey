//
//  ViewController.swift
//  Todoey
//
//  Created by Churong Zhang on 1/20/19.
//  Copyright © 2019 Churong Zhang. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListViewController: SwipeViewController {

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
    override func viewWillAppear(_ animated: Bool) {
        guard let colorHex = selectedCategory?.backgroundColor else {
            fatalError("color does not work")
        }
        
        updateNavBar(withHexCode: colorHex)
            self.navigationItem.title = selectedCategory?.name
            // title = selectedCategory!.name
        
        
    }
    // MARK - Tableview Datasource Methods
    override func viewWillDisappear(_ animated: Bool) {
        
        updateNavBar(withHexCode: "1D9BF6")
    }
    //MARK: -Nav Bar Setup
    func updateNavBar(withHexCode color: String)
    {
        guard let navBar = navigationController?.navigationBar else {
            fatalError("Navigation controller does not exitst")
        }
        guard let navColor = UIColor(hexString: color) else { fatalError()}
        navBar.barTintColor = navColor
        
        navBar.tintColor = ContrastColorOf(navColor, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: navBar.tintColor]
        searchBar.barTintColor = navColor
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        if let item = todoItems?[indexPath.row] {
           
            cell.accessoryType = item.done ? .checkmark : .none
            cell.textLabel!.text = item.title
            
            if let color =  UIColor(hexString: (selectedCategory?.backgroundColor)!)!.darken(byPercentage: (CGFloat(indexPath.row) / CGFloat(todoItems!.count)))
            {
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
            }
            
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
  
    override func updateModel(at indexPath: IndexPath) {
       
        if let ite = self.todoItems?[indexPath.row]
        {
            do {
                try self.realm.write {
                    self.realm.delete(ite)
                }
            }
            catch {
                print ("error on deleting item \(error)")
            }
        }
    }
    
    func loadItems()
    {

        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
//        tableView.reloadData()
    }


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

