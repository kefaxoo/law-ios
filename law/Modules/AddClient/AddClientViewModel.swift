//
//  AddClientViewModel.swift
//  law
//
//  Created by Bahdan Piatrouski on 16.12.24.
//

import UIKit

final class AddClientViewModel: AddClientViewModelProtocol {
    var clientTypeActions: [UIAction] {
        ClientInfo.ClientType.allCases.compactMap { [weak self] type in
            UIAction(title: type.title) { _ in
                self?.currentClientType = type
            }
        }
    }
    
    @Published private var currentClientType: ClientInfo.ClientType = .natural
    var currentClientTypePublished: CPublisher<ClientInfo.ClientType> {
        $currentClientType.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
    var presentAlert = CPassthroughSubject<UIAlertController>()
    var popVC = CPassthroughSubject<Void>()
}

// MARK: - Actions
extension AddClientViewModel {
    func createClient(lastName: String?, firstName: String?, fatherName: String?, birthDateTimestamp: TimeInterval, phoneNumber: String?, email: String?, address: String?) {
        guard let lastName = self.checkText(lastName, errorText: "Введите фамилию"),
              let firstName = self.checkText(firstName, errorText: "Введите имя"),
              let phoneNumber = self.checkText(phoneNumber, errorText: "Введите номер телефона"),
              let email = self.checkText(email, errorText: "Введите email"),
              let address = self.checkText(address, errorText: "Введите адрес")
        else { return }
        
        let client = ClientInfo(lastName: lastName, firstName: firstName, fatherName: fatherName, birthDateTimestamp: birthDateTimestamp, phoneNumber: phoneNumber, email: email, address: address, clientType: self.currentClientType)
        DatabaseService.shared.saveObject(client)
        NotificationCenter.default.post(name: .fetchClientsInfo, object: nil)
        self.popVC.send(())
    }
}

// MARK: - Private
private extension AddClientViewModel {
    func checkText(_ text: String?, errorText: String) -> String? {
        if text?.isEmpty ?? true {
            self.presentAlert.send(UIAlertController(errorText: errorText))
            return nil
        }
        
        return text
    }
}
