//
//  PDFViewerViewController.swift
//  law
//
//  Created by Bahdan Piatrouski on 20.02.25.
//

import PDFKit

final class PDFViewerViewController: BaseViewController {
    private lazy var pdfView = PDFView().setup {
        $0.autoScales = true
        $0.pageBreakMargins = UIEdgeInsets(top: 20, left: 8, bottom: 32, right: 8)
        $0.document = self.document
    }
    
    private lazy var toolbar = UIToolbar().setup {
        $0.items = [UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .done, target: self, action: #selector(shareBarButtonItemDidTap))]
    }
    
    private let document: PDFDocument?
    
    init(documentData: Data) {
        self.document = PDFDocument(data: documentData)
        
        super.init()
    }
    
    override func setupLayout() {
        self.view.addSubview(self.pdfView)
        self.view.addSubview(self.toolbar)
    }
    
    override func setupConstraints() {
        self.pdfView.snp.makeConstraints({ $0.top.horizontalEdges.equalToSuperview() })
        self.toolbar.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.top.equalTo(self.pdfView.snp.bottom)
        }
    }
}

// MARK: - Actions
private extension PDFViewerViewController {
    @objc func shareBarButtonItemDidTap(_ sender: UIBarButtonItem) {
        guard let data = self.document?.dataRepresentation() else { return }
        
        let vc = UIActivityViewController(activityItems: [data], applicationActivities: nil)
        self.popoverPresentationController?.sourceView = self.toolbar
        self.present(vc, animated: true)
    }
}
