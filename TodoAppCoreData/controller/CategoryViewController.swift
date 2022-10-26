//
//  CategoryViewController.swift
//  TodoAppCoreData
//
//  Created by Navarasan on 21/10/22.
//

import UIKit
import CoreData

class CategoryViewController : SwipeCellView {
    
    var categories: [Category] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80.0
        
        loadCategory()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        alert.addTextField { uiTextField in
            
            uiTextField.placeholder = "Enter New Category"
            
            textField = uiTextField
        }
        
        let action = UIAlertAction(title: "Add Category", style: .default) { uIAlertAction in
            
            let category = Category(context: self.context)
            category.name = textField.text ?? "Empty"
            
            self.categories.append(category)
            
            self.saveCateogries()
            
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        
        present(alert, animated: true)
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToTodoView", sender: self)
    }
    
    func loadCategory(with request: NSFetchRequest<Category> = NSFetchRequest(entityName: "Category")) {
        
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error loading categories \(error)")
        }
        
    }
    
    func saveCateogries() {
        
        do {
            try context.save()
        } catch {
            print("Error saving categories \(error)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
            
        }
    }
    
    override func updateModel(indexPath: IndexPath) {
        super.updateModel(indexPath: indexPath)
        
        let category = categories[indexPath.row]
        categories.remove(at: indexPath.row)


        context.delete(category)
        saveCateogries()
    }
}

