//
//  CaseTypeAnalyticsViewController.swift
//  law
//
//  Created by Bahdan Piatrouski on 23.02.25.
//

import UIKit
import DGCharts

final class CaseTypeAnalyticsViewController: BaseViewController {
    private lazy var pieChartView = PieChartView().setup {
        $0.holeRadiusPercent = 0
        $0.transparentCircleRadiusPercent = 0.45
        $0.chartDescription.enabled = true
        $0.legend.orientation = .vertical
        $0.legend.horizontalAlignment = .right
        $0.legend.verticalAlignment = .top
        $0.legend.xEntrySpace = 10
    }
    
    private let viewModel: CaseTypeAnalyticsViewModelProtocol

	init(viewModel: CaseTypeAnalyticsViewModelProtocol) {
		self.viewModel = viewModel
		super.init()
	}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.viewDidLoad()
    }
    
    override func setupLayout() {
        self.view.addSubview(self.pieChartView)
    }
    
    override func setupConstraints() {
        self.pieChartView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide).inset(16)
            make.size.equalTo(UIScreen.main.bounds.width - 32)
        }
    }
    
    override func setupNavigationController() {
        self.navigationItem.title = "Доли типов дел"
    }
    
    override func setupBindings() {
        self.viewModel.dataPublished.sink { [weak self] data in
            self?.pieChartView.data = data
        }.store(in: &cancellables)
    }
}
