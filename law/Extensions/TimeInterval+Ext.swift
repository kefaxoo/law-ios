//
//  TimeInterval+Ext.swift
//  law
//
//  Created by Bahdan Piatrouski on 16.12.24.
//

import Foundation

extension TimeInterval {
    func toDate(withFormat format: String) -> String {
        let date = Date(timeIntervalSince1970: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    var toDate: Date {
        Date(timeIntervalSince1970: self)
    }
    
    static func ==(lhs: TimeInterval, rhs: DateComponents?) -> Bool {
        guard let rhs else { return false }
        
        let lhs = Calendar.current.dateComponents([.day, .month, .year], from: lhs.toDate)
        return lhs.day == rhs.day && lhs.month == rhs.month && lhs.year == rhs.year
    }
    
    func dateComponents(components: Calendar.Component...) -> DateComponents {
        Calendar.current.dateComponents(Set(components), from: self.toDate)
    }
}
