//
//  ClientDocument.swift
//  law
//
//  Created by Bahdan Piatrouski on 11.01.25.
//

import Foundation
import SwiftData

@Model final class ClientDocument {
    enum DocumentType: Codable, CaseIterable {
        case pasport
        case contract // договор
        case attorney // доверенность
        
        var title: String {
            switch self {
                case .pasport:
                    "Паспорт"
                case .contract:
                    "Договор"
                case .attorney:
                    "Доверенность"
            }
        }
    }
    
    @Attribute(.unique) var id: String
    var title: String
    var type: DocumentType
    var uploadDate: TimeInterval
    var filePath: String
    
    init(
        id: String = UUID().uuidString,
        title: String,
        type: DocumentType,
        uploadDate: TimeInterval,
        filePath: String
    ) {
        self.id = id
        self.title = title
        self.type = type
        self.uploadDate = uploadDate
        self.filePath = filePath
    }
}
