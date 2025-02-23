//
//  FinanceBillAnalyticsViewController.swift
//  law
//
//  Created by Bahdan Piatrouski on 23.02.25.
//

import UIKit
import DGCharts

final class FinanceBillAnalyticsViewController: BaseViewController {
    private lazy var barChartView = BarChartView().setup {
        $0.chartDescription.enabled = false
        $0.legend.enabled = true
        $0.rightAxis.enabled = false
        $0.xAxis.labelPosition = .bottom
        $0.xAxis.granularity = 1
        $0.xAxis.drawGridLinesEnabled = false
        $0.leftAxis.drawGridLinesEnabled = false
    }
    
    private let viewModel: FinanceBillAnalyticsViewModelProtocol

	init(viewModel: FinanceBillAnalyticsViewModelProtocol) {
		self.viewModel = viewModel
		super.init()
	}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.viewDidLoad()
    }
    
    override func setupLayout() {
        self.view.addSubview(self.barChartView)
    }
    
    override func setupConstraints() {
        self.barChartView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide).inset(16)
            make.size.equalTo(UIScreen.main.bounds.width - 32)
        }
    }
    
    override func setupBindings() {
        self.viewModel.dataPublished.sink { [weak self] data in
            self?.barChartView.data = data
        }.store(in: &cancellables)
        
        self.viewModel.xAxisPublished.sink { [weak self] formatter in
            self?.barChartView.xAxis.valueFormatter = formatter
        }.store(in: &cancellables)
    }
    
    override func setupNavigationController() {
        self.navigationItem.title = "Оплаченные/просроченные счета"
    }
}
