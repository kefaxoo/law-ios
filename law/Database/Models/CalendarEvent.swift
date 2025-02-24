//
//  CalendarEvent.swift
//  law
//
//  Created by Bahdan Piatrouski on 6.01.25.
//

import Foundation
import SwiftData

@Model final class CalendarEvent: Decodable {
    enum EventType: Codable, CaseIterable {
        case meeting // встреча
        case courtSession // судебное заседание
        case deadlineSubmissionDocuments // срок подачи документов
        
        var title: String {
            switch self {
                case .meeting:
                    "Встреча"
                case .courtSession:
                    "Судебное заседание"
                case .deadlineSubmissionDocuments:
                    "Срок подачи документов"
            }
        }
    }
    
    @Attribute(.unique) var id: String
    var eventType: EventType
    var name: String
    var eventDescription: String?
    var date: TimeInterval
    var location: String?
    var clientId: String
    var caseId: String
    var laywerId: String
    
    enum CodingKeys: CodingKey {
        case eventType
        case name
        case eventDescription
        case date
        case location
        case clientId
        case caseId
        case laywerId
    }
    
    var calendarScreenText: String {
        """
        Название события: \(self.name)
        Тип события: \(self.eventType.title)\(self.eventType != .deadlineSubmissionDocuments ? "\nМесто события: \(self.location ?? "n/a")" : "")
        """
    }
    
    init(
        id: String = UUID().uuidString,
        eventType: EventType,
        name: String,
        description: String?,
        date: Date,
        location: String?,
        clientId: String,
        caseId: String,
        laywerId: String
    ) {
        self.id = id
        self.eventType = eventType
        self.name = name
        self.eventDescription = description
        self.date = date.timeIntervalSince1970
        self.location = location
        self.clientId = clientId
        self.caseId = caseId
        self.laywerId = laywerId
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = UUID().uuidString
        let eventType = try container.decode(String.self, forKey: .eventType)
        self.eventType = switch eventType {
            case "courtSession":
                .courtSession
            case "deadlineSubmissionDocuments":
                .deadlineSubmissionDocuments
            default:
                .meeting
        }
        
        self.name = try container.decode(String.self, forKey: .name)
        self.eventDescription = try container.decodeIfPresent(String.self, forKey: .eventDescription)
        
        self.date = try container.decode(TimeInterval.self, forKey: .date)
        
        self.location = try container.decodeIfPresent(String.self, forKey: .location)
        self.clientId = try container.decode(String.self, forKey: .clientId)
        self.caseId = try container.decode(String.self, forKey: .caseId)
        self.laywerId = try container.decode(String.self, forKey: .laywerId)
    }
}
