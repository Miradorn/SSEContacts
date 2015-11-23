//
//  MasterViewController.swift
//  SseContacts
//
//  Created by Alexander Schramm on 06.11.15.
//  Copyright © 2015 Alexander Schramm. All rights reserved.
//

import UIKit
import RealmSwift
import ReactiveCocoa

class CategoryViewController: UITableViewController {
    
    var categoriesViewModel: CategoriesViewModel! //MutableProperty<Results<Category>>(Category.all())
    
    
    @IBOutlet weak var searchField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        updateCategoriesViewModel()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let importButton = UIBarButtonItem(title: "Import", style: .Plain, target: self, action: "importContacts:")

        importButton.rac_enabled <~ ContactImporter.isImporting.producer.map{!$0}
        self.navigationItem.leftBarButtonItem = importButton
        
        self.searchField.rac_textSignal().subscribeNext{ _ in
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func importContacts(sender: AnyObject) {
        ContactImporter.importContacts(withCompletionHandler: {
            self.updateCategoriesViewModel()
            self.tableView.reloadData()
        })
    }
    
    private func updateCategoriesViewModel() {
        let searchSignal: SignalProducer<String, NoError> = self.searchField.rac_textSignal()
            .toSignalProducer().map{ query in
                return query as! String
            }.flatMapError{ error in
                SignalProducer.empty
        }
        
        categoriesViewModel = CategoriesViewModel(withSearchSignal: searchSignal)
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showContacts" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let categoryViewModel = categoriesViewModel[indexPath.row]
                let controller = segue.destinationViewController as! ContactListViewController
                
                controller.contacts = categoryViewModel.category.contacts //TODO Should take ViewModel
                
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesViewModel.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell", forIndexPath: indexPath) as! CategoryTableViewCell
        
        let categoryViewModel = categoriesViewModel[indexPath.row]
        
        categoryViewModel.cell = cell
        
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            categoriesViewModel.deleteCategory(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    
}

