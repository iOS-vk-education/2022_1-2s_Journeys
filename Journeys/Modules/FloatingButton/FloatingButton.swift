//
//  FloatingButton.swift
//  Journeys
//
//  Created by Сергей Адольевич on 10.11.2022.
//

import Foundation
import UIKit

final class FloatingButton: UIButton {
    // MARK: Private Properties

    private enum Constants {
        static let bottomIndent: CGFloat = 8.0

        static let width: CGFloat = 220.0
        static let height: CGFloat = 40.0

        static let borderRadius: CGFloat = 10.0
    }

    // MARK: Lifecycle

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    // MARK: Private Methods

    private func setupViews() {
        backgroundColor = UIColor(asset: Asset.Colors.BaseColors.contrastToThemeColor)
        layer.cornerRadius = Constants.borderRadius
        setTitleColor(UIColor(asset: Asset.Colors.BaseColors.similarToThemeColor), for: .normal)
        titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
    }

    // MARK: Internal Methods

    func configure(title: String) {
        setTitle(title.uppercased(), for: .normal)
    }
}
