//
//  User.swift
//  law
//
//  Created by Bahdan Piatrouski on 9.01.25.
//

import Foundation
import SwiftData

@Model final class User {
    @Attribute(.unique) var id: String
    @Attribute(.unique) var login: String
    var password: String
    
    init(id: String = UUID().uuidString, login: String, password: String) {
        self.id = id
        self.login = login
        self.password = password
    }
}
