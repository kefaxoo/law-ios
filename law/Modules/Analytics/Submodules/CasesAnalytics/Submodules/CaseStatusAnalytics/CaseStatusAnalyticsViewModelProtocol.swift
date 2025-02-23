//
//  CaseStatusAnalyticsViewModelProtocol.swift
//  law
//
//  Created by Bahdan Piatrouski on 23.02.25.
//

import Foundation
import DGCharts

protocol CaseStatusAnalyticsViewModelProtocol {
    var dataPublished: CPublisher<BarChartData?> { get }
    var xAxisPublished: CPublisher<IndexAxisValueFormatter?> { get }
    
    func viewDidLoad()
}
