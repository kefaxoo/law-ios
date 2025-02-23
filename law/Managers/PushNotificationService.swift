//
//  PushNotificationService.swift
//  law
//
//  Created by Bahdan Piatrouski on 23.02.25.
//

import Foundation
import UserNotifications

fileprivate extension UNCalendarNotificationTrigger {
    convenience init?(event: CalendarEvent, period: ReminderPeriod) {
        let date = Date(timeIntervalSince1970: event.date)
        let triggerDate = date.addingTimeInterval(-period.timeInterval)
        
        guard triggerDate > Date() else { return nil }
        
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: triggerDate)
        self.init(dateMatching: dateComponents, repeats: false)
    }
}

final class PushNotificationService {
    @UserDefaultsWrapper(key: .hasNotificationAccess, value: false)
    private static var hasNotifictionAccess: Bool
    
    static func requestAccess(completion: ((_ hasNotifictionAccess: Bool) -> Void)? = nil) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { hasAccess, error in
            self.hasNotifictionAccess = hasAccess
            completion?(hasAccess)
        }
    }
    
    static func addCalendarEvenetReminder(_ event: CalendarEvent, reminderPeriod: ReminderPeriod) {
        let content = UNMutableNotificationContent()
        content.title = event.name
        let date = Date(timeIntervalSince1970: event.date).toDateFormat("dd.MM.yyyy HH:mm")
        let description: String
        if let eventDescription = event.eventDescription {
            description = "\(eventDescription)\n\n"
        } else {
            description = ""
        }
        
        content.body = """
        \(description)
        Тип события: \(event.eventType.title)
        Дата и время события: \(date)
        """
        
        content.sound = .default
        
        guard let trigger = UNCalendarNotificationTrigger(event: event, period: reminderPeriod) else { return }
        
        let request = UNNotificationRequest(identifier: "event-\(event.id)", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            guard let error else {
                debugPrint("Notification added")
                return
            }
            
            debugPrint(error.localizedDescription)
        }
    }
}
