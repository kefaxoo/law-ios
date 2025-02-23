//
//  ReminderPeriod.swift
//  law
//
//  Created by Bahdan Piatrouski on 24.02.25.
//

import Foundation

enum ReminderPeriod: CaseIterable {
    case oneHour
    case twoHours
    case twelveHours
    case oneDay
}

extension ReminderPeriod {
    var title: String {
        switch self {
            case .oneHour:
                "Один час"
            case .twoHours:
                "Два часа"
            case .twelveHours:
                "12 часов"
            case .oneDay:
                "Один день"
        }
    }
    
    var timeInterval: TimeInterval {
        switch self {
            case .oneHour:
                3600
            case .twoHours:
                7200
            case .twelveHours:
                43200
            case .oneDay:
                86400
        }
    }
}
