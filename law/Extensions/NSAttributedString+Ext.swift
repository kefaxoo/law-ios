//
//  NSAttributedString+Ext.swift
//  law
//
//  Created by Bahdan Piatrouski on 19.02.25.
//

import Foundation

extension NSAttributedString {
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            context: nil
        )
        
        return ceil(boundingBox.height)
    }
}
