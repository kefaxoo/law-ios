//
//  ClientsCasesFactory.swift
//  law
//
//  Created by Bahdan Piatrouski on 16.12.24.
//

import UIKit

final class ClientsCasesFactory {
	static func create() -> ClientsCasesViewController {
		ClientsCasesViewController(viewModel: ClientsCasesViewModel())
	}
}
