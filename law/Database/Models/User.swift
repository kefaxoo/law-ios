//
//  User.swift
//  law
//
//  Created by Bahdan Piatrouski on 9.01.25.
//

import Foundation
import SwiftData

@Model final class User: Decodable {
    @Attribute(.unique) var id: String
    @Attribute(.unique) var login: String
    var password: String
    
    enum CodingKeys: CodingKey {
        case login
        case password
    }
    
    init(id: String = UUID().uuidString, login: String, password: String) {
        self.id = id
        self.login = login
        self.password = password
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = UUID().uuidString
        self.login = try container.decode(String.self, forKey: .login)
        self.password = try container.decode(String.self, forKey: .password)
    }
}
