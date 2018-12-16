//
//  TaskEditViewController.swift
//  myself
//
//  Created by Kemal Taskin on 16.12.18.
//  Copyright © 2018 Kelpersegg. All rights reserved.
//

import UIKit

class TaskEditViewController: UIViewController {

    @IBOutlet weak var txbLabel: UITextField!
    @IBOutlet weak var swTrackPerUnit: UISwitch!
    @IBOutlet weak var swSetGoal: UISwitch!
    @IBOutlet weak var vTrackPerUnit: UIView!
    @IBOutlet weak var vSetGoal: UIView!
    @IBOutlet weak var txbUnit: UITextField!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var lblUnits: UILabel!
    @IBOutlet weak var sgmGoalMinMax: UISegmentedControl!
    @IBOutlet weak var sgmGoalTimeFrame: UISegmentedControl!
    @IBOutlet weak var txbGoal: UITextField!
    @IBOutlet weak var vGoal: UIView!
    @IBOutlet weak var btnDone: UIBarButtonItem!
    @IBOutlet weak var btnCancel: UIBarButtonItem!
    
    public var taskId = 0
    var task: Task? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txbLabel.layer.borderWidth = 1
        txbLabel.layer.borderColor = UIColor.lightGray.cgColor
        txbLabel.layer.cornerRadius = 0
        vTrackPerUnit.layer.borderWidth = 1
        vTrackPerUnit.layer.borderColor = UIColor.lightGray.cgColor
        vSetGoal.layer.borderWidth = 1
        vSetGoal.layer.borderColor = UIColor.lightGray.cgColor
        
        swTrackPerUnit.addTarget(self, action: #selector(swTrackPerUnitChanged), for: UIControl.Event.valueChanged)
        swSetGoal.addTarget(self, action: #selector(swSetGoalChanged), for: UIControl.Event.valueChanged)
        
        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(TaskEditViewController.btnDoneClicked)), animated: true)
        
        self.navigationItem.setLeftBarButton(UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(TaskEditViewController.btnCancelClicked)), animated: true)

        self.txbUnit.isHidden = true
        self.vGoal.isHidden = true
        self.sgmGoalMinMax.isHidden = true
        self.sgmGoalTimeFrame.isHidden = true
        
        stackView.sizeToFit()
    }
    
    @objc func btnDoneClicked(sender:UIBarButtonItem) {
        
        let label = txbLabel.text!
        let dataType = swTrackPerUnit.isOn ? 1 : 0
        let unit = txbUnit.text!
        let goal = Int(txbGoal.text!)!
        if (taskId == 0) {
         
            task = Task(taskId, label, dataType: dataType,
                            unit: unit, hasGoal: swSetGoal.isOn,
                            goalMinMax: sgmGoalMinMax.selectedSegmentIndex,
                            goal: goal,
                            goalTimeFrame: sgmGoalTimeFrame.selectedSegmentIndex,
                            status: 1,
                            modificationDate: Date(),
                            automationType: 0,
                            automationVar: "")
            
            DispatchQueue.main.async {
                
                self.UploadTask()
            }
        }
        else {
            //TODO:
        }
    }
    
    func UploadTask()
    {
        HttpRequest.send(url: "tasks",
                         method: "POST",
                         data: task!,
                         cbSuccess: CallbackSuccessUploadTask,
                         cbError: CallbackError);
    }
    
    func CallbackError(statusCode:Int, message: String)
    {
        //TODO: set a good task id to update later. or don't insert/update at all.
        DispatchQueue.main.async {
            RealmHelper.SaveTask(task: self.task!)
        }
    }
    
    func CallbackSuccessUploadTask(result:JsonResult<Int>)
    {
        self.task!.Id = result.Value
        
        DispatchQueue.main.async {
            RealmHelper.SaveTask(task: self.task!)
            self.GoToListView()
        }
    }
    
    @objc func btnCancelClicked(sender:UIBarButtonItem) {
        GoToListView()
    }
    
    func GoToListView() {
    
        self.performSegue(withIdentifier: "sgEditDone", sender: self)
    }
    
    @objc func swTrackPerUnitChanged(mySwitch: UISwitch) {
        
        UIView.animate(withDuration: 0.3,
                       delay: 0.0,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 1,
                       options: [],
                       animations: {
                        self.txbUnit.isHidden = !mySwitch.isOn
                        self.stackView.layoutIfNeeded()
        },
                       completion: nil)
        
        stackView.sizeToFit()
    }
    
    @objc func swSetGoalChanged(mySwitch: UISwitch) {
        
        UIView.animate(withDuration: 0.3,
                       delay: 0.0,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 1,
                       options: [],
                       animations: {
                        self.vGoal.isHidden = !mySwitch.isOn
                        self.sgmGoalMinMax.isHidden = !mySwitch.isOn
                        self.sgmGoalTimeFrame.isHidden = !mySwitch.isOn
                        self.stackView.layoutIfNeeded()
        },
                       completion: nil)
        
        stackView.sizeToFit()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
