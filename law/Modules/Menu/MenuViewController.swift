//
//  MenuViewController.swift
//  law
//
//  Created by Bahdan Piatrouski on 16.12.24.
//

import UIKit

final class MenuViewController: ActionsViewController<MenuViewModel> {
    override func setupNavigationController() {
        self.navigationItem.title = "Menu"
    }
}
