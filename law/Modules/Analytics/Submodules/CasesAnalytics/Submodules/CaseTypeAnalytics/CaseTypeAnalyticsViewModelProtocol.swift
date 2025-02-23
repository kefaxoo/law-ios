//
//  CaseTypeAnalyticsViewModelProtocol.swift
//  law
//
//  Created by Bahdan Piatrouski on 23.02.25.
//

import Foundation
import DGCharts

protocol CaseTypeAnalyticsViewModelProtocol {
    var dataPublished: CPublisher<PieChartData?> { get }
    
    func viewDidLoad()
}
