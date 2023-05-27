//
//  ViewWithChangeableTouchableArea.swift
//  Journeys
//
//  Created by Сергей Адольевич on 16.05.2023.
//

import Foundation
import UIKit

final class ViewWithChangeableTouchableArea: UIView {
    private(set) lazy var touchableAreaRect = CGRect(x: frame.origin.x,
                                                     y: frame.origin.y ,
                                                     width: frame.width,
                                                     height: frame.height)

    func setNewTouchableArea(_ rect: CGRect) {
        touchableAreaRect = rect
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        touchableAreaRect.contains(point)
    }
}
