//
//  LaywerAnalyticsFactory.swift
//  law
//
//  Created by Bahdan Piatrouski on 23.02.25.
//

import Foundation

final class LaywerAnalyticsFactory {
    static func create() -> LaywerAnalyticsViewController {
        LaywerAnalyticsViewController(viewModel: LaywerAnalyticsViewModel())
    }
}
