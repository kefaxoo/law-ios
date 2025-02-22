//
//  AnalyticsFactory.swift
//  law
//
//  Created by Bahdan Piatrouski on 22.02.25.
//

import UIKit

final class AnalyticsFactory {
	static func create() -> AnalyticsViewController {
		AnalyticsViewController(viewModel: AnalyticsViewModel())
	}
}
