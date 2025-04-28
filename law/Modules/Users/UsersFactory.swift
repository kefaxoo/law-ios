//
//  UsersFactory.swift
//  law
//
//  Created by Bahdan Piatrouski on 28.04.25.
//

import Foundation

final class UsersFactory {
    static func create() -> UsersViewController {
        UsersViewController(viewModel: UsersViewModel())
    }
}
