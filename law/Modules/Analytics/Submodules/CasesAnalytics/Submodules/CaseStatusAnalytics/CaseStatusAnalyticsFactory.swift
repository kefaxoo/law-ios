//
//  CaseStatusAnalyticsFactory.swift
//  law
//
//  Created by Bahdan Piatrouski on 23.02.25.
//

import UIKit

final class CaseStatusAnalyticsFactory {
    static func create(cases: [ClientCase]) -> CaseStatusAnalyticsViewController {
        CaseStatusAnalyticsViewController(viewModel: CaseStatusAnalyticsViewModel(cases: cases))
	}
}
