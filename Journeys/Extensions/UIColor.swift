//
//  UIColor.swift
//  Journeys
//
//  Created by Сергей Адольевич on 16.05.2023.
//

import Foundation
import UIKit

extension UIColor {
    var redValue: CGFloat{ return CIColor(color: self).red }
    var greenValue: CGFloat{ return CIColor(color: self).green }
    var blueValue: CGFloat{ return CIColor(color: self).blue }
    var alphaValue: CGFloat{ return CIColor(color: self).alpha }
}
