//
//  AddEventViewModelProtocol.swift
//  law
//
//  Created by Bahdan Piatrouski on 06.01.25.
//

import UIKit
import MessageUI

protocol AddEventViewModelProtocol {
    var eventTypeActions: [UIAction] { get }
    var selectedEventTypePublished: CPublisher<CalendarEvent.EventType> { get }
    
    var pushVC: CPassthroughSubject<BaseViewController> { get }
    
    var selectedClientPublished: CPublisher<ClientInfo?> { get }
    var selectedCasePublished: CPublisher<ClientCase?> { get }
    
    var present: CPassthroughSubject<UIViewController> { get }
    var presentMailVC: CPassthroughSubject<MFMailComposeViewController> { get }
    
    var popVC: CPassthroughSubject<Void> { get }
    
    var eventToShowPublished: CPublisher<CalendarEvent?> { get }
    
    var isReminderPublished: CPublisher<Bool> { get }
    var selectedReminderPeriodPublished: CPublisher<ReminderPeriod?> { get }
    var remindersActions: [UIAction] { get }
    
    func setDate(_ date: Date)
    
    func clientButtonDidTap(delegate: ChooseClientDelegate?)
    func setSelectedClient(_ client: ClientInfo)
    
    func caseButtonDidTap(delegate: ChooseCaseDelegate?)
    func setSelectedCase(_ case: ClientCase)
    
    func addButtonDidTap(title: String?, description: String?, location: String?)
    
    func setIsReminder(_ value: Bool)
}
