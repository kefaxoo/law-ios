//
//  DocsManagementViewModel.swift
//  law
//
//  Created by Bahdan Piatrouski on 11.01.25.
//

import UIKit

final class DocsManagementViewModel: DocsManagementViewModelProtocol {
    @Published var documents = [ClientDocument]()
    var documentsPublished: CPublisher<[ClientDocument]> {
        $documents.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
    var pushVC = CPassthroughSubject<BaseViewController>()
    var present = CPassthroughSubject<UIViewController>()
    
    init() {
        self.fetchDocuments()
    }
    
    func fetchDocuments() {
        DatabaseService.shared.fetchObjects(type: ClientDocument.self) { [weak self] objects, error in
            self?.documents = objects ?? []
        }
    }
}

// MARK: - Actions
extension DocsManagementViewModel {
    func rightBarButtonDidTap() {
        self.pushVC.send(AddDocumentFactory.create())
    }
    
    func tableViewDidSelect(at indexPath: IndexPath, delegate: UIDocumentInteractionControllerDelegate?) {
        let document = self.documents[indexPath.row]
        let alert = UIAlertController(title: "Действие с документом", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Открыть", style: .default, handler: { [weak self] _ in
            if document.isImage {
                self?.present.send(UINavigationController(rootViewController: ImagePreviewController(document: document)))
            } else {
                let vc = UIDocumentInteractionController(url: DeviceStorageManager.shared.fullPath(for: document.filePath))
                vc.delegate = delegate
                vc.presentPreview(animated: true)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Изменить", style: .default, handler: { [weak self] _ in
            self?.pushVC.send(AddDocumentFactory.create(document: document))
        }))
        
        self.present.send(alert)
    }
}
