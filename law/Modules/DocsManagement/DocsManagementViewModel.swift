//
//  DocsManagementViewModel.swift
//  law
//
//  Created by Bahdan Piatrouski on 11.01.25.
//

import Foundation

final class DocsManagementViewModel: DocsManagementViewModelProtocol {
    var pushVC = CPassthroughSubject<BaseViewController>()
}

// MARK: - Actions
extension DocsManagementViewModel {
    func rightBarButtonDidTap() {
        self.pushVC.send(AddDocumentFactory.create())
    }
}
