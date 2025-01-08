//
//  AuthMode.swift
//  law
//
//  Created by Bahdan Piatrouski on 9.01.25.
//

import Foundation

enum AuthMode {
    case signIn
    case signUp
    
    var title: String {
        switch self {
            case .signIn:
                "Вход"
            case .signUp:
                "Регистрация"
        }
    }
    
    var mainButtonText: String {
        switch self {
            case .signIn:
                "Войти"
            case .signUp:
                "Создать аккаунт"
        }
    }
    
    var changeModeButtonText: String {
        switch self {
            case .signIn:
                AuthMode.signUp.title
            case .signUp:
                AuthMode.signIn.title
        }
    }
}
