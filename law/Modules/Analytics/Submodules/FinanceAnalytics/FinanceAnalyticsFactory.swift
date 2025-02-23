//
//  FinanceAnalyticsFactory.swift
//  law
//
//  Created by Bahdan Piatrouski on 22.02.25.
//

import UIKit

final class FinanceAnalyticsFactory {
	static func create() -> FinanceAnalyticsViewController {
		FinanceAnalyticsViewController(viewModel: FinanceAnalyticsViewModel())
	}
}
