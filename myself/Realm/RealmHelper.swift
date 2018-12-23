//
//  RealmHelper.swift
//  myself
//
//  Created by Kemal Taskin on 07.12.18.
//  Copyright © 2018 Kelpersegg. All rights reserved.
//

import Foundation
import RealmSwift

final class RealmHelper {
    
    static func SaveTask(task: Task) {
        
        let realm = try! Realm()
        
        try! realm.write {
            
            realm.add(task, update: true)
            try! realm.commitWrite()
        }
    }
    
    static func SaveEntry(entry: Entry) {
        
        let realm = try! Realm()
        
        try! realm.write {
            
            realm.add(entry, update: true)
            try! realm.commitWrite()
        }
    }
    
    static func GetEntry(day: Int, taskId: Int) -> Entry? {
        
        let realm = try! Realm()
        
        let entries = realm.objects(Entry.self).filter("Day = %@ and TaskId = %@", day, taskId)
        
        if (entries.count == 1) {
            return entries.first
        }
        else {
            return nil
        }
    }
    
    static func GetTask(id: Int) -> Task? {
        
        let realm = try! Realm()
        
        let tasks = realm.objects(Task.self).filter("Id = %@", id)
        
        if (tasks.count == 1) {
            return tasks.first
        }
        else {
            return nil
        }
    }
    
    static func GetTaskEntries(day: Int) -> [TaskEntry] {
        
        let realm = try! Realm()
        
        let tasks = Array(realm.objects(Task.self))
        let entries = realm.objects(Entry.self).filter("Day = %@", day)
        
        var taskEntries = [TaskEntry].init()
        
        for task in tasks {
            
            let filteredEntries = Array(entries.filter("TaskId = %@", task.Id))
            
            var taskEntry = TaskEntry()
            taskEntry.task = task
            
            if (filteredEntries.count == 1) {
                taskEntry.entry = filteredEntries.first
            }
            else {
                taskEntry.entry = Entry(day, task.Id, value: 0, modificationDate: Date())
            }
            
            
            taskEntries.append(taskEntry)
        }
        
        return taskEntries
    }
    
    static func CallbackError(statusCode:Int, message: String)
    {
    }
    
    static func CallbackSuccessUploadEntry(result:JsonResult<UploadEntryResponse>)
    {
    }
    
    static func UploadEntry(entry:Entry)
    {
        HttpRequest.send(url: "entries",
                         method: "POST",
                         data: entry,
                         cbSuccess: CallbackSuccessUploadEntry,
                         cbError: CallbackError);
    }
}
