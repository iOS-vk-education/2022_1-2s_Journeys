//
//  v.swift
//  Journeys
//
//  Created by Сергей Адольевич on 14.12.2022.
//

import Foundation
import UIKit
import SnapKit

final class ShortRouteCell: UICollectionViewCell {
    struct DisplayData {
        let route: String
    }
    
    private let routeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = UIColor(asset: Asset.Colors.Text.mainTextColor)
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    private func setupView() {
        addSubview(routeLabel)
        routeLabel.numberOfLines = 0
        routeLabel.textAlignment = .center
        routeLabel.lineBreakMode = .byWordWrapping
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        routeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(Constants.RouteLabel.horisontalSpacing)
            make.trailing.equalToSuperview().inset(Constants.RouteLabel.horisontalSpacing)
            make.width.lessThanOrEqualTo(250)
//            make.height.greaterThanOrEqualTo(20)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func getLabelLinesCount() -> Int {
        routeLabel.calculateMaxLines()
    }
    
    func configure(data: DisplayData) {
        self.routeLabel.text = data.route
    }
}

private extension ShortRouteCell {
    enum Constants {
        
        enum RouteLabel {
            static let horisontalSpacing: CGFloat = 40
            static let topSpacingFromSectionHeader: CGFloat = 17
        }
    }
}


