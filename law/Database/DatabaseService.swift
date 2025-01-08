//
//  DatabaseService.swift
//  law
//
//  Created by Bahdan Piatrouski on 16.12.24.
//

import Foundation
import SwiftData

final class DatabaseService {
    static let shared = DatabaseService()
    
    private var container: ModelContainer?
    private var context: ModelContext?
    
    fileprivate init() {
        do {
            self.container = try ModelContainer(for: ClientInfo.self, ClientCase.self, ClientInteractionHistory.self, CalendarEvent.self, User.self)
            guard let container else { return }
            
            self.context = ModelContext(container)
        } catch {
            fatalError("Error initializing database container: \(error)")
        }
    }
    
    func saveObject<T>(_ object: T) where T: PersistentModel {
        self.context?.insert(object)
        self.saveChanges()
    }
    
    func saveChanges() {
        do {
            try self.context?.save()
        } catch {
            debugPrint(error)
        }
    }
    
    func fetchObjects<T>(type: T.Type, predicate: Predicate<T>? = nil, completionHandler: @escaping((_ objects: [T]?, _ error: Error?) -> Void)) where T: PersistentModel {
        let descriptor = FetchDescriptor<T>(predicate: predicate)
        guard let context else { return }
        
        do {
            let data = try context.fetch(descriptor)
            completionHandler(data, nil)
        } catch {
            completionHandler(nil, error)
        }
    }
    
    func deleteObject<T>(_ object: T) where T: PersistentModel {
        self.context?.delete(object)
    }
}
