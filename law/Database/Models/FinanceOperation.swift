//
//  FinanceOperation.swift
//  law
//
//  Created by Bahdan Piatrouski on 17.02.25.
//

import Foundation
import SwiftData

@Model final class FinanceOperation: Decodable {
    enum TransactionType: Codable, CaseIterable {
        case servicePayment // оплата услуг
        case legalFees // судебные издержки
        case refund // возврат
        
        var title: String {
            switch self {
                case .servicePayment:
                    "Оплата услуг"
                case .legalFees:
                    "Судебные издержки"
                case .refund:
                    "Возврат"
            }
        }
    }
    
    enum Status: Codable, CaseIterable {
        case done
        case pending // в ожидании
        case canceled
        
        var title: String {
            switch self {
                case .done:
                    "Завершена"
                case .pending:
                    "В ожидании"
                case .canceled:
                    "Отменена"
            }
        }
    }
    
    enum PaymentMethod: Codable, CaseIterable {
        case cash
        case card
        case bankTransfer // банковский перевод
        
        var title: String {
            switch self {
                case .cash:
                    "Наличные"
                case .card:
                    "Карта"
                case .bankTransfer:
                    "Банковский перевод"
            }
        }
    }
    
    @Attribute(.unique) var id: String
    var clientId: String
    var caseId: String
    var amount: Double
    var transactionType: TransactionType
    var status: Status
    var paymentMethod: PaymentMethod
    
    enum CodingKeys: CodingKey {
        case clientId
        case caseId
        case amount
        case transactionType
        case status
        case paymentMethod
    }
    
    init(
        id: String = UUID().uuidString,
        clientId: String,
        caseId: String,
        amount: Double,
        transactionType: TransactionType,
        status: Status,
        paymentMethod: PaymentMethod
    ) {
        self.id = id
        self.clientId = clientId
        self.caseId = caseId
        self.amount = amount
        self.transactionType = transactionType
        self.status = status
        self.paymentMethod = paymentMethod
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = UUID().uuidString
        self.clientId = try container.decode(String.self, forKey: .clientId)
        self.caseId = try container.decode(String.self, forKey: .caseId)
        self.amount = try container.decode(Double.self, forKey: .amount)
        
        let transactionType = try container.decode(String.self, forKey: .transactionType)
        self.transactionType = switch transactionType {
            case "legalFees":
                .legalFees
            case "refund":
                .refund
            default:
                .servicePayment
        }
        
        let status = try container.decode(String.self, forKey: .status)
        self.status = switch status {
            case "pending":
                .pending
            case "cancelled":
                .canceled
            default:
                .done
        }
        
        let paymentMethod = try container.decode(String.self, forKey: .paymentMethod)
        self.paymentMethod = switch paymentMethod {
            case "card":
                .card
            case "bankTransfer":
                .bankTransfer
            default:
                .cash
        }
    }
}
