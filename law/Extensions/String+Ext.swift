//
//  String+Ext.swift
//  law
//
//  Created by Bahdan Piatrouski on 28.04.25.
//

import UIKit

extension String {
    func image(size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.white.set()
        let rect = CGRect(origin: .zero, size: size)
        UIRectFill(CGRect(origin: .zero, size: size))
        (self as AnyObject).draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: size.height)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    var isValidEmail: Bool {
        NSPredicate(format: "SELF MATCHES %@", "^[a-zA-Z0-9]+[@]{1}[a-zA-Z]+[.]{1}[a-zA-Z]{2,3}.?[a-zA-Z]{0,3}$").evaluate(with: self)
    }
}
