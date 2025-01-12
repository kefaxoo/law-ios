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
    var popVC = CPassthroughSubject<Void>()
    
    var document: ClientDocument?
    
    private var selectedImage: UIImage?
    private var selectedFileUrl: URL?
    private var wasSelectedFileChanged = false
    
    init(document: ClientDocument?) {
        self.document = document
        if let document {
            let url = DeviceStorageManager.shared.fullPath(for: document.filePath)
            if document.isImage,
               let data = try? Data(contentsOf: url) {
                self.selectedImage = UIImage(data: data)
            } else if !document.isImage {
                self.selectedFileUrl = url
            }
        }
    }
    
    func setSelectedImage(_ image: UIImage) {
        self.selectedFileUrl = nil
        self.selectedImage = image
        self.wasSelectedFileChanged = true
    }
    
    func setSelectedFile(url: URL) {
        self.selectedImage = nil
        self.selectedFileUrl = url
        self.wasSelectedFileChanged = true
    }
}

// MARK: - Actions
extension AddDocumentViewModel {
    func saveButtonDidTap(title: String?) {
        guard let title = self.checkText(title, errorText: "Введите название документа") else { return }
        
        var filePath: String?
        if let document,
           self.wasSelectedFileChanged {
            do {
                _ = try DeviceStorageManager.shared.removeFile(at: document.filePath)
            } catch {
                self.present.send(UIAlertController(errorText: error.localizedDescription))
                return
            }
        }
        
        if let selectedImage {
            do {
                filePath = try DeviceStorageManager.shared.saveImage(image: selectedImage, name: title)
            } catch {
                self.present.send(UIAlertController(errorText: error.localizedDescription))
                return
            }
        } else if let selectedFileUrl {
            do {
                let selectedFilePath = selectedFileUrl.lastPathComponent
                _ = try DeviceStorageManager.shared.copyFile(from: selectedFileUrl, to: selectedFilePath)
                filePath = selectedFilePath
            } catch {
                self.present.send(UIAlertController(errorText: error.localizedDescription))
                return
            }
        } else {
            self.present.send(UIAlertController(errorText: "Выберите фотографию или файл документа"))
            return
        }
        
        guard let filePath else { return }
        
        if let document {
            document.title = title
            document.type = self.selectedType
            if self.wasSelectedFileChanged {
                document.filePath = filePath
            }
            
            DatabaseService.shared.saveChanges()
        } else {
            let document = ClientDocument(title: title, type: self.selectedType, uploadDate: Date(), filePath: filePath)
            DatabaseService.shared.saveObject(document)
        }
        
        NotificationCenter.default.post(name: .fetchDocuments, object: nil)
        self.popVC.send(())
    }
}

// MARK: - Private
private extension AddDocumentViewModel {
    func checkText(_ text: String?, errorText: String) -> String? {
        if text?.isEmpty ?? true {
            self.present.send(UIAlertController(errorText: errorText))
            return nil
        }
        
        return text
    }
}
