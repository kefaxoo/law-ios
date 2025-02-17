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
}
