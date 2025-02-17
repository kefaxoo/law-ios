//
//  FinanceViewController.swift
//  law
//
//  Created by Bahdan Piatrouski on 17.02.25.
//

import UIKit

final class FinanceViewController: ActionsViewController<FinanceViewModel> {
    override func setupNavigationController() {
        self.navigationItem.title = "Финансовый учет"
    }
}
