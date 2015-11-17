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
    
    var detailViewController: ContactListViewController? = nil
    var categories = MutableProperty<Results<Category>>(Category.all())
    
    
    @IBOutlet weak var searchField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let importButton = UIBarButtonItem(title: "Import", style: .Plain, target: self, action: "importContacts:")
        self.navigationItem.leftBarButtonItem = importButton
        
        let searchStrings = searchField.rac_textSignal()
            .toSignalProducer()
            .map { text in text as! String }
        
        categories <~ searchStrings.map{
                Category.filter($0)
            }.flatMapError { _ in
                SignalProducer.empty
        }
        
        searchStrings.startWithNext({_ in
            self.tableView.reloadData()
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        //self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        tableView.reloadData()
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func importContacts(sender: AnyObject) {
        //        objects.insert(NSDate(), atIndex: 0)
        //        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        //        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        
        let importer = ContactImporter()
        
        importer.importContacts({
            self.categories = MutableProperty<Results<Category>>(Category.all())
            self.tableView.reloadData()
        })
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showContacts" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let category = categories.value[indexPath.row]
                let controller = segue.destinationViewController as! ContactListViewController
                controller.contacts = category.contacts
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
        return categories.value.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell", forIndexPath: indexPath)
        let category = categories.value[indexPath.row]
        cell.textLabel!.text = category.name
        cell.detailTextLabel!.text = "\(category.color)"
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            categories.value[indexPath.row].delete()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    
}

