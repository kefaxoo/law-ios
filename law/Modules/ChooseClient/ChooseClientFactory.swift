//
//  ChooseClientFactory.swift
//  law
//
//  Created by Bahdan Piatrouski on 07.01.25.
//

import UIKit

final class ChooseClientFactory {
    static func create(delegate: ChooseClientDelegate?) -> ChooseClientViewController {
        ChooseClientViewController(viewModel: ChooseClientViewModel(), delegate: delegate)
	}
}
