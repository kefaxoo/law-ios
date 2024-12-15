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
}
