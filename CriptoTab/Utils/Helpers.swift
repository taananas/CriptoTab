//
//  Helpers.swift
//  CriptoTab
//
//  Created by Bogdan Zykov on 14.03.2023.
//

import Foundation


class Helpers{
    
    static let calendar = Calendar.current
    
    static func dayBefore(_ day: Int) -> Date{
        return calendar.date(byAdding: .day, value: -day, to: Date.now) ?? Date.now
    }
    
}
