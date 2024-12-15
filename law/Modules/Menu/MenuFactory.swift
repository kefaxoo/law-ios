//
//  MenuFactory.swift
//  law
//
//  Created by Bahdan Piatrouski on 16.12.24.
//

import UIKit

final class MenuFactory {
    static func create() -> UINavigationController {
        UINavigationController(rootViewController: MenuViewController(viewModel: MenuViewModel()))
	}
}
