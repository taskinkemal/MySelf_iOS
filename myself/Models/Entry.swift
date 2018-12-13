//
//  Entry.swift
//  myself
//
//  Created by Kemal Taskin on 02.12.18.
//  Copyright © 2018 Kelpersegg. All rights reserved.
//

import Foundation
import RealmSwift

class Entry : Object, Codable, BaseModel
{
    @objc public dynamic var Day = 0
    @objc public dynamic var TaskId = 0
    @objc public dynamic var Value = 0
    @objc public dynamic var ModificationDate = Date()
    @objc public dynamic var compoundKey = ""
    
    override static func primaryKey() -> String? {
        return "compoundKey"
    }
    
    func compoundKeyValue() -> String {
        return "\(Day)\(TaskId)"
    }
    
    private enum CodingKeys: String, CodingKey {
        case Day = "Day"
        case TaskId = "TaskId"
        case Value = "Value"
        case ModificationDate = "ModificationDate"
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        Day = try container.decode(Int.self, forKey: .Day)
        TaskId = try container.decode(Int.self, forKey: .TaskId)
        Value = try container.decode(Int.self, forKey: .Value)
        ModificationDate = try container.decode(Date.self, forKey: .ModificationDate)
        compoundKey = self.compoundKeyValue()
    }
    
    convenience init(_ day: Int, _ taskId: Int, value: Int, modificationDate: Date) {
        self.init()
        self.Day = day
        self.TaskId = taskId
        self.Value = value
        self.ModificationDate = modificationDate
    }
    
    func toJSON() -> NSDictionary {
        return [
            "Day": self.Day,
            "TaskId": self.TaskId,
            "Value": self.Value,
            "ModificationDate": self.ModificationDate
        ]
    }
}
