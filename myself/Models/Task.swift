//
//  Task.swift
//  myself
//
//  Created by Kemal Taskin on 26.11.18.
//  Copyright © 2018 Kelpersegg. All rights reserved.
//

import Foundation
import RealmSwift

struct ListWrapper<T : Codable> : Codable
{
    var Items: [T]
    var Count: Int?
    
    /*
    enum CodingKeys : String, CodingKey
    {
        case Items = "Items"
        case Count = "Count"
    }
    */
}

class Task : Object, Codable, BaseModel
{
    @objc public dynamic var Id = 0
    @objc public dynamic var Label = ""
    @objc public dynamic var DataType = 0
    @objc public dynamic var Unit: String? = nil
    @objc public dynamic var HasGoal = false
    @objc public dynamic var GoalMinMax = 0
    @objc public dynamic var Goal = 0
    @objc public dynamic var GoalTimeFrame = 0
    @objc public dynamic var Status = 0
    @objc public dynamic var ModificationDate = Date()
    @objc public dynamic var AutomationType = 0
    @objc public dynamic var AutomationVar: String? = nil
    
    override class func primaryKey() -> String? { return "Id" }
    
    private enum CodingKeys: String, CodingKey {
        case Id = "Id"
        case Label = "Label"
        case DataType = "DataType"
        case Unit = "Unit"
        case HasGoal = "HasGoal"
        case GoalMinMax = "GoalMinMax"
        case Goal = "Goal"
        case GoalTimeFrame = "GoalTimeFrame"
        case Status = "Status"
        case ModificationDate = "ModificationDate"
        case AutomationType = "AutomationType"
        case AutomationVar = "AutomationVar"
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        Id = try container.decode(Int.self, forKey: .Id)
        Label = try container.decode(String.self, forKey: .Label)
        DataType = try container.decode(Int.self, forKey: .DataType)
        Unit = try container.decodeIfPresent(String.self, forKey: .Unit)
        HasGoal = try container.decode(Bool.self, forKey: .HasGoal)
        GoalMinMax = try container.decode(Int.self, forKey: .GoalMinMax)
        Goal = try container.decode(Int.self, forKey: .Goal)
        GoalTimeFrame = try container.decode(Int.self, forKey: .GoalTimeFrame)
        Status = try container.decode(Int.self, forKey: .Status)
        ModificationDate = try container.decode(Date.self, forKey: .ModificationDate)
        AutomationType = try container.decodeIfPresent(Int.self, forKey: .AutomationType) ?? 0
        AutomationVar = try container.decodeIfPresent(String.self, forKey: .AutomationVar)
        
        /*if let date = DateFormatter.iso8601.date(from: modificationDateStr) {
            ModificationDate = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .ModificationDate,
                                                   in: container,
                                                   debugDescription: "Date string does not match format expected by formatter.")
        }*/
    }
    
    convenience init(_ id: Int, _ label: String, dataType: Int, unit: String, hasGoal: Bool,
                     goalMinMax: Int, goal: Int, goalTimeFrame: Int, status: Int,
                     modificationDate: Date, automationType: Int, automationVar: String) {
        self.init()
        self.Id = id
        self.Label = label
        self.DataType = dataType
        self.Unit = unit
        self.HasGoal = hasGoal
        self.GoalMinMax = goalMinMax
        self.Goal = goal
        self.GoalTimeFrame = goalTimeFrame
        self.Status = status
        self.ModificationDate = modificationDate
        self.AutomationType = automationType
        self.AutomationVar = automationVar
    }
    
    func toJSON() -> NSDictionary {
        return [
            "Id": self.Id,
            "Label": self.Label,
            "DataType": self.DataType,
            "Unit": self.Unit!,
            "HasGoal": self.HasGoal,
            "GoalMinMax": self.GoalMinMax,
            "Goal": self.Goal,
            "GoalTimeFrame": self.GoalTimeFrame,
            "Status": self.Status,
            "AutomationType": self.AutomationType,
            "AutomationVar": self.AutomationVar!,
            "ModificationDate": DateFormatter.iso8601.string(from: self.ModificationDate)
        ]
    }
}
