//
//  Date+Ext.swift
//  law
//
//  Created by Bahdan Piatrouski on 22.12.24.
//

import Foundation

extension Date {
    func isSameDate(with date: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: date)
    }
    
    static var max: Self? {
        var maxDateComponents = DateComponents()
        maxDateComponents.year = 9999
        maxDateComponents.month = 12
        maxDateComponents.day = 31
        maxDateComponents.hour = 23
        maxDateComponents.minute = 59
        maxDateComponents.second = 59
        
        return Calendar.current.date(from: maxDateComponents)
    }
    
    static var currentDate: Self? {
        Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())
    }
    
    func toDateFormat(_ dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self)
    }
}
