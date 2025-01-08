//
//  UserDefaults+Ext.swift
//  law
//
//  Created by Bahdan Piatrouski on 9.01.25.
//

import Foundation

extension UserDefaults {
    func removeObject(for key: UserDefaultsKey) {
        self.removeObject(forKey: key.rawValue)
    }
}
