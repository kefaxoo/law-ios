//
//  AnalyticType.swift
//  law
//
//  Created by Bahdan Piatrouski on 22.02.25.
//

import Foundation

enum AnalyticType: CaseIterable {
    case cases
    case finance
    case laywersWorkload
}

extension AnalyticType: ActionsProtocol {
    var title: String {
        switch self {
            case .cases:
                "Статистика дел"
            case .finance:
                "Финансовые показатели"
            case .laywersWorkload:
                "Загруженность адвокатов"
        }
    }
    
    var vc: BaseViewController {
        switch self {
            case .cases:
                CasesAnalyticsFactory.create()
            case .finance:
                FinanceAnalyticsFactory.create()
            case .laywersWorkload:
                LaywerAnalyticsFactory.create()
        }
    }
}
