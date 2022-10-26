//
//  SwipeCellView.swift
//  TodoAppCoreData
//
//  Created by Navarasan on 23/10/22.
//

import UIKit
import SwipeCellKit

class SwipeCellView: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
           cell.delegate = self
        
           return cell
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeCellKit.SwipeActionsOrientation) -> [SwipeCellKit.SwipeAction]? {
        
        guard orientation == .right else { return nil }

            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                // handle action by updating model with deletion
                
                print("deleted")
                
                self.updateModel(indexPath: indexPath)
                
//                let category = self.categories[indexPath.row]
//                self.categories.remove(at: indexPath.row)
//
//
//                self.context.delete(category)
//                self.saveCateogries()
                
            }

            // customize the action appearance
            deleteAction.image = UIImage(named: "trash")

            return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    
    func updateModel(indexPath: IndexPath) {
        print("updateModel called")
    }

}
