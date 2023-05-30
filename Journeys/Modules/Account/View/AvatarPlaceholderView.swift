//
//  AvatarPlaceholderView.swift
//  Journeys
//
//  Created by Сергей Адольевич on 28.05.2023.
//

import Foundation
import UIKit

final class AvatarPlaceholderView: UIView {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.fill")
        imageView.contentMode = .scaleAspectFit
        
        imageView.tintColor = UIColor(asset: Asset.Colors.BaseColors.similarToThemeColor)
        return imageView
    }()
    
    private let emptyBackgroundView = UIView()
    private let backgrounLayer = CAGradientLayer()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(asset: Asset.Colors.Avatar.background)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        backgroundColor = .red
        setupSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgrounLayer.frame = bounds
        backgrounLayer.cornerRadius = layer.cornerRadius
        emptyBackgroundView.layer.cornerRadius = layer.cornerRadius
    }
    
    private func setupSubviews() {
        addSubview(emptyBackgroundView)
        addSubview(imageView)
        
        emptyBackgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalToSuperview().inset(20)
            make.width.equalToSuperview().inset(20)
        }
        
        setup()
    }

    func setup() {
        backgrounLayer.startPoint = CGPoint(x: 0, y: 0.5)
        backgrounLayer.endPoint = CGPoint(x: 1, y: 0.5)
        emptyBackgroundView.layer.addSublayer(backgrounLayer)

        let backgroundGroup = makeAnimationGroup()
        backgroundGroup.beginTime = 0.0
        backgrounLayer.add(backgroundGroup, forKey: "backgroundColor")
    }
    
    func showSkeleton() {
        emptyBackgroundView.isHidden = false
        imageView.isHidden = true
    }

    func hideSkeleton() {
        emptyBackgroundView.isHidden = true
        imageView.isHidden = false
    }
}

extension AvatarPlaceholderView: SkeletonLoadable {
    
}
