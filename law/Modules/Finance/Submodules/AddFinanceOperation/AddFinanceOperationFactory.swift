//
//  AddFinanceOperationFactory.swift
//  law
//
//  Created by Bahdan Piatrouski on 17.02.25.
//

import UIKit

final class AddFinanceOperationFactory {
	static func create() -> AddFinanceOperationViewController {
		AddFinanceOperationViewController(viewModel: AddFinanceOperationViewModel())
	}
}
