//
//  AddDocumentFactory.swift
//  law
//
//  Created by Bahdan Piatrouski on 11.01.25.
//

import UIKit

final class AddDocumentFactory {
	static func create() -> AddDocumentViewController {
		AddDocumentViewController(viewModel: AddDocumentViewModel())
	}
}
