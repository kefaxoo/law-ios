//
//  ClientCasesFactory.swift
//  law
//
//  Created by Bahdan Piatrouski on 17.12.24.
//

import UIKit

final class ClientCasesFactory {
    static func create(client: ClientInfo) -> ClientCasesViewController {
        ClientCasesViewController(viewModel: ClientCasesViewModel(client: client))
	}
}
