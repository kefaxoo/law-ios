//
//  FinanceViewController.swift
//  law
//
//  Created by Bahdan Piatrouski on 17.02.25.
//

import UIKit

final class FinanceViewController: NewActionsViewController<FinanceViewModel> {
    override func setupInterface() {
        super.setupInterface()
        
        self.viewTitle = "Финансовый учет"
    }
}
