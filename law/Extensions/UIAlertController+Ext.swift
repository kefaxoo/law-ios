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
}
