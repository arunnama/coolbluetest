//
//  UIColor+Extensions.swift
//  CoolblueSearch
//
//  Created by Arun Kumar Nama on 18/10/22.
//


import UIKit

extension UIColor {

    func lightSkyBlue() -> UIColor {
        return self.rgbCalculation(redColor: 135, greenColor: 206, blueColor: 250, alphaValue: 1)
    }

    func rgbCalculation(redColor:CGFloat, greenColor: CGFloat, blueColor: CGFloat, alphaValue:CGFloat) -> UIColor {
        
        return UIColor(red: redColor/255, green: greenColor/255, blue: blueColor/255, alpha: alphaValue)
    }
}
