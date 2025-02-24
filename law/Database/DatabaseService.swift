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
    
    @UserDefaultsWrapper(key: .isMockDataLoaded, value: false)
    private var isMockDataLoaded: Bool
    
    func initialize() {
        do {
            self.container = try ModelContainer(for: ClientInfo.self, ClientCase.self, ClientInteractionHistory.self, CalendarEvent.self, User.self, ClientDocument.self, FinanceOperation.self)
            guard let container else { return }
            
            self.context = ModelContext(container)
        } catch {
            fatalError("Error initializing database container: \(error)")
        }
        
        if !self.isMockDataLoaded {
            self.loadMockData()
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

// MARK: - Mock Data
extension DatabaseService {
    private func deleteAllData() {
        let types: [any PersistentModel.Type] = [ClientInfo.self, ClientCase.self, CalendarEvent.self, FinanceOperation.self]
        do {
            for type in types {
                try self.context?.delete(model: type)
            }
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    private func loadMockData() {
        self.deleteAllData()
        
        // MARK: Load Client Info
        guard let clientInfoPath = Bundle.main.path(forResource: "ClientInfo", ofType: "json") else { return }
    
        let clientInfo: [ClientInfo]
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: clientInfoPath))
            clientInfo = try JSONDecoder().decode([ClientInfo].self, from: data)
            clientInfo.forEach({ self.saveObject($0) })
        } catch {
            debugPrint(error.localizedDescription)
            return
        }
        
        // MARK: Load Client Cases
        guard let clientCasePath = Bundle.main.path(forResource: "ClientCase", ofType: "json") else { return }
        
        let clientCase: [ClientCase]
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: clientCasePath))
            clientCase = try JSONDecoder().decode([ClientCase].self, from: data)
            clientCase.forEach {
                guard let index = Int($0.clientId) else { return }
                
                $0.clientId = clientInfo[index].id
                self.saveObject($0)
            }
        } catch {
            debugPrint(error.localizedDescription)
            return
        }
        
        // MARK: Load Users
        guard let userPath = Bundle.main.path(forResource: "User", ofType: "json") else { return }
        
        let users: [User]
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: userPath))
            users = try JSONDecoder().decode([User].self, from: data)
            users.forEach({ self.saveObject($0) })
        } catch {
            debugPrint(error.localizedDescription)
            return
        }
        
        // MARK: Load Calendar Events
        guard let calendarEventPath = Bundle.main.path(forResource: "CalendarEvent", ofType: "json") else { return }
        
        let calendarEvent: [CalendarEvent]
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: calendarEventPath))
            calendarEvent = try JSONDecoder().decode([CalendarEvent].self, from: data)
            calendarEvent.forEach {
                guard let clientIndex = Int($0.clientId),
                      let caseIndex = Int($0.caseId),
                      let userIndex = Int($0.laywerId),
                      let clientId = clientInfo[safeAt: clientIndex]?.id,
                      let caseId = clientCase[safeAt: caseIndex]?.id,
                      let laywerId = users[safeAt: userIndex]?.id
                else { return }
                
                $0.clientId = clientId
                $0.caseId = caseId
                $0.laywerId = laywerId
                self.saveObject($0)
            }
        } catch {
            debugPrint(error.localizedDescription)
        }
        
        // MARK: Load Finance Operations
        guard let financeOperationPath = Bundle.main.path(forResource: "FinanceOperation", ofType: "json") else { return }
        
        let financeOperations: [FinanceOperation]
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: financeOperationPath))
            financeOperations = try JSONDecoder().decode([FinanceOperation].self, from: data)
            financeOperations.forEach {
                guard let clientIndex = Int($0.clientId),
                      let caseIndex = Int($0.caseId),
                      let clientId = clientInfo[safeAt: clientIndex]?.id,
                      let caseId = clientCase[safeAt: caseIndex]?.id
                else { return }
                
                $0.clientId = clientId
                $0.caseId = caseId
                self.saveObject($0)
            }
        } catch {
            debugPrint(error.localizedDescription)
        }
        
        self.isMockDataLoaded = true
    }
}
