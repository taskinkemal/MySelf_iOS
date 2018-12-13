//
//  TasksViewController.swift
//  myself
//
//  Created by Kemal Taskin on 30.11.18.
//  Copyright © 2018 Kelpersegg. All rights reserved.
//

import UIKit
import RealmSwift

class TasksViewController: UITableViewController {

    var items = [TaskEntry].init();
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Reload the table
        self.tableView.reloadData()
        
        let syncTasks = SyncTasks()
        
        syncTasks.Run(controller: self)
    }
    
    public func ListLoaded(list:[TaskEntry])
    {
        self.items.removeAll();
        self.items += list;
        DispatchQueue.main.async {
            self.tableView.reloadData();
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = items[indexPath.row]
        
        if item.task?.DataType == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BooleanCell", for: indexPath)
                as! TaskBooleanViewCell
            
            cell.initCell(taskEntry: item)
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NumericCell", for: indexPath)
                as! TaskNumericViewCell
            
            cell.lblLabel?.text = item.task?.Label
            cell.lblUnit?.text = item.task?.Unit
            cell.lblValue?.text = String(item.entry?.Value ?? 0)
            
            return cell
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
