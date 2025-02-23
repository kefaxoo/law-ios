//
//  CalendarViewModel.swift
//  law
//
//  Created by Bahdan Piatrouski on 06.01.25.
//

import Foundation

final class CalendarViewModel: CalendarViewModelProtocol {
    @Published var events = [CalendarEvent]()
    var eventsPublished: CPublisher<[CalendarEvent]> {
        $events.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
    @Published var eventsToShow = [CalendarEvent]()
    var eventsToShowPublished: CPublisher<[CalendarEvent]> {
        $eventsToShow.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
    var pushVC = CPassthroughSubject<BaseViewController>()
    var present = CPassthroughSubject<BaseViewController>()
    
    @UserDefaultsWrapper(key: .currentUserId, value: nil)
    private var currentUserId: String?
    
    init() {
        self.fetchEvents()
    }
    
    func fetchEvents() {
        guard let currentUserId else { return }
        
        DatabaseService.shared.fetchObjects(type: CalendarEvent.self, predicate: #Predicate { $0.laywerId == currentUserId }) { [weak self] objects, error in
            self?.events = objects ?? []
        }
    }
}

// MARK: - Actions
extension CalendarViewModel {
    func rightBarButtonDidTap() {
        self.pushVC.send(AddEventFactory.create())
    }
    
    func dateDidSelect(dateComponents: DateComponents?) {
        self.eventsToShow.removeAll()
        
        guard let dateComponents else { return }
        
        self.eventsToShow = self.events.filter({ $0.date == dateComponents })
    }
    
    func eventDidTap(at indexPath: IndexPath) {
        let event = self.events[indexPath.row]
        self.present.send(AddEventFactory.create(eventToShow: event))
    }
}
