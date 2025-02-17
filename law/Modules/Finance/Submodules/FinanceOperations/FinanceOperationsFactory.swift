//
//  FinanceOperationsFactory.swift
//  law
//
//  Created by Bahdan Piatrouski on 17.02.25.
//

import UIKit

final class FinanceOperationsFactory {
	static func create() -> FinanceOperationsViewController {
		FinanceOperationsViewController(viewModel: FinanceOperationsViewModel())
	}
}
