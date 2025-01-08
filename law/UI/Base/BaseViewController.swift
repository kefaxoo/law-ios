//
//  BaseViewController.swift
//  law
//
//  Created by Bahdan Piatrouski on 16.12.24.
//

import UIKit
import Combine

class BaseViewController: UIViewController {
    var cancellables = Set<AnyCancellable>()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupInterface()
    }
    
    func setupInterface() {
        self.view.backgroundColor = .systemBackground
        
        self.setupLayout()
        self.setupConstraints()
        self.setupBindings()
        self.setupNavigationController()
    }
    
    func setupLayout() {}
    func setupConstraints() {}
    func setupBindings() {}
    func setupNavigationController() {}
    
    func addKeyboardDismiss() {
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewDidTap)))
    }
}

// MARK: - Actions
private extension BaseViewController {
    @objc func viewDidTap(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}
