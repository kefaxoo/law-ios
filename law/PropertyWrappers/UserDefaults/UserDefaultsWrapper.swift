//
//  UserDefaultsWrapper.swift
//  law
//
//  Created by Bahdan Piatrouski on 9.01.25.
//

import Foundation

@propertyWrapper struct UserDefaultsWrapper<T> {
    private let key: UserDefaultsKey
    private let defaultValue: T
    
    init(key: UserDefaultsKey, value: T) {
        self.key = key
        self.defaultValue = value
    }
    
    var wrappedValue: T {
        get {
            UserDefaults.standard.value(forKey: self.key.rawValue) as? T ?? self.defaultValue
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: self.key.rawValue)
        }
    }
}
