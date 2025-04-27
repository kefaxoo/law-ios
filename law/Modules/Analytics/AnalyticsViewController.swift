//
//  AnalyticsViewController.swift
//  law
//
//  Created by Bahdan Piatrouski on 22.02.25.
//

import UIKit

final class AnalyticsViewController: NewActionsViewController<AnalyticsViewModel> {
    override func setupInterface() {
        super.setupInterface()
        
        self.viewTitle = "Отчетность и аналитика"
    }
}
