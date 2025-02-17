//
//  FinanceOperation.swift
//  law
//
//  Created by Bahdan Piatrouski on 17.02.25.
//

import Foundation
import SwiftData

@Model final class FinanceOperation {
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
}
