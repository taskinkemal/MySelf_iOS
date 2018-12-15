//
//  Utils.swift
//  myself
//
//  Created by Kemal Taskin on 02.12.18.
//  Copyright © 2018 Kelpersegg. All rights reserved.
//

import Foundation

final class Utils {
    
    private static func GetDateZero() -> Date {
        
        var dateComponents = DateComponents()
        dateComponents.year = 2018
        dateComponents.month = 1
        dateComponents.day = 1
        
        // Create date from components
        let calendar = Calendar.current // user calendar
        return calendar.date(from: dateComponents)!
    }
    
    static func GetDay(date: Date) -> Int {
        
        // Create date from components
        let calendar = Calendar.current // user calendar
        let startDate = GetDateZero()
        
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: startDate)
        let date2 = calendar.startOfDay(for: date)
        
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        
        return components.day!
    }
    
    static func GetToday() -> Int {
    
        return GetDay(date: Date())
    }
    
    static func GetDayOfWeek(day: Int) -> String {
        
        let startDate = GetDateZero()
        
        var dateComponent = DateComponents()
        dateComponent.day = day
        
        let date = Calendar.current.date(byAdding: dateComponent, to: startDate)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date!).capitalized
    }
}
