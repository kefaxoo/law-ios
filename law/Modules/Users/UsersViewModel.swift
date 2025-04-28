//
//  UsersViewModel.swift
//  law
//
//  Created by Bahdan Piatrouski on 28.04.25.
//

import UIKit

final class UsersViewModel: UsersViewModelProtocol {
    @Published var users = [User]()
    var usersPublished: CPublisher<[User]> {
        $users.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
    var present = CPassthroughSubject<UIViewController>()
    
    @UserDefaultsWrapper(key: .currentUserId, value: nil)
    private var currentUserId: String?
    
    init() {
        DatabaseService.shared.fetchObjects(type: User.self) { [weak self] objects, error in
            self?.users = objects ?? []
        }
    }
}

// MARK: - Actions
extension UsersViewModel {
    func userDidSelect(at indexPath: IndexPath) {
        let user = self.users[indexPath.row]
        guard self.currentUserId != (user.id as String) else { return }
        
        let alert = UIAlertController(title: "\(user.login): \(user.role?.title ?? "")", message: nil, preferredStyle: .actionSheet)
        User.Role.allCases.forEach { [weak self] role in
            alert.addAction(UIAlertAction(title: role.title, style: .default, handler: { _ in
                user.role = role
                DatabaseService.shared.saveChanges()
                FirebaseManager.shared.changeUserRole(user)
                self?.users[indexPath.row] = user
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        self.present.send(alert)
    }
}
