//
//  AuthViewModel.swift
//  law
//
//  Created by Bahdan Piatrouski on 09.01.25.
//

import UIKit

final class AuthViewModel: AuthViewModelProtocol {
    var mode: AuthMode
    
    var pushVC = CPassthroughSubject<BaseViewController>()
    var popVC = CPassthroughSubject<Void>()
    var presentAlert = CPassthroughSubject<UIAlertController>()
    
    @UserDefaultsWrapper(key: .currentUserId, value: nil)
    private var currentUserId: String?
    
    init(mode: AuthMode) {
        self.mode = mode
    }
}

// MARK: - Actions
extension AuthViewModel {
    func changeModeButtonDidTap() {
        switch self.mode {
            case .signIn:
                self.pushVC.send(AuthFactory.create(mode: .signUp))
            default:
                self.popVC.send(())
        }
    }
    
    func bottomButtonDidTap(login: String?, password: String?) {
        guard let login,
              !login.isEmpty
        else {
            self.presentAlert.send(UIAlertController(errorText: "Введите логин"))
            return
        }
        
        guard let password,
              password.count >= 6
        else {
            self.presentAlert.send(UIAlertController(errorText: "Введите пароль\nМинимум 6 символов"))
            return
        }
        
        switch self.mode {
            case .signIn:
                DatabaseService.shared.fetchObjects(type: User.self, predicate: #Predicate { $0.login == login && $0.password == password }) { [weak self] objects, error in
                    guard let objects,
                          objects.count > 0
                    else {
                        self?.presentAlert.send(UIAlertController(errorText: "Аккаунт не был найден или данные были введены неверно"))
                        return
                    }
                    
                    if let id = objects.first?.id as? String {
                        self?.currentUserId = id
                    } else {
                        UserDefaults.standard.removeObject(for: .currentUserId)
                    }
                    
                    let window = UIApplication.shared.connectedScenes.compactMap({ $0 as? UIWindowScene }).first?.keyWindow
                    window?.rootViewController = MenuFactory.create()
                    window?.makeKeyAndVisible()
                }
            case .signUp:
                let user = User(login: login, password: password)
                DatabaseService.shared.saveObject(user)
                self.presentAlert.send(UIAlertController(errorText: "Аккаунт был создан"))
                self.popVC.send(())
        }
    }
}
