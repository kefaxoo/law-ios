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
}
