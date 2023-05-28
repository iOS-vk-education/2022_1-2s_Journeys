//
//  ErrorHUD.swift
//  Journeys
//
//  Created by Сергей Адольевич on 28.05.2023.
//

import Foundation
import UIKit
import PinLayout

final class ErrorHUDView: UIView {
    private let containerView: UIView = UIView()
    private let errorHUDLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        containerView.layer.cornerRadius = 8
        containerView.layer.masksToBounds = true
        containerView.backgroundColor =  UIColor(asset: Asset.Colors.Background.brightColor)
        
        errorHUDLabel.textColor = UIColor(asset: Asset.Colors.Text.mainTextColor)
        errorHUDLabel.textAlignment = .center
        errorHUDLabel.numberOfLines = 3
        
        containerView.addSubview(errorHUDLabel)
        addSubview(containerView)
    }
    
    func configure(with text: String) {
        errorHUDLabel.text = text
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        performLayout()
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        autoSizeThatFits(size, layoutClosure: performLayout)
    }
    
    private func performLayout() {
        containerView.pin
            .top()
        
        errorHUDLabel.pin
            .width(max(frame.size.width - 30, .zero))
            .sizeToFit(.widthFlexible)
        
        containerView.pin
            .wrapContent(padding: 15)
            .hCenter()
    }
}
