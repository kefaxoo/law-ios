//
//  CalendarEvent.swift
//  law
//
//  Created by Bahdan Piatrouski on 6.01.25.
//

import Foundation
import SwiftData

@Model final class CalendarEvent {
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
}
