//
//  UIAlertController+Ext.swift
//  law
//
//  Created by Bahdan Piatrouski on 22.12.24.
//

import UIKit

extension UIAlertController {
    convenience init(errorText text: String) {
        self.init(title: text, message: nil, preferredStyle: .alert)
        
        self.addAction(UIAlertAction(title: "OK", style: .destructive))
    }
    
    static func okAlert(title: String? = nil, message: String? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            alert.dismiss(animated: true)
        }))
        
        return alert
    }
}
