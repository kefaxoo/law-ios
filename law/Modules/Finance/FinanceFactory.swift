//
//  FinanceFactory.swift
//  law
//
//  Created by Bahdan Piatrouski on 17.02.25.
//

import UIKit

final class FinanceFactory {
	static func create() -> FinanceViewController {
		FinanceViewController(viewModel: FinanceViewModel())
	}
}
