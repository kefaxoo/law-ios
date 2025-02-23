//
//  TypeAnalyticsViewModelProtocol.swift
//  law
//
//  Created by Bahdan Piatrouski on 22.02.25.
//

import UIKit

protocol TypeAnalyticsViewModelProtocol {
    var isPeriodPublished: CPublisher<Bool> { get }
    var selectedStartPeriodPublished: CPublisher<Date?> { get }
    var selectedEndPeriodPublished: CPublisher<Date?> { get }
    
    var present: CPassthroughSubject<UIViewController> { get }
    var push: CPassthroughSubject<BaseViewController> { get }
    
    // MARK: - Actions
    func periodTextFieldDidSelect(isBegin: Bool)
    func setIsPeriod(_ value: Bool)
    func generateButtonDidTap()
}
