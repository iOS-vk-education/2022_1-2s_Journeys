//
//  TripsPlaceholder.swift
//  Journeys
//
//  Created by Сергей Адольевич on 27.12.2022.
//

import Foundation
import UIKit
import SnapKit

// MARK: - TripsPlaceholderViewController

final class PlaceHolderViewController: UIViewController {
    // MARK: Private properties

    private let titleLabel = UILabel()
    private let image = UIImageView(frame: .zero)

    // MARK: - Constants

    private enum Constants {
        static let titleLabelTopOffset: CGFloat = 60
        static let subtitleLabelTopOffset: CGFloat = 22
        static let labelsHeight: CGFloat = 20

        enum FontSizes {
            static let titleLabelFontSize: CGFloat = 17
            static let subtitleLabelFontSize: CGFloat = 15
        }

        enum Image {
            static let topOffset: CGFloat = 110
            static let width: CGFloat = 172
            static let height: CGFloat = 172
        }
    }

    // MARK: Internal Data Struct

    struct DisplayData {
        let title: String
        let imageName: String
    }

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = UIColor(asset: Asset.Colors.Background.dimColor)
        setupImage()
        setupTitleLabel()
    }

    // MARK: Internal Methods

    func configure(with displayData: DisplayData) {
        titleLabel.text = displayData.title
        image.image = UIImage(named: displayData.imageName)
    }

    // MARK: Private Methods

    private func setupTitleLabel() {
        titleLabel.font = UIFont.boldSystemFont(ofSize: Constants.FontSizes.titleLabelFontSize)
        titleLabel.textColor = UIColor(asset: Asset.Colors.Trips.tripsPlaceholder)
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(Constants.labelsHeight)
        }
    }

    private func setupImage() {
        view.addSubview(image)
        image.contentMode = .scaleAspectFit
        image.tintColor = UIColor(asset: Asset.Colors.Trips.tripsPlaceholder)
        image.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(UIScreen.main.bounds.height / 3)
            make.centerX.equalToSuperview()
            make.width.equalTo(Constants.Image.width)
            make.height.equalTo(Constants.Image.height)
        }
    }
}
