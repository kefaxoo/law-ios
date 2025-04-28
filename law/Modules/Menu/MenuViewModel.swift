//
//  MenuViewModel.swift
//  law
//
//  Created by Bahdan Piatrouski on 16.12.24.
//

import UIKit

final class MenuViewModel: ActionsViewModelProtocol {
    @UserDefaultsWrapper(key: .currentUserRole, value: nil)
    private var currentUserRole: String?
    
    @UserDefaultsWrapper(key: .currentUserId, value: nil)
    private var currentUserId: String?
    
    @Published var actions = [any ActionsProtocol]()
    var actionsPublisher: CPublisher<[any ActionsProtocol]> {
        $actions.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
    var pushVC = CPassthroughSubject<BaseViewController>()
    var presentAlert = CPassthroughSubject<UIAlertController>()
    
    init() {
        self.actions = switch self.currentUserRole {
            case User.Role.lawyer.rawValue:
                MenuActions.lawyerCases
            case User.Role.client.rawValue:
                MenuActions.clientCases
            default:
                []
        }
    }
}

// MARK: - Actions
extension MenuViewModel {
    func actionDidTap(at indexPath: IndexPath) {
        self.pushVC.send(self.actions[indexPath.row].vc)
    }
    
    func rightBarButtonDidTap() {
        let alert = UIAlertController(title: "Вы действительно хотите выйти из аккаунта?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Нет", style: .destructive))
        alert.addAction(UIAlertAction(title: "Выйти", style: .default, handler: { _ in
            FirebaseManager.shared.signOut(userId: self.currentUserId)
            UserDefaults.standard.removeObject(for: .currentUserId)
            UserDefaults.standard.removeObject(for: .currentUserRole)
            
            let window = UIApplication.shared.connectedScenes.compactMap({ $0 as? UIWindowScene }).first?.keyWindow
            window?.rootViewController = UINavigationController(rootViewController: AuthFactory.create(mode: .signIn))
            window?.makeKeyAndVisible()
        }))
        
        self.presentAlert.send(alert)
    }
}

// MARK: - Lifecycle
extension MenuViewModel {
    func viewDidLoad() {
        PushNotificationService.requestAccess()
    }
}
