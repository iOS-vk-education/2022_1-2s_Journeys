//
//  NoWeatherDataCell.swift
//  Journeys
//
//  Created by Анастасия Ищенко on 03.11.2022.
//

import Foundation
import UIKit
import SnapKit


final class NoWeatherDataCell: UICollectionViewCell {

    // MARK: Private properties

    private let text: UILabel = {
        let label = UILabel()
        label.text = "Погоды для этого города нет :("
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
        return label
    }()

    // MARK: Lifecycle

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.isUserInteractionEnabled = true
        setupSubviews()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        text.text = nil

        setupSubviews()
    }

    // MARK: Private functions

    private func setupSubviews() {
        contentView.addSubview(text)
        makeConstraints()
    }

    private func makeConstraints() {
        text.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
            make.width.equalToSuperview().offset(-40)
        }
    }
}

