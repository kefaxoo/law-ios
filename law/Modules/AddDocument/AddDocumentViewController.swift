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
        $0.text = self.viewModel.document?.title
    }
    
    private lazy var typeLabel = UILabel().setup { $0.text = "Тип документа" }
    
    private lazy var typeButton = UIButton(configuration: .tinted()).setup {
        $0.showsMenuAsPrimaryAction = true
        $0.menu = UIMenu(options: .displayInline, children: self.viewModel.typeActions)
        if let type = self.viewModel.document?.type.title {
            $0.setTitle(type, for: .normal)
        }
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
    
    private lazy var saveButton = UIButton(configuration: .filled()).setup {
        $0.setTitle(self.viewModel.document == nil ? "Добавить файл" : "Изменить файл", for: .normal)
        $0.addTarget(self, action: #selector(saveButtonDidTap), for: .touchUpInside)
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
        self.view.addSubview(self.saveButton)
    }
    
    override func setupConstraints() {
        self.dynamicVStackView.snp.makeConstraints({ $0.horizontalEdges.top.equalTo(self.view.safeAreaLayoutGuide).inset(16) })
        
        self.saveButton.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(16)
            make.top.equalTo(self.dynamicVStackView.snp.bottom).offset(16)
        }
    }
    
    override func setupNavigationController() {
        self.navigationItem.title = self.viewModel.document == nil ? "Добавление документа" : "Изменение документа"
    }
    
    override func setupBindings() {
        self.viewModel.selectedTypePublished.sink { [weak self] type in
            self?.typeButton.setTitle(type.title, for: .normal)
        }.store(in: &cancellables)
        
        self.viewModel.present.sink { [weak self] vc in
            self?.present(vc, animated: true)
        }.store(in: &cancellables)
        
        self.viewModel.popVC.sink { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
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
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        controller.dismiss(animated: true)
        
        guard let url = urls.first else { return }
        
        self.viewModel.setSelectedFile(url: url)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true)
    }
}

// MARK: - Actions
private extension AddDocumentViewController {
    @objc func saveButtonDidTap(_ sender: UIButton) {
        self.viewModel.saveButtonDidTap(title: self.titleTextField.text)
    }
}
