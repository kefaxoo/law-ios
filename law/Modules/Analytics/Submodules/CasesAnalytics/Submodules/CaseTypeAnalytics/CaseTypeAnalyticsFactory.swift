//
//  CaseTypeAnalyticsFactory.swift
//  law
//
//  Created by Bahdan Piatrouski on 23.02.25.
//

import UIKit

final class CaseTypeAnalyticsFactory {
    static func create(cases: [ClientCase]) -> CaseTypeAnalyticsViewController {
        CaseTypeAnalyticsViewController(viewModel: CaseTypeAnalyticsViewModel(cases: cases))
	}
}
