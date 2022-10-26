//
//  ViewController.swift
//  TodoAppCoreData
//
//  Created by Navarasan on 19/10/22.
//

import UIKit
import CoreData

class TodoViewController: SwipeCellView {
    
    var todoList = [TodoItem]()
    var selectedCategory: Category? {
        didSet {
            loadTodoItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.rowHeight = 80.0
        
//        loadTodoItems()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        let todo = todoList[indexPath.row]
        
        cell.textLabel?.text =  todo.title!
        cell.accessoryType = todo.isSelected ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = super.tableView.cellForRow(at: indexPath)
        cell?.setSelected(false, animated: true)
        
//        context.delete(todoList[indexPath.row])
//        todoList.remove(at: indexPath.row)
        
        todoList[indexPath.row].isSelected = !todoList[indexPath.row].isSelected
        tableView.reloadData()
        saveTodoItems()
    }
    
    @IBAction func addTodoButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Todo", style: .default) { alertAction in
//            print("success \(textField.text)")
            
            let newTodo = TodoItem(context: self.context)
            newTodo.title = textField.text
            newTodo.isSelected = false
            newTodo.category = self.selectedCategory
            
            self.todoList.append(newTodo)
            self.tableView.reloadData()
            
            self.saveTodoItems()
        }
        
        alert.addTextField { alertTextField in
//            print(alertTextField.text)
            alertTextField.placeholder = "Enter your todo list"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true)
    }
    
    override func updateModel(indexPath: IndexPath) {
        super.updateModel(indexPath: indexPath)
        
        context.delete(todoList[indexPath.row])
        todoList.remove(at: indexPath.row)
        
        saveTodoItems()
    }
    
    
    func loadTodoItems(with request: NSFetchRequest<TodoItem> = NSFetchRequest(entityName: "TodoItem"), predeicate : NSPredicate? = nil) {
//        let request: NSFetchRequest<TodoItem> = NSFetchRequest(entityName: "TodoItem")
        
        let categoryPredicate = NSPredicate(format: "category.name MATCHES %@", selectedCategory!.name!)
        
        if let newPredicate = predeicate {
            
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, newPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do{
            todoList = try context.fetch(request)
            
        } catch {
            print("Error Fetching data \(error)")
        }
    }
    
    func saveTodoItems() {
        
        do{
            try context.save()
        } catch {
            print("Error saving data \(error)")
        }
    }


}

extension TodoViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<TodoItem> = NSFetchRequest(entityName: "TodoItem")
        
        let predicate = NSPredicate(format: "title CONTAINS[c] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadTodoItems(with: request, predeicate: predicate)
        
        view.endEditing(true)
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.isEmpty == true {
            loadTodoItems()
            
            tableView.reloadData()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
            
        }
    }
}

