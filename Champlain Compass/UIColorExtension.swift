//
//  UIColorExtension.swift
//  Champlain Compass
//
//  Copyright © 2018 Travis Spinelli
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//  This code was orginally borrowed from: https://crunchybagel.com/working-with-hex-colors-in-swift-3/
//  It has been modified from its orginial form but not to an appriaciable extent
//
//  Purpose: This file creates an extension to the UIColor class which will allow hexidecimal color strings to be converted into a UIColor. The format that is being looked for is #xxxxxx where x are the numbers.

import Foundation
import UIKit

extension UIColor {
    //convience constructor
    convenience init(hex: String) {
        //create a scanner for working through the characters of the string
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 1
        
        //create a variable to store the color code
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        //grab each separate color of the hexidecimal color code
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        //create the UIColor
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}
