//
//  FinanceAnalyticsFilterViewController.swift
//  law
//
//  Created by Bahdan Piatrouski on 23.02.25.
//

import UIKit

final class FinanceAnalyticsFilterViewController: BaseViewController {
    
    
    private lazy var dynamicVScrollView = DynamicScrollView(axis: .vertical).setup {
        
    }
    
    private let viewModel: FinanceAnalyticsFilterViewModelProtocol

	init(viewModel: FinanceAnalyticsFilterViewModelProtocol) {
		self.viewModel = viewModel
		super.init()
	}
}
