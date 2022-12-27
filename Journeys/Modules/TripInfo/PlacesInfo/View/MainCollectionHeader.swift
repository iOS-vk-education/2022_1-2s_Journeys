//
//  MainCollectionHeader.swift
//  Journeys
//
//  Created by Сергей Адольевич on 14.12.2022.
//

import Foundation
import UIKit
import SnapKit

final class MainCollectionHeader: UICollectionReusableView {
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Constants.BackgroundView.height / 2
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor(asset: Asset.Colors.PlacesInfo.SectionHeader.background)
        return view
    }()
    
    private let title: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
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
        title.textAlignment = .center

        setupConstraints()
    }
    
    private func setupConstraints() {
        addSubview(backgroundView)
        backgroundView.addSubview(title)
        
        backgroundView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(Constants.BackgroundView.horisontalInsets)
            make.trailing.equalToSuperview().inset(Constants.BackgroundView.horisontalInsets)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(Constants.BackgroundView.height)
        }
        
        title.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(title: String) {
        self.title.text = title
    }
}

private extension MainCollectionHeader {
    enum Constants {
        enum BackgroundView {
            static let height: CGFloat = 28
            static let horisontalInsets: CGFloat = 15
        }
    }
}
