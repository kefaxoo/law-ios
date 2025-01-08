//
//  LoaderViewController.swift
//  law
//
//  Created by Bahdan Piatrouski on 9.01.25.
//

import UIKit

final class LoaderViewController: BaseViewController {
    private lazy var activityIndicatorView = UIActivityIndicatorView().setup {
        $0.style = .large
        $0.startAnimating()
    }
    
    @UserDefaultsWrapper(key: .currentUserId, value: nil)
    private var currentUserId: String?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let keyWindow = UIApplication.shared.connectedScenes.compactMap({ $0 as? UIWindowScene }).first?.keyWindow
            keyWindow?.rootViewController = self.currentUserId == nil ? UINavigationController(rootViewController: AuthFactory.create(mode: .signIn)) : MenuFactory.create()
            keyWindow?.makeKeyAndVisible()
        }
    }
    
    override func setupLayout() {
        self.view.addSubview(self.activityIndicatorView)
    }
    
    override func setupConstraints() {
        self.activityIndicatorView.snp.makeConstraints({ $0.center.equalToSuperview() })
    }
}
