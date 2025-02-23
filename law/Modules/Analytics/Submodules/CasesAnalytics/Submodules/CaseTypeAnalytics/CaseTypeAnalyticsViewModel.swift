//
//  CaseTypeAnalyticsViewModel.swift
//  law
//
//  Created by Bahdan Piatrouski on 23.02.25.
//

import Foundation
import DGCharts

final class CaseTypeAnalyticsViewModel: CaseTypeAnalyticsViewModelProtocol {
    private let cases: [ClientCase]
    
    @Published private var data: PieChartData?
    var dataPublished: CPublisher<PieChartData?> {
        $data.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
    init(cases: [ClientCase]) {
        self.cases = cases
    }
}

// MARK: - Lifecycle
extension CaseTypeAnalyticsViewModel {
    func viewDidLoad() {
        var caseTypes = [String: Int]()
        self.cases.forEach { clientCase in
            let title = clientCase.type.title
            if caseTypes[title] == nil {
                caseTypes[title] = 1
            } else {
                caseTypes[title]? += 1
            }
        }
        
        let dataSet = PieChartDataSet(entries: caseTypes.compactMap({ PieChartDataEntry(value: Double($0.value), label: $0.key) }), label: "Типы дел")
        dataSet.colors = ChartColorTemplates.material()
        
        dataSet.valueTextColor = .label
        dataSet.valueFont = .systemFont(ofSize: 17)
        
        self.data = PieChartData(dataSet: dataSet)
    }
}
