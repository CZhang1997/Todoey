//
//  SwipeViewController.swift
//  Todoey
//
//  Created by Churong Zhang on 2/26/19.
//  Copyright © 2019 Churong Zhang. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeViewController: UITableViewController, SwipeTableViewCellDelegate {

    var cell: UITableViewCell?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        
       //cell.textLabel?.text = categories?[indexPath.row].name ?? "No Category Added"
        return cell
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else {
            changeColor(at: indexPath)
            return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "删除") { action, indexPath in
            // handle action by updating model with deletion
            print("Delete cell")
            self.updateModel(at: indexPath)

            
            
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        //       options.transitionStyle = .border
        return options
    }
    func updateModel(at indexPath: IndexPath)
    {
        print("Item deleted from superclass")
        
        // update data model
    }
    func changeColor(at indexPath: IndexPath)
    {
        // change color
    }
}

