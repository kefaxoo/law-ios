//
//  AnalyticsViewController.swift
//  law
//
//  Created by Bahdan Piatrouski on 22.02.25.
//

import UIKit

final class AnalyticsViewController: ActionsViewController<AnalyticsViewModel> {
    override func setupNavigationController() {
        self.navigationItem.title = "Отчетность и аналитика"
    }
}
