//
//  JsonResult.swift
//  myself
//
//  Created by Kemal Taskin on 15.12.18.
//  Copyright © 2018 Kelpersegg. All rights reserved.
//

import Foundation

struct JsonResult<T: Decodable> : Decodable
{
    var Value: T
}
