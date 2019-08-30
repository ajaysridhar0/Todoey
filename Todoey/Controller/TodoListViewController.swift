//
//  ViewController.swift
//  Todoey
//
//  Created by Ajay Sridhar on 8/28/19.
//  Copyright © 2019 Ajay Sridhar. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    // the UIApplication.shared is the singleton of the AppDelegate class
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        // fetch data from the context when the app starts again
        loadItems()
    }
    
    // MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        // checks if the path has checkmark
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    // MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        // toggle the checkmark on the right side of the cell
//        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        // commit the current state of the context to persistent data
        self.saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Add New Items
    @IBAction func addButtonPress(_ sender: Any) {
        var textField: UITextField?
        
        let alert = UIAlertController(title: "Add Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen when the user clicks the add item button on the UIAlert
            // this item is of type NSManagedObject, which is the rows inside the table
            let newItem = Item(context: self.context)
            newItem.done = false
            newItem.title = textField!.text!
            self.itemArray.append(newItem)
            self.saveItems()
        }
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Model Manipulation Methods
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving items in context to Core data: \(error)")
        }
        // reload the table view to show the new data
        tableView.reloadData()
    }
    
    // request Items from persistent data
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) { // this method has a default value
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching items from context: \(error)")
        }
        tableView.reloadData()
    }
}

// MARK: - Search Bar Delegate Methods
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // request Items from persistent data
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        // nspredicate is a query language
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        //defines how the data is sorted after user searches
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request)
    }
    
    // text in the search bar has to change for this method to trigger
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text!.count == 0 {
            loadItems()
            // as the DispatchQueue to get the main queue and then as the search screen to no longer be there
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}
