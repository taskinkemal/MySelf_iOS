//
//  TasksViewController.swift
//  myself
//
//  Created by Kemal Taskin on 30.11.18.
//  Copyright © 2018 Kelpersegg. All rights reserved.
//

import UIKit
import RealmSwift

class TasksViewController: UITableViewController, UIGestureRecognizerDelegate {

    var items = [TaskEntry].init();
    var selectedTaskId: Int?
    
    public var day: Int = 0
    
    public func reload() {
        
        let syncTasks = SyncTasks()
        syncTasks.day = day
        syncTasks.Run(controller: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLongPressGesture()
    }
    
    func setupLongPressGesture() {
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        longPressGesture.minimumPressDuration = 1.0 // 1 second press
        longPressGesture.delegate = self as UIGestureRecognizerDelegate
        self.tableView.addGestureRecognizer(longPressGesture)
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state == .ended {
            let touchPoint = gestureRecognizer.location(in: self.tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                
                selectedTaskId = self.items[indexPath.row].task!.Id
                
                self.performSegue(withIdentifier: "sgAddTask", sender: self)
                //sgAddTask
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "sgAddTask") {
            
            let viewController = segue.destination as! TaskEditViewController
            viewController.taskId = selectedTaskId!
        }
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
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var strDay: String = ""
        switch day {
        case Utils.GetToday():
            strDay = "Today"
            break
        case Utils.GetToday() - 1:
            strDay = "Yesterday"
            break
        default:
            strDay = Utils.GetDayOfWeek(day: day)
            break
        }
        return strDay
    }

}
