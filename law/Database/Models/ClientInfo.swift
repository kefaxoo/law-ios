//
//  ClientInfo.swift
//  law
//
//  Created by Bahdan Piatrouski on 16.12.24.
//

import Foundation
import SwiftData

@Model final class ClientInfo: Decodable {
    enum ClientType: Codable, CaseIterable {
        case natural // физическое
        case legal // юридическое
        
        var title: String {
            switch self {
                case .natural:
                    "Физическое лицо"
                case .legal:
                    "Юридическое лицо"
            }
        }
    }
    
    @Attribute(.unique) var id: String
    var lastName: String
    var firstName: String
    var fatherName: String?
    var birthDateTimestamp: TimeInterval
    var phoneNumber: String
    var email: String
    var address: String
    var clientType: ClientType
    
    var fullName: String {
        "\(self.lastName) \(self.firstName) \(self.fatherName ?? "")"
    }
    
    enum CodingKeys: CodingKey {
        case id
        case lastName
        case firstName
        case fatherName
        case birthDateTimestamp
        case phoneNumber
        case email
        case address
        case clientType
    }
    
    init(
        id: String = UUID().uuidString,
        lastName: String,
        firstName: String,
        fatherName: String? = nil,
        birthDateTimestamp: TimeInterval,
        phoneNumber: String,
        email: String,
        address: String,
        clientType: ClientType
    ) {
        self.id = id
        self.lastName = lastName
        self.firstName = firstName
        self.fatherName = fatherName
        self.birthDateTimestamp = birthDateTimestamp
        self.phoneNumber = phoneNumber
        self.email = email
        self.address = address
        self.clientType = clientType
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = UUID().uuidString
        self.lastName = try container.decode(String.self, forKey: .lastName)
        self.firstName = try container.decode(String.self, forKey: .firstName)
        self.fatherName = try container.decodeIfPresent(String.self, forKey: .fatherName)
        self.birthDateTimestamp = try container.decode(TimeInterval.self, forKey: .birthDateTimestamp)
        self.phoneNumber = try container.decode(String.self, forKey: .phoneNumber)
        self.email = try container.decode(String.self, forKey: .email)
        self.address = try container.decode(String.self, forKey: .address)
        
        let clientType = try container.decode(String.self, forKey: .clientType)
        self.clientType = clientType == "legal" ? .legal : .natural
    }
}
