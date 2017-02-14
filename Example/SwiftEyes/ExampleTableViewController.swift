//
//  ExampleTableViewController.swift
//  SwiftEyes
//
//  Created by lee on 14/02/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

class ExampleTableViewController: UITableViewController {

    let examples = ["MotionTracking", "ColorTracking"]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Examples"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        // #warning Incomplete implementation, return the number of rows
        return examples.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exampleCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = examples[indexPath.row]

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        self.performSegue(withIdentifier: examples[indexPath.row], sender: self)
    }

    

}
