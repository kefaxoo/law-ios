//
//  AuthFactory.swift
//  law
//
//  Created by Bahdan Piatrouski on 09.01.25.
//

import UIKit

final class AuthFactory {
    static func create(mode: AuthMode) -> AuthViewController {
        AuthViewController(viewModel: AuthViewModel(mode: mode))
	}
}
