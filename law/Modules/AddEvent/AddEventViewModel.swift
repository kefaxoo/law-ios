//
//  AddEventViewModel.swift
//  law
//
//  Created by Bahdan Piatrouski on 06.01.25.
//

import UIKit
import MessageUI

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
    
    var present = CPassthroughSubject<UIViewController>()
    var popVC = CPassthroughSubject<Void>()
    var presentMailVC = CPassthroughSubject<MFMailComposeViewController>()
    
    @Published private var eventToShow: CalendarEvent?
    var eventToShowPublished: CPublisher<CalendarEvent?> {
        $eventToShow.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
    @Published private var isReminder = false
    var isReminderPublished: CPublisher<Bool> {
        $isReminder.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
    @Published private var selectedReminderPeriod: ReminderPeriod?
    var selectedReminderPeriodPublished: CPublisher<ReminderPeriod?> {
        $selectedReminderPeriod.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
    var remindersActions: [UIAction] {
        ReminderPeriod.allCases.compactMap { [weak self] period in
            UIAction(title: period.title) { _ in
                self?.selectedReminderPeriod = period
            }
        }
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
        if let eventToShow {
            let clientId = eventToShow.clientId
            DatabaseService.shared.fetchObjects(type: ClientInfo.self, predicate: #Predicate { $0.id == clientId }) { [weak self] objects, error in
                guard let client = objects?.first else {
                    self?.present.send(UIAlertController.okAlert(title: "Ошибка", message: "У клиента не введен Email адрес"))
                    return
                }
                
                if MFMailComposeViewController.canSendMail() {
                    let vc = MFMailComposeViewController()
                    vc.setToRecipients([client.email])
                    vc.setSubject("Напоминание о событии")
                    vc.setMessageBody(
                      """
                      Уважаемый(-ая) \(client.firstName) \(client.fatherName ?? ""), напоминаю Вам о событии.
                      
                      Данные о событии:
                      Тип события: \(eventToShow.eventType.title)
                      Название события: \(eventToShow.name)
                      Описание события: \(eventToShow.eventDescription ?? "")
                      Дата и время события: \(Date(timeIntervalSince1970: eventToShow.date).toDateFormat("dd.MM.yyyy HH:mm")) GMT+3
                      Место события: \(eventToShow.location ?? "")
                      """,
                      isHTML: false
                    )
                    
                    self?.presentMailVC.send(vc)
                } else {
                    self?.present.send(UIAlertController(errorText: "Невозможно отобразить окно отправки Email письма"))
                }
            }
            
            return
        }
        
        guard let currentUserId else { return }
        
        guard let title,
              !title.isEmpty
        else {
            self.present.send(UIAlertController(errorText: "Введите название события"))
            return
        }
        
        if self.selectedEventType != .deadlineSubmissionDocuments,
           location?.isEmpty ?? true {
            self.present.send(UIAlertController(errorText: "Введите место события"))
            return
        }
        
        guard let selectedCase else {
            self.present.send(UIAlertController(errorText: "Выберите событие"))
            return
        }
        
        guard let selectedClient else {
            self.present.send(UIAlertController(errorText: "Выберите клиента"))
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
        if self.isReminder,
           let selectedReminderPeriod {
            PushNotificationService.addCalendarEvenetReminder(event, reminderPeriod: selectedReminderPeriod)
        }
        
        NotificationCenter.default.post(name: .fetchEvents, object: nil)
        self.popVC.send(())
    }
    
    func setIsReminder(_ value: Bool) {
        self.isReminder = value
    }
}
