//
//  ClientsCasesDBFactory.swift
//  law
//
//  Created by Bahdan Piatrouski on 16.12.24.
//

import UIKit

final class ClientsCasesDBFactory {
	static func create() -> ClientsCasesDBViewController {
		ClientsCasesDBViewController(viewModel: ClientsCasesDBViewModel())
	}
}
