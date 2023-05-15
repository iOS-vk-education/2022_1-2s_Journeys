//
//  BSPresentationController.swift
//  Journeys
//
//  Created by Ангелина Решетникова on 12.05.2023.
//

import Foundation
import UIKit
import Combine

public final class BottomSheetPresentationController: UIPresentationController {
    

    
    public override var shouldPresentInFullscreen: Bool {
        false
    }
    
    public override var frameOfPresentedViewInContainerView: CGRect {
        targetFrameForPresentedView()
    }

    private func targetFrameForPresentedView() -> CGRect {
        guard let containerView = containerView else {
            return .zero
        }

        let windowInsets = presentedView?.window?.safeAreaInsets ?? .zero

        let preferredHeight = presentedViewController.preferredContentSize.height + windowInsets.bottom
        let maxHeight = containerView.bounds.height - windowInsets.top
        let height = min(preferredHeight, maxHeight)

        return .init(
            x: 0,
            y: (containerView.bounds.height - height).pixelCeiled,
            width: containerView.bounds.width,
            height: height.pixelCeiled
        )
    }
}
