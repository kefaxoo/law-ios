//
//  FinanceAnalyticsFilters.swift
//  law
//
//  Created by Bahdan Piatrouski on 23.02.25.
//

import Foundation

final class FinanceAnalyticsFilters {
    var isTransactionType = false
    var transactionType: FinanceOperation.TransactionType?
    
    var isClient = false
    var clientId: String?
}
