//
//  UITextField+Ext.swift
//  law
//
//  Created by Bahdan Piatrouski on 16.12.24.
//

import UIKit

extension UITextField {
    static var roundedRect: UITextField {
        UITextField().setup { $0.borderStyle = .roundedRect }
    }
}
