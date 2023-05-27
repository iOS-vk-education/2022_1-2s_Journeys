//
//  BottomSheetTransitioningDelegate.swift
//  Journeys
//
//  Created by Ангелина Решетникова on 12.05.2023.
//

import UIKit

public final class BottomSheetTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    private func _presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> BottomSheetPresentationController {
        BottomSheetPresentationController(
            presentedViewController: presented,
            presenting: presenting
        )
    }
}
