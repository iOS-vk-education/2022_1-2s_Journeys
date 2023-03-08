//
//  SkeletonLoadable.swift
//  Journeys
//
//  Created by Сергей Адольевич on 08.03.2023.
//

import Foundation
import UIKit

/*
 Function programming inheritance.
 */

protocol SkeletonLoadable {}

extension SkeletonLoadable {
    
    func makeAnimationGroup(previousGroup: CAAnimationGroup? = nil) -> CAAnimationGroup {
        let animDuration: CFTimeInterval = 1.5
        let anim1 = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.backgroundColor))
        anim1.fromValue = UIColor(asset: Asset.Colors.Skeleton.light)?.cgColor
        anim1.toValue = UIColor(asset: Asset.Colors.Skeleton.dark)?.cgColor
        anim1.duration = animDuration
        anim1.beginTime = 0.0

        let anim2 = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.backgroundColor))
        anim2.fromValue = UIColor(asset: Asset.Colors.Skeleton.dark)?.cgColor
        anim2.toValue = UIColor(asset: Asset.Colors.Skeleton.light)?.cgColor
        anim2.duration = animDuration
        anim2.beginTime = anim1.beginTime + anim1.duration

        let group = CAAnimationGroup()
        group.animations = [anim1, anim2]
        group.repeatCount = .greatestFiniteMagnitude // infinite
        group.duration = anim2.beginTime + anim2.duration
        group.isRemovedOnCompletion = false

        if let previousGroup = previousGroup {
            group.beginTime = previousGroup.beginTime + 0.33
        }

        return group
    }
    
}
