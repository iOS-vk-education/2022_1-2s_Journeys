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

//enum SkeletonLoadableViews {
//    case view(UIView)
//    case label(UILabel)
//
//    static func associatedViewValue() -> UIView? {
//        switch
//    }
//}

struct ViewWithLayer {
    let view: UIView
    let layer: CAGradientLayer
}

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
    
    func configureSkeletons(views: [ViewWithLayer]) {
        var animationGroups: [CAAnimationGroup] = []
        for (index, view) in views.enumerated() {
            view.layer.startPoint = CGPoint(x: 0, y: 0.5)
            view.layer.endPoint = CGPoint(x: 1, y: 0.5)
            view.view.layer.addSublayer(view.layer)
            
            if index == 0 {
                let group = makeAnimationGroup()
                group.beginTime = 0.0
                view.layer.add(group, forKey: "backgroundColor")
                animationGroups.append(group)
            } else {
                let group = makeAnimationGroup(previousGroup: animationGroups[index - 1])
                view.layer.add(group, forKey: "backgroundColor")
                animationGroups.append(group)
            }
        }
    }
    
    func setAllSubviewsAlphaToZero(views: [UIView]) {
        for view in views {
            view.alpha = 0
        }
    }
    
    func setSubviewsAlphaToOne(views: [UIView]) {
        for view in views {
            view.alpha = 1
        }
    }
    
}
