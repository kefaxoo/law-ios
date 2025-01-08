//
//  AuthViewModelProtocol.swift
//  law
//
//  Created by Bahdan Piatrouski on 09.01.25.
//

import UIKit

protocol AuthViewModelProtocol {
    var mode: AuthMode { get }
    
    var pushVC: CPassthroughSubject<BaseViewController> { get }
    var popVC: CPassthroughSubject<Void> { get }
    var presentAlert: CPassthroughSubject<UIAlertController> { get }
    
    // MARK: - Actions
    func changeModeButtonDidTap()
    func bottomButtonDidTap(login: String?, password: String?)
}
