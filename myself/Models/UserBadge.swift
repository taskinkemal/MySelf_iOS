//
//  UserBadge.swift
//  myself
//
//  Created by Kemal Taskin on 23.12.18.
//  Copyright © 2018 Kelpersegg. All rights reserved.
//

import Foundation
import RealmSwift

class UserBadge : Object, Codable, BaseModel
{
    @objc public dynamic var BadgeId = 0
    @objc public dynamic var Level = 0
    @objc public dynamic var ModificationDate = Date()
    
    override static func primaryKey() -> String? {
        return "BadgeId"
    }
    
    private enum CodingKeys: String, CodingKey {
        case BadgeId = "BadgeId"
        case Level = "Level"
        case ModificationDate = "ModificationDate"
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        BadgeId = try container.decode(Int.self, forKey: .BadgeId)
        Level = try container.decode(Int.self, forKey: .Level)
        ModificationDate = try container.decode(Date.self, forKey: .ModificationDate)
        
    }
    
    convenience init(_ badgeId: Int, _ level: Int, modificationDate: Date) {
        self.init()
        self.BadgeId = badgeId
        self.Level = level
        ModificationDate = modificationDate
    }
    
    func toJSON() -> NSDictionary {
        return [
            "BadgeId": self.BadgeId,
            "Level": self.Level,
            "ModificationDate": DateFormatter.iso8601.string(from: self.ModificationDate)
        ]
    }
}
