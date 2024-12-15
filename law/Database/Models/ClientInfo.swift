//
//  ClientInfo.swift
//  law
//
//  Created by Bahdan Piatrouski on 16.12.24.
//

import Foundation
import SwiftData

@Model final class ClientInfo {
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
}
