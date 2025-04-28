//
//  User.swift
//  law
//
//  Created by Bahdan Piatrouski on 9.01.25.
//

import Foundation
import SwiftData
import CryptoKit

@Model final class User: Decodable {
    enum Role: String, Codable, CaseIterable {
        case lawyer
        case client
        
        var title: String {
            switch self {
                case .lawyer:
                    "Адвокат"
                case .client:
                    "Клиент"
            }
        }
        
        var opposite: Role {
            switch self {
                case .lawyer:
                    .client
                case .client:
                    .lawyer
            }
        }
    }
    
    @Attribute(.unique) var id: String
    @Attribute(.unique) var login: String
    var password: String
    var role: Role?
    
    enum CodingKeys: CodingKey {
        case login
        case password
        case role
    }
    
    init(id: String = UUID().uuidString, login: String, password: String, role: Role?) {
        self.id = id
        self.login = login
        self.password = Self.hashPassword(password)
        self.role = role
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = UUID().uuidString
        self.login = try container.decode(String.self, forKey: .login)
        self.password = Self.hashPassword(try container.decode(String.self, forKey: .password))
        self.role = Role(rawValue: try container.decode(String.self, forKey: .role))
    }
    
    private static func hashPassword(_ password: String) -> String {
        let digest = SHA256.hash(data: Data(password.utf8))
        return digest.map { String(format: "%02x", $0) }.joined()
    }
    
    func isPasswordValid(_ password: String) -> Bool {
        return User.hashPassword(password) == self.password
    }
}
