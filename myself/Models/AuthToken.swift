//
//  AuthToken.swift
//  myself
//
//  Created by Kemal Taskin on 01.12.18.
//  Copyright © 2018 Kelpersegg. All rights reserved.
//

import Foundation

struct AuthToken : Decodable
{
    var Token: String?
    var ValidUntil: Date?
}
