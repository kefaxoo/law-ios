//
//  AddDocumentViewModelProtocol.swift
//  law
//
//  Created by Bahdan Piatrouski on 11.01.25.
//

import UIKit
import PhotosUI

protocol AddDocumentViewModelProtocol {
    typealias CameraDelegate = UIImagePickerControllerDelegate & UINavigationControllerDelegate
    
    var typeActions: [UIAction] { get }
    
    var selectedTypePublished: CPublisher<ClientDocument.DocumentType> { get }
    
    var present: CPassthroughSubject<UIViewController> { get }
    
    func chooseFileActions(pickerDelegate: PHPickerViewControllerDelegate, cameraDelegate: CameraDelegate, documentDelegate: UIDocumentPickerDelegate) -> [UIAction]
    
    func setSelectedImage(_ image: UIImage)
}
