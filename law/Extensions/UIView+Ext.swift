//
//  UIView+Ext.swift
//  law
//
//  Created by Bahdan Piatrouski on 22.02.25.
//

import UIKit

extension UIView {
    static var spacer: UIView {
        UIView().setup({ $0.backgroundColor = .clear })
    }
}
