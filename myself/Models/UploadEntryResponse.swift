//
//  UploadEntryResponse.swift
//  myself
//
//  Created by Kemal Taskin on 23.12.18.
//  Copyright © 2018 Kelpersegg. All rights reserved.
//

import Foundation

struct UploadEntryResponse : Decodable
{
    var Score: Int?
    var NewBadges: [UserBadge]?
}
