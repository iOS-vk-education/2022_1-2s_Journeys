//
//  RouteView.swift
//  Journeys
//
//  Created by Сергей Адольевич on 14.12.2022.
//

import Foundation
import UIKit
import SnapKit

final class RouteCell: UICollectionViewCell {
    struct DisplayData {
        let route: String
    }
    
    private let routeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = UIColor(asset: Asset.Colors.Text.mainTextColor)
        return label
    }()
    
    lazy var width: NSLayoutConstraint = {
        let width = contentView.widthAnchor.constraint(equalToConstant: bounds.size.width)
        width.isActive = true
        return width
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        width.constant = bounds.size.width
        return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 1))
    }

    private func setupView() {
        addSubview(routeLabel)
        routeLabel.numberOfLines = 0
        routeLabel.textAlignment = .center
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        routeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(Constants.RouteLabel.horisontalSpacing)
            make.trailing.equalToSuperview().inset(Constants.RouteLabel.horisontalSpacing)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func configure(data: DisplayData) {
        self.routeLabel.text = data.route
    }
}

private extension RouteCell {
    enum Constants {
        
        enum RouteLabel {
            static let horisontalSpacing: CGFloat = 40
            static let topSpacingFromSectionHeader: CGFloat = 17
        }
    }
}


