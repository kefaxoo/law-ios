//
//  CasesDBFactory.swift
//  law
//
//  Created by Bahdan Piatrouski on 17.12.24.
//

import UIKit

final class CasesDBFactory {
	static func create() -> CasesDBViewController {
		CasesDBViewController(viewModel: CasesDBViewModel())
	}
}
