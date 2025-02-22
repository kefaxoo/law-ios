//
//  CasesAnalyticsFactory.swift
//  law
//
//  Created by Bahdan Piatrouski on 22.02.25.
//

import UIKit

final class CasesAnalyticsFactory {
	static func create() -> CasesAnalyticsViewController {
		CasesAnalyticsViewController(viewModel: CasesAnalyticsViewModel())
	}
}
