//
//  AddDocumentViewModel.swift
//  law
//
//  Created by Bahdan Piatrouski on 11.01.25.
//

import UIKit
import PhotosUI
import CoreServices

final class AddDocumentViewModel: AddDocumentViewModelProtocol {
    var typeActions: [UIAction] {
        ClientDocument.DocumentType.allCases.compactMap { type in
            UIAction(title: type.title) { [weak self] _ in
                self?.selectedType = type
            }
        }
    }
    
    @Published private var selectedType: ClientDocument.DocumentType = .pasport
    var selectedTypePublished: CPublisher<ClientDocument.DocumentType> {
        $selectedType.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
    func chooseFileActions(pickerDelegate: PHPickerViewControllerDelegate, cameraDelegate: CameraDelegate, documentDelegate: UIDocumentPickerDelegate) -> [UIAction] {
        var array = [UIAction]()
        
        array.append(UIAction(title: "Изображение", image: UIImage(systemName: "photo"), handler: { [weak self] _ in
            var configuration = PHPickerConfiguration()
            configuration.selectionLimit = 1
            configuration.filter = .images
            
            let vc = PHPickerViewController(configuration: configuration)
            vc.delegate = pickerDelegate
            
            self?.present.send(vc)
        }))
        
        array.append(UIAction(title: "Камера", image: UIImage(systemName: "camera"), handler: { [weak self] _ in
            guard UIImagePickerController.isSourceTypeAvailable(.camera),
                  let mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera)
            else { return }
            
            let picker = UIImagePickerController()
            picker.mediaTypes = mediaTypes
            picker.delegate = cameraDelegate
            picker.sourceType = .camera
            picker.cameraCaptureMode = .photo
            picker.cameraDevice = .rear
            
            self?.present.send(picker)
        }))
        
        array.append(UIAction(title: "Файл", image: UIImage(systemName: "filemenu.and.selection"), handler: { [weak self] _ in
            let vc = UIDocumentPickerViewController(
                forOpeningContentTypes: [
                    UTType.pdf,
                    UTType.image,
                    UTType(filenameExtension: "doc"),
                    UTType(filenameExtension: "docx")
                ].compactMap({ $0 })
            )
            vc.delegate = documentDelegate
            vc.allowsMultipleSelection = false
            self?.present.send(vc)
        }))
        
        return array
    }
    
    var present = CPassthroughSubject<UIViewController>()
    
    private var selectedImage: UIImage?
    
    func setSelectedImage(_ image: UIImage) {
        self.selectedImage = image
    }
}
