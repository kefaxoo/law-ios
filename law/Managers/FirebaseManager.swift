//
//  FirebaseManager.swift
//  law
//
//  Created by Bahdan Piatrouski on 19.04.25.
//

import Foundation
import FirebaseFirestore

final class FirebaseManager {
    static let shared = FirebaseManager()
    
    private let firestore = Firestore.firestore()
    private lazy var auditLogs = self.firestore.collection("audit_logs")
    
    @UserDefaultsWrapper(key: .currentUserId, value: nil)
    private var currentUserId: String?
    
    func signIn(user: User, success: Bool) {
        self.auditLogs.addDocument(data: [
            "timestamp": Timestamp(date: Date()),
            "action_type": "sign_in",
            "login": user.login,
            "role": user.role?.rawValue ?? "",
            "details": [
                "success": success
            ]
        ])
    }
    
    func signUp(user: User) {
        self.auditLogs.addDocument(data: [
            "timestamp": Timestamp(date: Date()),
            "action_type": "sign_up",
            "login": user.login,
            "role": user.role?.rawValue ?? "",
            "details": [:]
        ])
    }
    
    func signOut(userId: String?) {
        guard let userId else { return }
        
        Task {
            guard let user = await DatabaseService.shared.fetchObjects(type: User.self, predicate: #Predicate { $0.id == userId }).first else { return }
            
            do {
                try await self.auditLogs.addDocument(data: [
                    "timestamp": Timestamp(date: Date()),
                    "action_type": "sign_out",
                    "login": user.login,
                    "role": user.role?.rawValue ?? "",
                    "details": [:]
                ])
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    func createClient(_ client: ClientInfo) {
        self.sendLog(action: "create_client", details: [
            "client_id": client.id,
            "client_full_name": client.fullName,
            "client_type": "\(client.clientType)"
        ])
    }
    
    func createEditCase(_ clientCase: ClientCase, isEdit: Bool) {
        self.sendLog(action: isEdit ? "edit_client_case" : "create_client_case", details: [
            "case_id": clientCase.id,
            "client_id": clientCase.clientId,
            "case_type": "\(clientCase.type)",
            "case_status": "\(clientCase.status)"
        ])
    }
    
    func event(_ event: CalendarEvent, isNotification: Bool) {
        self.sendLog(action: isNotification ? "send_event_notification" : "create_event", details: [
            "event_id": event.id,
            "event_name": event.name,
            "client_id": event.clientId,
            "case_id": event.caseId
        ])
    }
    
    func createEditDocument(_ document: ClientDocument, isEdit: Bool) {
        self.sendLog(action: isEdit ? "edit_document" : "create_document", details: [
            "document_id": document.id,
            "document_title": document.title,
            "document_type": "\(document.type)",
            "document_upload_date": Timestamp(date: Date(timeIntervalSince1970: document.uploadDate))
        ])
    }
    
    func createEditFinanceOperation(_ financeOperation: FinanceOperation, isEdit: Bool) {
        self.sendLog(action: isEdit ? "edit_client_finance_operation" : "create_client_finance_operation", details: [
            "finance_operation_id": financeOperation.id,
            "client_id": financeOperation.clientId,
            "case_id": financeOperation.caseId,
            "finance_operation_status": "\(financeOperation.status)"
        ])
    }
    
    func changeUserRole(_ user: User) {
        self.sendLog(action: "change_user_role", details: [
            "user_id": user.id,
            "user_login": user.login,
            "user_old_role": user.role?.opposite.rawValue ?? "",
            "user_new_role": user.role?.rawValue ?? ""
        ])
    }
}

// MARK: - Current User
private extension FirebaseManager {
    func currentUser() async -> User? {
        guard let currentUserId else { return nil }
        return await DatabaseService.shared.fetchObjects(type: User.self, predicate: #Predicate { $0.id == currentUserId }).first
    }
    
    func sendLog(completionHandler: @escaping(_ user: User) -> Void) {
        Task {
            guard let currentUser = await self.currentUser() else { return }
            
            completionHandler(currentUser)
        }
    }
    
    func sendLog(action: String, details: [String: Any]) {
        self.sendLog { [weak self] user in
            self?.auditLogs.addDocument(data: [
                "timestamp": Timestamp(date: Date()),
                "action_type": action,
                "login": user.login,
                "role": user.role?.rawValue ?? "",
                "details": details
            ])
        }
    }
}
