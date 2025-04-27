//
//  FinanceAnalyticsType.swift
//  law
//
//  Created by Bahdan Piatrouski on 23.02.25.
//

import UIKit

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
    
    var value: String {
        switch self {
            case .commonIncome(let income):
                "\(income.twoDigitsString)"
            case .averageClientBill(let bill):
                "\(bill.twoDigitsString)"
            case .paidBills(let percent):
                "\(percent.twoDigitsString)%"
            case .accountsReceivables(let sum):
                "\(sum.twoDigitsString)"
        }
    }
    
    var icon: UIImage? {
        switch self {
            case .commonIncome:
                "💰".image(size: CGSize(width: 28, height: 28))
            case .averageClientBill:
                .contractIcon
            case .paidBills:
                .closed
            case .accountsReceivables:
                nil
        }
    }
    
    var title: String {
        switch self {
            case .commonIncome:
                "Общий доход:"
            case .averageClientBill:
                "Средний чек клиента:"
            case .paidBills:
                "Оплаченные счета:"
            case .accountsReceivables:
                "Сумма дебиторской задолженности:"
        }
    }
}
