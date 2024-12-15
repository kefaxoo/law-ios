//
//  AddClientViewModelProtocol.swift
//  law
//
//  Created by Bahdan Piatrouski on 16.12.24.
//

import UIKit

protocol AddClientViewModelProtocol {
    var clientTypeActions: [UIAction] { get }
    
    var currentClientTypePublished: CPublisher<ClientInfo.ClientType> { get }
    
    var presentAlert: CPassthroughSubject<UIAlertController> { get }
    var popVC: CPassthroughSubject<Void> { get }
    
    func createClient(lastName: String?, firstName: String?, fatherName: String?, birthDateTimestamp: TimeInterval, phoneNumber: String?, email: String?, address: String?)
}
