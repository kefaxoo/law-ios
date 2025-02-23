//
//  CaseStatusAnalyticsViewModel.swift
//  law
//
//  Created by Bahdan Piatrouski on 23.02.25.
//

import Foundation
import DGCharts

final class CaseStatusAnalyticsViewModel: CaseStatusAnalyticsViewModelProtocol {
    private let cases: [ClientCase]
    
    @Published private var data: BarChartData?
    var dataPublished: CPublisher<BarChartData?> {
        $data.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
    @Published private var xAxis: IndexAxisValueFormatter?
    var xAxisPublished: CPublisher<IndexAxisValueFormatter?> {
        $xAxis.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
    init(cases: [ClientCase]) {
        self.cases = cases
    }
}

// MARK: - Lifecycle
extension CaseStatusAnalyticsViewModel {
    func viewDidLoad() {
        var caseStatus = [String: Int]()
        self.cases.forEach { clientCase in
            let title = clientCase.status.title
            if caseStatus[title] == nil {
                caseStatus[title] = 1
            } else {
                caseStatus[title]? += 1
            }
        }
        
        let dataSet = BarChartDataSet(entries: caseStatus.enumerated().compactMap({ BarChartDataEntry(x: Double($0.offset), y: Double($0.element.value)) }), label: "Статусы дел")
        dataSet.colors = ChartColorTemplates.material()
        
        dataSet.valueTextColor = .label
        dataSet.valueFont = .systemFont(ofSize: 17)
        
        self.data = BarChartData(dataSet: dataSet)
        self.xAxis = IndexAxisValueFormatter(values: caseStatus.compactMap({ $0.key }))
    }
}
