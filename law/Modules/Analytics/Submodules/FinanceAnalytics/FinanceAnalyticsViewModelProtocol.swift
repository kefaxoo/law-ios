//
//  FinanceAnalyticsViewModelProtocol.swift
//  law
//
//  Created by Bahdan Piatrouski on 22.02.25.
//

import UIKit

protocol FinanceAnalyticsViewModelProtocol {
    var financeAnalytics: [FinanceAnalyticsType] { get }
    var financeAnalyticsPublished: CPublisher<[FinanceAnalyticsType]> { get }
    
    var isTransactionTypePublished: CPublisher<Bool> { get }
    
    var selectedTransactionTypePublished: CPublisher<FinanceOperation.TransactionType?> { get }
    var transactionTypeActions: [UIAction] { get }
    
    var present: CPassthroughSubject<UIViewController> { get }
    
    func setIsTransactionType(_ value: Bool)
    func generationButtonDidTap()
}
