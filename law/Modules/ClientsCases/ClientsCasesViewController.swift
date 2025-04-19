//
//  ClientsCasesViewController.swift
//  law
//
//  Created by Bahdan Piatrouski on 16.12.24.
//

import UIKit

final class ClientsCasesViewController: NewActionsViewController<ClientsCasesViewModel> {
    override func setupInterface() {
        super.setupInterface()
        
        self.viewTitle = "Управление клиентами и делами"
    }
}
