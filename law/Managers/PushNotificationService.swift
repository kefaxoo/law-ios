//
//  PushNotificationService.swift
//  law
//
//  Created by Bahdan Piatrouski on 23.02.25.
//

import Foundation
import UserNotifications

final class PushNotificationService {
    @UserDefaultsWrapper(key: .hasNotificationAccess, value: false)
    private static var hasNotifictionAccess: Bool
    
    static func requestAccess(completion: ((_ hasNotifictionAccess: Bool) -> Void)? = nil) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { hasAccess, error in
            self.hasNotifictionAccess = hasAccess
            completion?(hasAccess)
        }
    }
    
    static func addCalendarEvenetReminder(_ event: CalendarEvent) {
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
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
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
