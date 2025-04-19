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

// MARK: - Keyboard
extension BaseViewController {
    typealias KeyboardAnimation = ((_ height: CGFloat) -> Void)
    func setupKeyboardSupport(animation: @escaping KeyboardAnimation) {
        self.view.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(viewDidTap))
        )
        
        NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillShowNotification)
            .receive(on: DispatchQueue.main)
            .sink { [weak self, animation] notification in
                self?.keyboardWillShowOrHide(
                    notification: notification,
                    isShow: true,
                    animation: animation
                )
            }.store(in: &cancellables)
        
        NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillHideNotification)
            .receive(on: DispatchQueue.main)
            .sink { [weak self, animation] notification in
                self?.keyboardWillShowOrHide(
                    notification: notification,
                    isShow: false,
                    animation: animation
                )
            }.store(in: &cancellables)
    }
    
    func keyboardWillShowOrHide(
        notification: Notification,
        isShow: Bool,
        animation: @escaping KeyboardAnimation
    ) {
        guard let userInfo = notification.userInfo,
              let endFrameRaw = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
              let curveRaw = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber,
              let durationRaw = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey],
              let duration = (durationRaw as? NSNumber)?.doubleValue
        else { return }
        
        let endFrame = endFrameRaw.cgRectValue
        let curve = UIView.AnimationOptions(rawValue: UInt(curveRaw.uintValue << 16))
        
        UIView.animate(withDuration: duration, delay: 0, options: curve) { [weak self] in
            animation(isShow ? endFrame.size.height : 0)
            self?.view.layoutIfNeeded()
        }
    }
}
