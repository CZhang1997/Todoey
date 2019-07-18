//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Churong Zhang on 2/24/19.
//  Copyright © 2019 Churong Zhang. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class CategoryTableViewController: SwipeViewController {

    var categories: Results<Category>?
    
    let realm = try! Realm()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
       
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories?.count ?? 1 // if is nil then return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.backgroundColor = UIColor(hexString: categories?[indexPath.row].backgroundColor ?? "1D9BF6" )
        cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
      //  cell.textLabel?.textColor =
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Category Added"
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.backgroundColor = UIColor.randomFlat.hexValue()
            self.save(category: newCategory)
        }
        alert.addAction(action)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new category"
        }
        present(alert, animated: true, completion: nil)
    }
    
    func save(category: Category)
    {
        do {
            try realm.write {
                realm.add(category)
            }
        }
        catch{
            print ("Error on saving Category \(error)")
        }
        tableView.reloadData()
    }
    func loadCategories()
    {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    override func changeColor(at indexPath: IndexPath)
    {
        if let catD = self.categories?[indexPath.row]
        {
            
            print("Color change")
            do {
                try self.realm.write {
                    catD.backgroundColor = UIColor.randomFlat.hexValue()
                }
            }
            catch {
                print ("error on color change \(error)")
            }
        }
        tableView.reloadData()
    }
    override func updateModel(at indexPath: IndexPath) {
        if let catD = self.categories?[indexPath.row]
        {
            do {
                try self.realm.write {
                    self.realm.delete(catD)
                }
            }
            catch {
                print ("error on deleting\(error)")
            }
        }
    }
}

