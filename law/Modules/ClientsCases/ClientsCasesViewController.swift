//
//  ClientsCasesViewController.swift
//  law
//
//  Created by Bahdan Piatrouski on 16.12.24.
//

import UIKit

final class ClientsCasesViewController: ActionsViewController<ClientsCasesViewModel> {
    override func setupNavigationController() {
        self.navigationItem.title = "Clients and cases"
    }
}
