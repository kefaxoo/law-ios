//
//  AddFinanceOperationFactory.swift
//  law
//
//  Created by Bahdan Piatrouski on 17.02.25.
//

import UIKit

final class AddFinanceOperationFactory {
    static func create(operation: FinanceOperation? = nil) -> AddFinanceOperationViewController {
        AddFinanceOperationViewController(viewModel: AddFinanceOperationViewModel(operation: operation))
	}
}
