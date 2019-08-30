//
//   MyCategoryViewController.swift
//  Todoey
//
//  Created by Ajay Sridhar on 8/29/19.
//  Copyright © 2019 Ajay Sridhar. All rights reserved.
//

import UIKit
import CoreData

class  CategoryViewController: UITableViewController {
    
    var categories: [MyCategory] = []
    // the UIApplication.shared is the singleton of the AppDelegate class
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Path to categories SQLite data: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadItems()
    }
    
    // MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    // MARK: - Data Manipulation Methods
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("Error saving catergories in context to Core data: \(error)")
        }
        // reload the table view to show the new data
        tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<MyCategory> = MyCategory.fetchRequest()) { // this method has a default value
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error fetching catergories from context: \(error)")
        }
        tableView.reloadData()
    }
    
    // MARK: Add New Catergories
    @IBAction func addCategoryButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add category", style: .default) { (action) in
            let newCategory =  MyCategory(context: self.context)
            newCategory.name = textField.text
            self.categories.append(newCategory)
            self.saveCategories()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
}
