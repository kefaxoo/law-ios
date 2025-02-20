//
//  ReceivablesClientsFactory.swift
//  law
//
//  Created by Bahdan Piatrouski on 20.02.25.
//

import UIKit

final class ReceivablesClientsFactory {
	static func create() -> ReceivablesClientsViewController {
		ReceivablesClientsViewController(viewModel: ReceivablesClientsViewModel())
	}
}
