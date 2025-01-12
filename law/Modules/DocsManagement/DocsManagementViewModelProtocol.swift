//
//  DocsManagementViewModelProtocol.swift
//  law
//
//  Created by Bahdan Piatrouski on 11.01.25.
//

import UIKit

protocol DocsManagementViewModelProtocol {
    var documents: [ClientDocument] { get }
    var documentsPublished: CPublisher<[ClientDocument]> { get }
        
    var pushVC: CPassthroughSubject<BaseViewController> { get }
    var present: CPassthroughSubject<UIViewController> { get }
    
    func fetchDocuments()
    
    func rightBarButtonDidTap()
    func tableViewDidSelect(at indexPath: IndexPath, delegate: UIDocumentInteractionControllerDelegate?)
}
