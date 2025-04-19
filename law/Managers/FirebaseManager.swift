//
//  FirebaseManager.swift
//  law
//
//  Created by Bahdan Piatrouski on 19.04.25.
//

import Foundation
import FirebaseAnalytics

final class FirebaseManager {
    static let shared = FirebaseManager()
    
    func signIn(with user: User, isSuccess: Bool) {
        Analytics.logEvent("signIn", parameters: [
            "userId": user.id,
            "userLogin": user.login,
            "isSuccess": isSuccess
        ])
    }
    
    func signUp(with user: User) {
        Analytics.logEvent("signUp", parameters: [
            "userId": user.id,
            "userLogin": user.login
        ])
    }
}
