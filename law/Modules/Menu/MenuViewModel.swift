//
//  MenuViewModel.swift
//  law
//
//  Created by Bahdan Piatrouski on 16.12.24.
//

import UIKit

final class MenuViewModel: ActionsViewModelProtocol {
    @Published var actions: [any ActionsProtocol] = MenuActions.allCases
    var actionsPublisher: CPublisher<[any ActionsProtocol]> {
        $actions.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
    var pushVC = CPassthroughSubject<BaseViewController>()
    var presentAlert = CPassthroughSubject<UIAlertController>()
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
            UserDefaults.standard.removeObject(for: .currentUserId)
            
            let window = UIApplication.shared.connectedScenes.compactMap({ $0 as? UIWindowScene }).first?.keyWindow
            window?.rootViewController = UINavigationController(rootViewController: AuthFactory.create(mode: .signIn))
            window?.makeKeyAndVisible()
        }))
        
        self.presentAlert.send(alert)
    }
}
