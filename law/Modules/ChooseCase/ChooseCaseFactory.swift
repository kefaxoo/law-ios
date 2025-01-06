//
//  ChooseCaseFactory.swift
//  law
//
//  Created by Bahdan Piatrouski on 07.01.25.
//

import UIKit

final class ChooseCaseFactory {
    static func create(client: ClientInfo, delegate: ChooseCaseDelegate?) -> ChooseCaseViewController {
        ChooseCaseViewController(viewModel: ChooseCaseViewModel(client: client), delegate: delegate)
	}
}
