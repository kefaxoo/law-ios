//
//  AddClientFactory.swift
//  law
//
//  Created by Bahdan Piatrouski on 16.12.24.
//

import UIKit

final class AddClientFactory {
	static func create() -> AddClientViewController {
		AddClientViewController(viewModel: AddClientViewModel())
	}
}
