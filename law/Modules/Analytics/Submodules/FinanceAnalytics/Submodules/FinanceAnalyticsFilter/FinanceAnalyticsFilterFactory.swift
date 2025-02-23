//
//  FinanceAnalyticsFilterFactory.swift
//  law
//
//  Created by Bahdan Piatrouski on 23.02.25.
//

import UIKit

final class FinanceAnalyticsFilterFactory {
	static func create() -> FinanceAnalyticsFilterViewController {
		FinanceAnalyticsFilterViewController(viewModel: FinanceAnalyticsFilterViewModel())
	}
}
