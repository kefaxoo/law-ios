//
//  CalendarViewModelProtocol.swift
//  law
//
//  Created by Bahdan Piatrouski on 06.01.25.
//

import Foundation

protocol CalendarViewModelProtocol {
    var events: [CalendarEvent] { get }
    var eventsPublished: CPublisher<[CalendarEvent]> { get }
    
    var eventsToShow: [CalendarEvent] { get }
    var eventsToShowPublished: CPublisher<[CalendarEvent]> { get }
    
    var pushVC: CPassthroughSubject<BaseViewController> { get }
    
    func rightBarButtonDidTap()
    func fetchEvents()
    func dateDidSelect(dateComponents: DateComponents?)
}
