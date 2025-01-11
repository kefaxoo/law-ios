//
//  DocsManagementFactory.swift
//  law
//
//  Created by Bahdan Piatrouski on 11.01.25.
//

import UIKit

final class DocsManagementFactory {
	static func create() -> DocsManagementViewController {
		DocsManagementViewController(viewModel: DocsManagementViewModel())
	}
}
