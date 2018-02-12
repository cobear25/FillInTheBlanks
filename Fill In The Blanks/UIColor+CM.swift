//
//  UIColor+CM.swift
//  Fill In The Blanks
//
//  Created by Cody Mace on 2/10/18.
//  Copyright © 2018 Cody Mace. All rights reserved.
//

import UIKit

extension UIColor {
    static func randomColor() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
    
    public class func hexColor(_ hexValue: Int, alpha: CGFloat = 1.0) -> UIColor {
        let red = (hexValue >> 16) & 0xFF
        let green = (hexValue >> 8) & 0xFF
        let blue = hexValue & 0xFF
        
        return RGBColor(CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: alpha)
    }
    
    public class func RGBColor(_ red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
        let alphaMax = max(0.0, alpha)
        let alphaMin = min(1.0, alphaMax)
        
        return UIColor(red: CGFloat(red/255.0), green: CGFloat(green/255.0), blue: CGFloat(blue/255.0), alpha: alphaMin).withAlphaComponent(1)
    }
    
    static var appPurple: UIColor {
        return UIColor.hexColor(0x6351CC)
    }
    
    static var appGreen: UIColor {
        return UIColor.hexColor(0x009688)
    }
    
    static var appPurpleLight: UIColor {
        return UIColor.hexColor(0xA59DD1)
    }
    
    static var appGreenLight: UIColor {
        return UIColor.hexColor(0x009688).withAlphaComponent(0.5)
    }
    
    static var appDarkGray: UIColor {
        return UIColor.hexColor(0x464646).withAlphaComponent(0.5)
    }
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
