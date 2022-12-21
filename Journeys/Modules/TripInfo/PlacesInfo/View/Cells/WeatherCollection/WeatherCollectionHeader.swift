//
//  WeatherCollectionHeader.swift
//  Journeys
//
//  Created by Сергей Адольевич on 14.12.2022.
//

import Foundation
import UIKit
import SnapKit

final class WeatherCollectionHeader: UICollectionReusableView {
    private let title = UILabel()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    private func setupView() {
        addSubview(title)
        title.textAlignment = .center
        title.font = .systemFont(ofSize: 17, weight: .medium)
        setupConstraints()
    }
    
    private func setupConstraints() {
        title.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
    func configure(title: String) {
        self.title.text = title
    }

}
