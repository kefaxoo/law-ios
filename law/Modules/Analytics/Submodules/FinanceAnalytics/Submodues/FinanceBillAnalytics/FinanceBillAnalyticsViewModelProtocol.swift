//
//  FinanceBillAnalyticsViewModelProtocol.swift
//  law
//
//  Created by Bahdan Piatrouski on 23.02.25.
//

import Foundation
import DGCharts

protocol FinanceBillAnalyticsViewModelProtocol {
    var dataPublished: CPublisher<BarChartData?> { get }
    var xAxisPublished: CPublisher<IndexAxisValueFormatter?> { get }
    
    func viewDidLoad()
}
