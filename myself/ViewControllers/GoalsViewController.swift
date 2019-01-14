//
//  GoalsViewController.swift
//  myself
//
//  Created by Kemal Taskin on 14.01.19.
//  Copyright © 2019 Kelpersegg. All rights reserved.
//

import UIKit

class GoalsViewController: UICollectionViewController {
    
    let reuseIdentifier = "goalCell" // also enter this string as the cell identifier in the storyboard
    var items = [Goal].init();
    var selectedGoalId: Int?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        HttpRequest.send(url: "goals",
                         method: "GET",
                         data: nil,
                         cbSuccess: CallbackGoalsSuccess,
                         cbError: CallbackError);
    }
    
    func CallbackError(statusCode:Int, message: String)
    {
    }
    
    func CallbackGoalsSuccess(list:ListWrapper<Goal>)
    {
        DispatchQueue.main.async {
            
            for goal in list.Items {
                RealmHelper.SaveGoal(goal: goal)
            }
            
            self.items.removeAll()
            self.items.append(contentsOf: list.Items)
            self.collectionView.reloadData()
        }
    }
    
    // tell the collection view how many cells to make
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    // make a cell for each cell index path
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! GoalsCollectionViewCell
        
        let goal = self.items[indexPath.item];
        
        DispatchQueue.main.async {
            
            let task = RealmHelper.GetTask(id: goal.TaskId)!;
            
            // Use the outlet in our custom class to get a reference to the UILabel in the cell
            cell.lblTask.text = task.Label;
            cell.lblTarget.text = self.getTargetText(target: goal.Target, unit: task.Unit, minMax: goal.MinMax);
            cell.lblValue.text = String(goal.CurrentValue);
            cell.lblDeadline.text = self.getEndDateText(day: goal.EndDay);
            self.initStatusImage(img: cell.imgStatus, status: goal.AchievementStatus);
        }
        
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedGoalId = self.items[indexPath.item].Id;
        
        self.performSegue(withIdentifier: "sgGoalEdit", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "sgGoalEdit") {
            
            let viewController = segue.destination as! GoalEditViewController
            viewController.goalId = selectedGoalId!
        }
    }
    
    private func getTargetText(target: Int, unit: String?, minMax: Int) -> String {
    
        let localUnit = (unit != nil && unit == "") ? "item(s)" : unit!;
        let result = String(target) + " " + localUnit;
    
        if (minMax == 2) {
            return result + " " + "or more";
        }
        else if (minMax == 3) {
            return result + " " + "or less";
        }
        else {
            return result;
        }
    }
    
    private func getEndDateText(day: Int) -> String {
    
        let today = Utils.GetToday();
        let daysLeft = day - today;
        let sDaysLeft = (daysLeft >= 0) ? " (" + String(daysLeft) + " days remaining)" : "";
        
        let df = DateFormatter()
        df.dateFormat = "d MMMM"
        return df.string(from: Utils.GetDate(day: day)) + sDaysLeft;
    }
    
    private func initStatusImage(img: UIImageView, status: Int) {
        
        img.image = img.image?.withRenderingMode(.alwaysTemplate)
        if (status == 1) {
            
            img.tintColor = UIColor.green
        }
        else if (status == 2) {
            
            img.image = UIImage(named: "clear")
            img.image = img.image?.withRenderingMode(.alwaysTemplate)
            img.tintColor = UIColor.red
        }
        else {
            
            img.tintColor = UIColor.gray
        }
        /*
    if (status == 1) {
    
    img.setColorFilter(ContextCompat.getColor(activity, R.color.colorAccent),
    android.graphics.PorterDuff.Mode.SRC_IN)
    }
    else if (status == 2) {
    
    img.setImageResource(R.drawable.ic_baseline_clear_24px)
    
    img.setColorFilter(ContextCompat.getColor(activity, android.R.color.holo_red_dark),
    android.graphics.PorterDuff.Mode.SRC_IN)
    }
    else {
    
    img.setColorFilter(ContextCompat.getColor(activity, android.R.color.darker_gray),
    android.graphics.PorterDuff.Mode.SRC_IN)
    }
        
        */
    }
}
