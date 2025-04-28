//
//  UsersViewModelProtocol.swift
//  law
//
//  Created by Bahdan Piatrouski on 28.04.25.
//

import UIKit

protocol UsersViewModelProtocol {
    var users: [User] { get }
    var usersPublished: CPublisher<[User]> { get }
    
    var present: CPassthroughSubject<UIViewController> { get }
    
    // MARK: - Actions
    func userDidSelect(at indexPath: IndexPath)
}
