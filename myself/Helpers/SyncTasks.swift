//
//  SyncTasks.swift
//  myself
//
//  Created by Kemal Taskin on 07.12.18.
//  Copyright © 2018 Kelpersegg. All rights reserved.
//

import Foundation

class SyncTasks {
    
    var controller: TasksViewController?
    
    func Run(controller: TasksViewController) {
        
        self.controller = controller;
        
        HttpRequest.send(url: "tasks",
                         method: "GET",
                         data: nil,
                         cbSuccess: CallbackTasksSuccess,
                         cbError: CallbackError);
    }
    
    func CallbackError(statusCode:Int, message: String)
    {
    }
    
    func CallbackTasksSuccess(list:ListWrapper<Task>)
    {
        DispatchQueue.main.async {
            
            for task in list.Items {
                RealmHelper.SaveTask(task: task)
            }
            
            let today = Utils.GetToday()
            let start = today - 5;
            
            HttpRequest.send(url: "entries?start="+String(start)+"&end="+String(today),
                             method: "GET",
                             data: nil,
                             cbSuccess: self.CallbackEntriesSuccess,
                             cbError: self.CallbackError);
        }
    }
    
    func CallbackEntriesSuccess(list:ListWrapper<Entry>)
    {
        DispatchQueue.main.async {
            
            for entry in list.Items {
                
                let existing = RealmHelper.GetEntry(day: entry.Day, taskId: entry.TaskId)
                
                if (existing == nil || entry.ModificationDate > existing!.ModificationDate) {
                    
                    RealmHelper.SaveEntry(entry: entry)
                }
                else if (existing != nil) {
                    
                    RealmHelper.UploadEntry(entry: existing!)
                }
            }
            
            self.controller!.ListLoaded(list: RealmHelper.GetTaskEntries(day: Utils.GetToday()))
            
        }
    }
}
