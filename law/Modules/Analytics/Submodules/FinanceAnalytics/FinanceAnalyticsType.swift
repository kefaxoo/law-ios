//
//  FinanceAnalyticsType.swift
//  law
//
//  Created by Bahdan Piatrouski on 23.02.25.
//

import Foundation

fileprivate extension Double {
    var twoDigitsString: String {
        String(format: "%.2f", self)
    }
}

enum FinanceAnalyticsType {
    case commonIncome(income: Double)
    case averageClientBill(bill: Double)
    case paidBills(percent: Double)
    case accountsReceivables(sum: Double)
}

extension FinanceAnalyticsType {
    var text: String {
        switch self {
            case .commonIncome(let income):
                "💰 Общий доход: \(income.twoDigitsString)"
            case .averageClientBill(let bill):
                "👤 Средний чек клиента: \(bill.twoDigitsString)"
            case .paidBills(let percent):
                "💳 Оплаченные счета: \(percent.twoDigitsString)%"
            case .accountsReceivables(let sum):
                "Сумма дебиторской задолженности: \(sum.twoDigitsString)"
        }
    }
}
