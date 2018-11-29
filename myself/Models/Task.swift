//
//  Task.swift
//  myself
//
//  Created by Kemal Taskin on 26.11.18.
//  Copyright © 2018 Kelpersegg. All rights reserved.
//

import Foundation

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

struct Task : Codable
{
    var Id: Int?
    var Label: String?
    var DataType: Int?
    var Unit: String?
    var HasGoal: Bool?
    var GoalMinMax: Int?
    var Goal: Int?
    var GoalTimeFrame: Int?
    var Status: Int?
    var ModificationDate: Date?
    var AutomationType: Int?
    var AutomationVar: String?
}
