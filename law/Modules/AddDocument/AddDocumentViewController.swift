//
//  AddDocumentViewController.swift
//  law
//
//  Created by Bahdan Piatrouski on 11.01.25.
//

import UIKit
import PhotosUI

final class AddDocumentViewController: BaseViewController {
    private lazy var titleLabel = UILabel().setup {
        $0.text = "Название документа"
        $0.snp.makeConstraints({ $0.width.equalTo(UIScreen.main.bounds.width - 32) })
    }
    
    private lazy var titleTextField = UITextField.roundedRect.setup {
        $0.placeholder = "Введите название документа..."
    }
    
    private lazy var typeLabel = UILabel().setup { $0.text = "Тип документа" }
    
    private lazy var typeButton = UIButton(configuration: .tinted()).setup {
        $0.showsMenuAsPrimaryAction = true
        $0.menu = UIMenu(options: .displayInline, children: self.viewModel.typeActions)
    }
    
    private lazy var addFileButton = UIButton(configuration: .filled()).setup {
        $0.setTitle("Выбрать файл", for: .normal)
        $0.showsMenuAsPrimaryAction = true
        $0.menu = UIMenu(options: .displayInline, children: self.viewModel.chooseFileActions(pickerDelegate: self, cameraDelegate: self, documentDelegate: self))
    }
    
    private lazy var dynamicVStackView = DynamicScrollView(axis: .vertical).setup {
        $0.addSubview(self.titleLabel, spacingAfter: 16)
        $0.addSubview(self.titleTextField, spacingAfter: 16)
        $0.addSubview(self.typeLabel, spacingAfter: 16)
        $0.addSubview(self.typeButton, spacingAfter: 16)
        $0.addSubview(self.addFileButton)
    }
    
    private let viewModel: AddDocumentViewModelProtocol

	init(viewModel: AddDocumentViewModelProtocol) {
		self.viewModel = viewModel
		super.init()
	}
    
    override func setupInterface() {
        super.setupInterface()
        
        self.addKeyboardDismiss()
    }
    
    override func setupLayout() {
        self.view.addSubview(self.dynamicVStackView)
    }
    
    override func setupConstraints() {
        self.dynamicVStackView.snp.makeConstraints({ $0.edges.equalTo(self.view.safeAreaLayoutGuide).inset(16) })
    }
    
    override func setupNavigationController() {
        self.navigationItem.title = "Добавление докумнта"
    }
    
    override func setupBindings() {
        self.viewModel.selectedTypePublished.sink { [weak self] type in
            self?.typeButton.setTitle(type.title, for: .normal)
        }.store(in: &cancellables)
        
        self.viewModel.present.sink { [weak self] vc in
            self?.present(vc, animated: true)
        }.store(in: &cancellables)
    }
}

// MARK: - PHPickerViewControllerDelegate
extension AddDocumentViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let provider = results.first?.itemProvider,
              provider.canLoadObject(ofClass: UIImage.self)
        else { return }
        
        provider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
            debugPrint(error as Any)
            guard let image = image as? UIImage else { return }
            
            self?.viewModel.setSelectedImage(image)
        }
    }
}

// MARK: - AddDocumentViewModelProtocol.CameraDelegate
extension AddDocumentViewController: AddDocumentViewModelProtocol.CameraDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = (info[.originalImage] ?? info[.editedImage]) as? UIImage else { return }

        self.viewModel.setSelectedImage(image)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

// MARK: - UIDocumentPickerDelegate
extension AddDocumentViewController: UIDocumentPickerDelegate {
    
}
