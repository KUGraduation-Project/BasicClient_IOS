//
//  UIColor+Ext.swift
//  GProject
//
//  Created by 서정 on 2022/04/29.
//

import UIKit

enum Colors {
    case backgroundBlack
    case mainBlue
}

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }

    convenience init(rgb: Int, alpha: CGFloat) {
        self.init(
            red: CGFloat((rgb >> 16) & 0xFF),
            green: CGFloat((rgb >> 8) & 0xFF),
            blue: CGFloat(rgb & 0xFF),
            alpha: alpha
        )
    }
}


extension UIColor {
    static func appColor(_ name: Colors) -> UIColor {
        switch name {
        case .backgroundBlack:
            return UIColor(rgb: 0x191919)
        case .mainBlue:
            return UIColor(rgb: 0x4646CD)
        }
    }
       
}
