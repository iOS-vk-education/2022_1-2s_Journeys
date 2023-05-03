//
//  PlacesInfoPlaceholderCell.swift
//  Journeys
//
//  Created by Анастасия Ищенко on 03.11.2022.
//

import Foundation
import UIKit
import SnapKit


final class PlacesInfoPlaceholderCell: UICollectionViewCell {

    // MARK: Private properties

    private let title: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
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
        title.text = nil
    }

    // MARK: Private functions

    private func setupSubviews() {
        contentView.addSubview(title)
        makeConstraints()
    }

    private func makeConstraints() {
        title.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(300)
        }
    }
    
    func configure(text: String) {
        self.title.text = text
    }
}

