//
//  ClientInteractionHistory.swift
//  law
//
//  Created by Bahdan Piatrouski on 16.12.24.
//

import Foundation
import SwiftData

@Model final class ClientInteractionHistory {
    enum InteractionType: Codable {
        case call
        case meeting
        case letter
        case sms
        case email
        
        var title: String {
            switch self {
                case .call:
                    "Звонок"
                case .meeting:
                    "Встреча"
                case .letter:
                    "Письмо"
                case .sms:
                    "СМС"
                case .email:
                    "Электронное письмо"
            }
        }
    }
    
    @Attribute(.unique) var id: String
    var interactionTimestamp: TimeInterval
    var interactionType: InteractionType
    var interactionDescription: String? // результат переговоров, договоренности
    var employeeId: String // кто взаимодействовал с клиентом
    
    init(
        id: String = UUID().uuidString,
        interactionTimestamp: TimeInterval,
        interactionType: InteractionType,
        interactionDescription: String? = nil,
        employeeId: String
    ) {
        self.id = id
        self.interactionTimestamp = interactionTimestamp
        self.interactionType = interactionType
        self.interactionDescription = interactionDescription
        self.employeeId = employeeId
    }
}
