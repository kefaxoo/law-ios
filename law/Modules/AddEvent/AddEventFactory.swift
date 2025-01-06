//
//  AddEventFactory.swift
//  law
//
//  Created by Bahdan Piatrouski on 06.01.25.
//

import UIKit

final class AddEventFactory {
	static func create() -> AddEventViewController {
		AddEventViewController(viewModel: AddEventViewModel())
	}
}
