//
//  WeatherCell.swift
//  Journeys
//
//  Created by Анастасия Ищенко on 03.11.2022.
//

import Foundation
import UIKit
import SnapKit


final class WeatherCell: UICollectionViewCell {
    
    struct DisplayData {
        let icon: UIImage
        let iconColor: UIColor
        let date: String
        let temperature: String
    }

    // MARK: Private properties

    private let icon = UIImageView()
    private let dateLabel = UILabel()
    private let temperatureLabel = UILabel()

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
        icon.image = nil
        dateLabel.text = nil
        temperatureLabel.text = nil

        setupSubviews()
    }

    // MARK: Private functions

    private func setupSubviews() {
        contentView.addSubview(icon)
        contentView.addSubview(dateLabel)
        contentView.addSubview(temperatureLabel)

        setupColors()
        setupFonts()
        makeConstraints()
    }

    private func setupFonts() {
        dateLabel.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
        temperatureLabel.font = UIFont.systemFont(ofSize: 24.0, weight: .medium)
    }

    private func setupColors() {
        dateLabel.textColor = UIColor(asset: Asset.Colors.PlacesInfo.WeatherCell.dateColor)
        temperatureLabel.textColor = UIColor(asset: Asset.Colors.Text.mainTextColor)
    }

    private func makeConstraints() {
        dateLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        temperatureLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.width.lessThanOrEqualTo(100)
            make.top.equalTo(dateLabel.snp.bottom).offset(Constants.TemtperatureLabel.verticatSpacingFromDateLabel)
            make.bottom.equalToSuperview()
        }
        
        temperatureLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        icon.snp.makeConstraints { make in
            make.leading.equalTo(temperatureLabel.snp.trailing).offset(2)
            make.trailing.equalToSuperview()
            make.centerY.equalTo(temperatureLabel.snp.centerY)
            make.height.equalTo(Constants.Icon.height)
            make.width.equalTo(Constants.Icon.width)
        }
    }

    func configure(data: DisplayData) {
        icon.image = data.icon
        icon.tintColor = data.iconColor
        dateLabel.text = data.date
        temperatureLabel.text = data.temperature
    }
    
}

private extension WeatherCell {

    enum Constants {
        static let horisontalIndentForAllSubviews: CGFloat = 16.0
        enum Icon {
            static let horisontalIndent: CGFloat = horisontalIndentForAllSubviews
            static let verticalIndent: CGFloat = 46.0

            static let height: CGFloat = 21
            static let width: CGFloat = 21
        }
        enum DateLabel {
            static let leadingIndent: CGFloat = horisontalIndentForAllSubviews
            static let topIndent: CGFloat = 13.0

            static let minIndentFromBookmarkIcon: CGFloat = 16
        }
        enum TemtperatureLabel {
            static let verticatSpacingFromDateLabel: CGFloat = 5
        }
    }
}

