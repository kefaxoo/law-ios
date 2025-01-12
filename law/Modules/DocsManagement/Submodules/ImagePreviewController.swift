//
//  ImagePreviewController.swift
//  law
//
//  Created by Bahdan Piatrouski on 13.01.25.
//

import UIKit

final class ImagePreviewController: BaseViewController {
    private lazy var imageView = UIImageView().setup {
        $0.contentMode = .scaleAspectFit
        if let data = try? Data(contentsOf: DeviceStorageManager.shared.fullPath(for: self.document.filePath)) {
            $0.image = UIImage(data: data)
        }
    }
    
    private lazy var scrollView = UIScrollView().setup {
        $0.addSubview(self.imageView)
        self.imageView.snp.makeConstraints({ $0.center.size.equalToSuperview() })
        $0.minimumZoomScale = 1
        $0.maximumZoomScale = 3
        $0.delegate = self
    }
    
    private let document: ClientDocument
    
    init(document: ClientDocument) {
        self.document = document
        
        super.init()
    }
    
    override func setupLayout() {
        self.view.addSubview(self.scrollView)
    }
    
    override func setupConstraints() {
        self.scrollView.snp.makeConstraints({ $0.edges.equalTo(self.view.safeAreaLayoutGuide) })
    }
    
    override func setupNavigationController() {
        self.navigationItem.title = self.document.title
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Закрыть", style: .plain, target: self, action: #selector(rightBarButtonDidTap))
    }
}

// MARK: - UIScrollViewDelegate
extension ImagePreviewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        self.imageView
    }
}

// MARK: - Action
private extension ImagePreviewController {
    @objc func rightBarButtonDidTap(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
}
