//
//  ClientCase.swift
//  law
//
//  Created by Bahdan Piatrouski on 17.12.24.
//

import Foundation
import SwiftData

@Model final class ClientCase {
    typealias EventDates = [String: Date]
    
    enum CaseType: Codable, CaseIterable {
        case criminal // уголовное
        case civil // гражданское
        case administrative // административное
        
        var title: String {
            switch self {
                case .criminal:
                    "Уголовное"
                case .civil:
                    "Гражданское"
                case .administrative:
                    "Администрирование"
            }
        }
    }
    
    enum Status: Codable, CaseIterable {
        case active // активное
        case closed // завершенное
        case archived // архив
        
        var title: String {
            switch self {
                case .active:
                    "Активное"
                case .closed:
                     "Завершенное"
                case .archived:
                    "Архив"
            }
        }
    }
    
    @Attribute(.unique) var id: String
    var clientId: String
    var type: CaseType
    var status: ClientCase.Status
    var startDate: TimeInterval
    var endDate: TimeInterval?
    var eventDates: EventDates?
    
    var title: String {
        "\(self.type.title)\nДата начала: \(self.startDate.toDate(withFormat: "dd.MM.yyyy"))"
    }
    
    init(
        id: String = UUID().uuidString,
        clientId: String,
        type: CaseType,
        status: ClientCase.Status,
        startDate: Date,
        endDate: Date? = nil,
        eventDates: EventDates? = nil
    ) {
        self.id = id
        self.clientId = clientId
        self.type = type
        self.status = status
        self.startDate = startDate.timeIntervalSince1970
        self.endDate = endDate?.timeIntervalSince1970
        self.eventDates = eventDates
    }
}
