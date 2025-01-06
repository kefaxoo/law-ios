//
//  AddClientCaseViewModelProtocol.swift
//  law
//
//  Created by Bahdan Piatrouski on 17.12.24.
//

import UIKit

protocol AddClientCaseViewModelProtocol {
    typealias EventDate = (index: Int, text: String?, date: Date?)
    
    var clientCase: ClientCase? { get }
    
    var caseTypeActions: [UIAction] { get }
    var selectedCaseTypePublished: CPublisher<ClientCase.CaseType> { get }
    
    var caseStatusActions: [UIAction] { get }
    var selectedCaseStatusPublished: CPublisher<ClientCase.Status> { get }
    
    var startDate: Date { get }
    var startDatePublished: CPublisher<Date> { get }
    func setStartDate(_ date: Date)
    
    var endDate: Date? { get }
    var endDatePublished: CPublisher<Date?> { get }
    func setEndDate(_ date: Date)
    
    var eventDates: [EventDate] { get }
    var eventDatesPublished: CPublisher<[EventDate]> { get }
    func addNewEventDate()
    func editNewEventDate(_ eventDate: EventDate)
    
    var presentAlert: CPassthroughSubject<UIAlertController> { get }
    var popVC: CPassthroughSubject<Void> { get }
    
    func addCase(_ eventDates: [EventDate])
}
