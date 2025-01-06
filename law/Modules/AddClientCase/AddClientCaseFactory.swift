//
//  AddClientCaseFactory.swift
//  law
//
//  Created by Bahdan Piatrouski on 17.12.24.
//

import UIKit

final class AddClientCaseFactory {
    static func create(client: ClientInfo, clientCase: ClientCase? = nil) -> AddClientCaseViewController {
        AddClientCaseViewController(viewModel: AddClientCaseViewModel(client: client, clientCase: clientCase))
	}
}
