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
        $0.text = self.viewModel.document == nil ? "Добавление\nдокумента" : "Изменение\nдокумента"
        $0.font = .systemFont(ofSize: 35, weight: .semibold)
        $0.textColor = .black
        $0.numberOfLines = 0
        $0.snp.makeConstraints({ $0.width.equalTo(UIScreen.main.bounds.width - 38) })
    }
    
    private lazy var documentTitleImageView = UIImageView().setup {
        $0.contentMode = .scaleAspectFit
        $0.image = .documentIcon
        $0.snp.makeConstraints({ $0.size.equalTo(32) })
        $0.tintColor = UIColor(hex: "#367EFF")
    }
    
    private lazy var documentTitleTextField = UITextField().setup {
        $0.attributedPlaceholder = NSAttributedString(string: "Название документа", attributes: [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 21)
        ])
        
        $0.font = .systemFont(ofSize: 21)
        $0.text = self.viewModel.document?.title
    }
    
    private lazy var documentTitleContentView = UIView().setup {
        $0.backgroundColor = UIColor(hex: "#F5F8FC")
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
        $0.addSubview(self.documentTitleImageView)
        self.documentTitleImageView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(15)
            make.leading.equalToSuperview().inset(21)
        }
        
        $0.addSubview(self.documentTitleTextField)
        self.documentTitleTextField.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(21)
            make.centerY.equalToSuperview()
            make.leading.equalTo(self.documentTitleImageView.snp.trailing).offset(21)
        }
    }
    
    private lazy var typeImageView = UIImageView().setup {
        $0.contentMode = .scaleAspectFit
        $0.image = self.viewModel.document?.type.icon
        $0.snp.makeConstraints({ $0.size.equalTo(26) })
    }
    
    private lazy var typeLabel = UILabel().setup {
        $0.font = .systemFont(ofSize: 20)
        $0.textColor = .black
        $0.text = self.viewModel.document?.type.title
        $0.numberOfLines = 1
    }
    
    private lazy var chevronRightImageView = UIImageView().setup {
        $0.image = UIImage(systemName: "chevron.right")
        $0.tintColor = UIColor(hex: "#085DFD")
        $0.contentMode = .scaleAspectFit
        $0.snp.makeConstraints({ $0.size.equalTo(20) })
    }
    
    private lazy var typeContentHStackView = UIStackView().setup {
        $0.spacing = 20
        $0.axis = .horizontal
        $0.addArrangedSubview(self.typeImageView)
        $0.addArrangedSubview(self.typeLabel)
        $0.addArrangedSubview(self.chevronRightImageView)
    }
    
    private lazy var typeButton = UIButton().setup {
        $0.showsMenuAsPrimaryAction = true
        $0.menu = UIMenu(options: .displayInline, children: self.viewModel.typeActions)
        $0.addSubview(self.typeContentHStackView)
        self.typeContentHStackView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(17)
            make.leading.equalToSuperview().inset(21)
            make.trailing.equalToSuperview().inset(20)
        }
        
        $0.layer.borderColor = UIColor(hex: "#D1D8E4").cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
    }
    
    private lazy var addFileImageView = UIImageView().setup {
        $0.contentMode = .scaleAspectFit
        $0.image = .fileIcon
        $0.snp.makeConstraints({ $0.size.equalTo(21) })
    }
    
    private lazy var addFileLabel = UILabel().setup {
        $0.text = "Выбрать файл"
        $0.font = .systemFont(ofSize: 21)
        $0.textColor = .white
    }
    
    private lazy var addFileContentView = UIView().setup {
        $0.backgroundColor = .clear
        $0.addSubview(self.addFileImageView)
        self.addFileImageView.snp.makeConstraints({ $0.verticalEdges.leading.equalToSuperview() })
        
        $0.addSubview(self.addFileLabel)
        self.addFileLabel.snp.makeConstraints { make in
            make.trailing.centerY.equalToSuperview()
            make.leading.equalTo(self.addFileImageView.snp.trailing).offset(13.5)
        }
    }
    
    private lazy var addFileButton = UIButton().setup {
        $0.showsMenuAsPrimaryAction = true
        $0.menu = UIMenu(options: .displayInline, children: self.viewModel.chooseFileActions(pickerDelegate: self, cameraDelegate: self, documentDelegate: self))
        $0.backgroundColor = UIColor(hex: "#357DFF")
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
        
        $0.addSubview(self.addFileContentView)
        self.addFileContentView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.verticalEdges.equalToSuperview().inset(17)
        }
    }
    
    private lazy var dynamicVStackView = DynamicScrollView(axis: .vertical).setup {
        $0.addSubview(self.titleLabel, spacingAfter: 22)
        $0.addSubview(self.documentTitleContentView, spacingAfter: 17)
        $0.addSubview(self.typeButton, spacingAfter: 17)
        $0.addSubview(self.addFileButton)
    }
    
    private lazy var saveButton = UIButton().setup {
        $0.setTitle(self.viewModel.document == nil ? "Добавить файл" : "Изменить файл", for: .normal)
        $0.addTarget(self, action: #selector(saveButtonDidTap), for: .touchUpInside)
        $0.setTitleColor(UIColor(hex: "#FFFDFD"), for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 22, weight: .medium)
        $0.backgroundColor = UIColor(hex: "#367EFF")
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
        $0.contentEdgeInsets = .init(top: 13, left: 0, bottom: 13, right: 0)
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
        self.dynamicVStackView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(13)
            make.horizontalEdges.equalToSuperview().inset(19)
        }
        
        self.saveButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide).inset(19)
            make.top.equalTo(self.dynamicVStackView.snp.bottom).offset(16)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    override func setupBindings() {
        self.viewModel.selectedTypePublished.sink { [weak self] type in
            self?.typeImageView.image = type.icon
            self?.typeLabel.text = type.title
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
        self.viewModel.saveButtonDidTap(title: self.documentTitleTextField.text)
    }
}

@available(iOS 17, *)
#Preview {
    AddDocumentFactory.create()
}
