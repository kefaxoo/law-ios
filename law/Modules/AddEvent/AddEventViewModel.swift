//
//  AddEventViewModel.swift
//  law
//
//  Created by Bahdan Piatrouski on 06.01.25.
//

import UIKit

final class AddEventViewModel: AddEventViewModelProtocol {
    var eventTypeActions: [UIAction] {
        CalendarEvent.EventType.allCases.compactMap { [weak self] eventType in
            UIAction(title: eventType.title) { _ in
                self?.setEventType(eventType)
            }
        }
    }
    
    @Published var selectedEventType = CalendarEvent.EventType.meeting
    var selectedEventTypePublished: CPublisher<CalendarEvent.EventType> {
        $selectedEventType.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
    @Published var date = Date()
    
    var pushVC = CPassthroughSubject<BaseViewController>()
    
    @Published var selectedClient: ClientInfo?
    var selectedClientPublished: CPublisher<ClientInfo?> {
        $selectedClient.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
    @Published var selectedCase: ClientCase?
    var selectedCasePublished: CPublisher<ClientCase?> {
        $selectedCase.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
    @UserDefaultsWrapper(key: .currentUserId, value: nil)
    private var currentUserId: String?
    
    var presentAlert = CPassthroughSubject<UIAlertController>()
    var popVC = CPassthroughSubject<Void>()
    
    @Published private var eventToShow: CalendarEvent?
    var eventToShowPublished: CPublisher<CalendarEvent?> {
        $eventToShow.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
    init(eventToShow event: CalendarEvent?) {
        self.eventToShow = event
    }
}

// MARK: - Actions
extension AddEventViewModel {
    private func setEventType(_ eventType: CalendarEvent.EventType) {
        self.selectedEventType = eventType
    }
    
    func setDate(_ date: Date) {
        self.date = date
    }
    
    func clientButtonDidTap(delegate: ChooseClientDelegate?) {
        self.pushVC.send(ChooseClientFactory.create(delegate: delegate))
    }
    
    func setSelectedClient(_ client: ClientInfo) {
        self.selectedClient = client
    }
    
    func caseButtonDidTap(delegate: ChooseCaseDelegate?) {
        guard let selectedClient else { return }
        
        self.pushVC.send(ChooseCaseFactory.create(client: selectedClient, delegate: delegate))
    }
    
    func setSelectedCase(_ case: ClientCase) {
        self.selectedCase = `case`
    }
    
    func addButtonDidTap(title: String?, description: String?, location: String?) {
        guard let currentUserId else { return }
        
        guard let title,
              !title.isEmpty
        else {
            self.presentAlert.send(UIAlertController(errorText: "Введите название события"))
            return
        }
        
        if self.selectedEventType != .deadlineSubmissionDocuments,
           location?.isEmpty ?? true {
            self.presentAlert.send(UIAlertController(errorText: "Введите место события"))
            return
        }
        
        guard let selectedCase else {
            self.presentAlert.send(UIAlertController(errorText: "Выберите событие"))
            return
        }
        
        guard let selectedClient else {
            self.presentAlert.send(UIAlertController(errorText: "Выберите клиента"))
            return
        }
        
        let event = CalendarEvent(
            eventType: self.selectedEventType,
            name: title,
            description: description,
            date: self.date,
            location: location,
            clientId: selectedClient.id,
            caseId: selectedCase.id,
            laywerId: currentUserId
        )
        
        DatabaseService.shared.saveObject(event)
        PushNotificationService.addCalendarEvenetReminder(event)
        NotificationCenter.default.post(name: .fetchEvents, object: nil)
        self.popVC.send(())
    }
}
