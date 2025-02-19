//
//  AddFinanceOperationViewModelProtocol.swift
//  law
//
//  Created by Bahdan Piatrouski on 17.02.25.
//

import UIKit

protocol AddFinanceOperationViewModelProtocol {
    var statusMenu: UIMenu { get }
    var currentStatusPublished: CPublisher<FinanceOperation.Status> { get }
    
    var paymentMethodMenu: UIMenu { get }
    var currentPaymentMethodPublished: CPublisher<FinanceOperation.PaymentMethod> { get }
    
    var transactionTypeMenu: UIMenu { get }
    var currentTransactionTypePublished: CPublisher<FinanceOperation.TransactionType> { get }
    
    var selectedClientPublished: CPublisher<ClientInfo?> { get }
    var selectedCasePublished: CPublisher<ClientCase?> { get }
    
    var showChooseClientScreen: CPassthroughSubject<Void> { get }
    var showChooseCaseScreen: CPassthroughSubject<ClientInfo> { get }
    
    var present: CPassthroughSubject<UIViewController> { get }
    var pop: CPassthroughSubject<Void> { get }
    
    func clientButtonDidTap()
    func setSelectedClient(_ client: ClientInfo)
    
    func caseButtonDidTap()
    func setSelectedCase(_ case: ClientCase)
    
    func addOperation(amount: String?)
}
