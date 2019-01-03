//
//  Goal.swift
//  myself
//
//  Created by Kemal Taskin on 02.01.19.
//  Copyright © 2019 Kelpersegg. All rights reserved.
//

import Foundation
import RealmSwift

class Goal : Object, Codable, BaseModel
{
    @objc public dynamic var Id = 0
    @objc public dynamic var TaskId = 0
    @objc public dynamic var MinMax = 0
    @objc public dynamic var Target = 0
    @objc public dynamic var StartDay = 0
    @objc public dynamic var EndDay = 0
    @objc public dynamic var AchievementStatus = 0
    @objc public dynamic var CurrentValue = 0
    @objc public dynamic var ModificationDate = Date()
    
    override class func primaryKey() -> String? { return "Id" }
    
    private enum CodingKeys: String, CodingKey {
        case Id = "Id"
        case TaskId = "TaskId"
        case MinMax = "MinMax"
        case Target = "Target"
        case StartDay = "StartDay"
        case EndDay = "EndDay"
        case AchievementStatus = "AchievementStatus"
        case CurrentValue = "CurrentValue"
        case ModificationDate = "ModificationDate"
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        Id = try container.decode(Int.self, forKey: .Id)
        TaskId = try container.decode(Int.self, forKey: .TaskId)
        MinMax = try container.decode(Int.self, forKey: .MinMax)
        Target = try container.decode(Int.self, forKey: .Target)
        StartDay = try container.decode(Int.self, forKey: .StartDay)
        EndDay = try container.decode(Int.self, forKey: .EndDay)
        AchievementStatus = try container.decode(Int.self, forKey: .AchievementStatus)
        CurrentValue = try container.decode(Int.self, forKey: .CurrentValue)
        ModificationDate = try container.decode(Date.self, forKey: .ModificationDate)
    }
    
    convenience init(_ id: Int, _ taskId: Int, minMax: Int, target: Int, startDay: Int,
                     endDay: Int, achievementStatus: Int, currentValue: Int, modificationDate: Date) {
        self.init()
        self.Id = id
        self.TaskId = taskId
        self.MinMax = minMax
        self.Target = target
        self.StartDay = startDay
        self.EndDay = endDay
        self.AchievementStatus = achievementStatus
        self.CurrentValue = currentValue
        self.ModificationDate = modificationDate
    }
    
    func toJSON() -> NSDictionary {
        return [
            "Id": self.Id,
            "TaskId": self.TaskId,
            "MinMax": self.MinMax,
            "Target": self.Target,
            "StartDay": self.StartDay,
            "EndDay": self.EndDay,
            "AchievementStatus": self.AchievementStatus,
            "CurrentValue": self.CurrentValue,
            "ModificationDate": DateFormatter.iso8601.string(from: self.ModificationDate)
        ]
    }
}
