//
//  AddClientCaseViewModel.swift
//  law
//
//  Created by Bahdan Piatrouski on 17.12.24.
//

import UIKit

final class AddClientCaseViewModel: AddClientCaseViewModelProtocol {
    private let client: ClientInfo
    
    var clientCase: ClientCase?
    
    var caseTypeActions: [UIAction] {
        ClientCase.CaseType.allCases.compactMap { [weak self] caseType in
            UIAction(title: caseType.title) { _ in
                self?.setCaseType(caseType)
            }
        }
    }
    
    @Published private var selectedCaseType: ClientCase.CaseType = .criminal
    var selectedCaseTypePublished: CPublisher<ClientCase.CaseType> {
        $selectedCaseType.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
    var caseStatusActions: [UIAction] {
        ClientCase.Status.allCases.compactMap { [weak self] status in
            UIAction(title: status.title) { _ in
                self?.setStatus(status)
            }
        }
    }
    
    @Published private var selectedStatus: ClientCase.Status = .active
    var selectedCaseStatusPublished: CPublisher<ClientCase.Status> {
        $selectedStatus.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
    @Published var startDate: Date = Date()
    var startDatePublished: CPublisher<Date> {
        $startDate.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
    @Published var endDate: Date?
    var endDatePublished: CPublisher<Date?> {
        $endDate.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
    @Published var eventDates = [EventDate]()
    var eventDatesPublished: CPublisher<[EventDate]> {
        $eventDates.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
    var presentAlert = CPassthroughSubject<UIAlertController>()
    var popVC = CPassthroughSubject<Void>()
    
    init(client: ClientInfo, clientCase: ClientCase?) {
        self.client = client
        self.clientCase = clientCase
        if let clientCase {
            self.selectedCaseType = clientCase.type
            self.selectedStatus = clientCase.status
            self.eventDates = clientCase.eventDates?.enumerated().compactMap({ ($0.offset, $0.element.key, $0.element.value) }) ?? []
        }
    }
}

// MARK: - Actions
extension AddClientCaseViewModel {
    private func setCaseType(_ caseType: ClientCase.CaseType) {
        self.selectedCaseType = caseType
    }
    
    private func setStatus(_ status: ClientCase.Status) {
        self.selectedStatus = status
    }
    
    func setStartDate(_ date: Date) {
        self.startDate = date
    }
    
    func setEndDate(_ date: Date) {
        self.endDate = date
    }
    
    func addNewEventDate() {
        self.eventDates.append((self.eventDates.count, nil, nil))
    }
    
    func editNewEventDate(_ eventDate: EventDate) {
        guard let index = self.eventDates.firstIndex(where: { $0.0 == eventDate.0 }) else { return }
        
        if let event = eventDate.1 {
            self.eventDates[index].1 = event
        }
        
        if let date = eventDate.2 {
            self.eventDates[index].2 = date
        }
    }
    
    func addCase(_ eventDates: [EventDate]) {
        if let endDate,
           self.startDate.isSameDate(with: endDate) {
            self.presentAlert.send(UIAlertController(errorText: "Дата начала не может совпадать с датой окончания"))
            return
        }
        
        var events = [String: Date]()
        eventDates.filter { _, event, date in
            guard !(event?.isEmpty ?? true),
                  let date,
                  date >= self.startDate,
                  self.endDate == nil ? true : date <= self.endDate!
            else { return false }
            
            return true
        }.forEach {
            guard let event = $0.1,
                  let date = $0.2
            else { return }
            
            events[event] = date
        }
        
        self.endDate = self.selectedStatus == .active ? nil : (self.endDate ?? Date())
        
        if clientCase != nil {
            self.clientCase?.status = self.selectedStatus
            self.clientCase?.endDate = self.endDate?.timeIntervalSince1970
            self.clientCase?.eventDates = events.isEmpty ? nil : events
            DatabaseService.shared.saveChanges()
        } else {
            let clientCase = ClientCase(clientId: self.client.id, type: self.selectedCaseType, status: self.selectedStatus, startDate: self.startDate, endDate: self.endDate, eventDates: events.isEmpty ? nil : events)
            DatabaseService.shared.saveObject(clientCase)
        }
        
        NotificationCenter.default.post(name: .fetchClientCasesInfo, object: nil)
        self.popVC.send(())
    }
}
