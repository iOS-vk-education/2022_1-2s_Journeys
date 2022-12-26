//
//  WeatherPlaceNoDataPlaceholder.swift
//  Journeys
//
//  Created by Сергей Адольевич on 26.12.2022.
//

import Foundation
import UIKit


final class WeatherPlaceNoDataPlaceholder: UIViewController {
    // MARK: Private properties

    private let titleLabel = UILabel()

    // MARK: - Constants

    private enum Constants {
        static let titleLabelTopOffset: CGFloat = 60
        static let subtitleLabelTopOffset: CGFloat = 22
        static let labelsHeight: CGFloat = 20

        enum FontSizes {
            static let titleLabelFontSize: CGFloat = 17
            static let subtitleLabelFontSize: CGFloat = 15
        }
    }

    // MARK: Internal Data Struct

    struct DisplayData {
        let title: String
    }

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(asset: Asset.Colors.Background.brightColor)
        setupTitleLabel()
    }

    // MARK: Internal Methods

    func configure(with displayData: DisplayData) {
        titleLabel.text = displayData.title
    }

    // MARK: Private Methods

    private func setupTitleLabel() {
        titleLabel.font = UIFont.boldSystemFont(ofSize: Constants.FontSizes.titleLabelFontSize)
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.titleLabelTopOffset)
            make.centerX.equalToSuperview()
            make.height.equalTo(Constants.labelsHeight)
        }
    }
}
