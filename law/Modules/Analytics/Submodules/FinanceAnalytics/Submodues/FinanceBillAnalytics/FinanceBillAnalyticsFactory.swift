//
//  FinanceBillAnalyticsFactory.swift
//  law
//
//  Created by Bahdan Piatrouski on 23.02.25.
//

import UIKit

final class FinanceBillAnalyticsFactory {
    static func create(operations: [FinanceOperation]) -> FinanceBillAnalyticsViewController {
        FinanceBillAnalyticsViewController(viewModel: FinanceBillAnalyticsViewModel(operations: operations))
	}
}
