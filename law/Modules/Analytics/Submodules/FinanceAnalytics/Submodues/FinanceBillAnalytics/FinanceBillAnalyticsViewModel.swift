//
//  FinanceBillAnalyticsViewModel.swift
//  law
//
//  Created by Bahdan Piatrouski on 23.02.25.
//

import Foundation
import DGCharts

final class FinanceBillAnalyticsViewModel: FinanceBillAnalyticsViewModelProtocol {
    private let operations: [FinanceOperation]
    
    @Published private var data: BarChartData?
    var dataPublished: CPublisher<BarChartData?> {
        $data.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
    @Published private var xAxis: IndexAxisValueFormatter?
    var xAxisPublished: CPublisher<IndexAxisValueFormatter?> {
        $xAxis.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
    init(operations: [FinanceOperation]) {
        self.operations = operations
    }
}

// MARK: - Lifecycle
extension FinanceBillAnalyticsViewModel {
    func viewDidLoad() {
        let paidOperations = self.operations.filter({ $0.status == .done })
        let paidOpertationsPercent = Double(paidOperations.count) / Double(self.operations.count) * 100
        let notPaidOperationsPercent = 100 - paidOpertationsPercent
        
        let dataSet = BarChartDataSet(entries: [
            BarChartDataEntry(x: 0, y: Double(paidOpertationsPercent)),
            BarChartDataEntry(x: 1, y: Double(notPaidOperationsPercent))
        ], label: "Процентное соотношение оплаченных/неоплаченных счетов")
        
        dataSet.colors = ChartColorTemplates.material()
        dataSet.valueTextColor = .label
        dataSet.valueFont = .systemFont(ofSize: 17)
        
        self.data = BarChartData(dataSet: dataSet)
        
        self.xAxis = IndexAxisValueFormatter(values: ["Оплаченные счета", "Неоплаченные счета"])
    }
}
