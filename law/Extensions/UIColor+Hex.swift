//
//  UIColor+Hex.swift
//  law
//
//  Created by Bahdan Piatrouski on 19.04.25.
//

import UIKit

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        // Удаляем #, если есть
        if hexFormatted.hasPrefix("#") {
            hexFormatted.removeFirst()
        }

        // HEX должен быть длиной 6 символов
        guard hexFormatted.count == 6 else {
            self.init(white: 0.0, alpha: 0.0) // Возвращаем прозрачный цвет при ошибке
            return
        }

        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)

        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
