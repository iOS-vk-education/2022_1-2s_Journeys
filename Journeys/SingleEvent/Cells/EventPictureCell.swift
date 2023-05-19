//
//  EventPictureCell.swift
//  Journeys
//
//  Created by Ангелина Решетникова on 16.05.2023.
//

import Foundation
import UIKit
import SnapKit

final class EventPictureCell: UICollectionViewCell {
    
    struct DisplayData {
        let picture: UIImage?
    }

    // MARK: Private properties
    private let picture: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = TripCellConstants.Picture.cornerRadius
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private var indexPath: IndexPath?

    // MARK: Lifecycle

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
        setupSubviews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        setupSubviews()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        picture.image = nil

        setupSubviews()
    }

    // MARK: Private functions

    private func setupCell() {
       layer.cornerRadius = 20
       layer.masksToBounds = false

       layer.shadowRadius = 3.0
       layer.shadowColor = UIColor.black.cgColor
       layer.shadowOpacity = 0.1
       layer.shadowOffset = CGSize(width: 0, height: 2)
   }

    private func setupSubviews() {
        contentView.addSubview(picture)
        setupColors()
        makeConstraints()
    }

    private func setupColors() {
        backgroundColor = UIColor(asset: Asset.Colors.Background.brightColor)
    }

    private func makeConstraints() {
        picture.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(TripCellConstants.Picture.horisontalIndent)
            make.trailing.equalToSuperview().inset(TripCellConstants.Picture.horisontalIndent)
            make.top.equalToSuperview().inset(TripCellConstants.Picture.verticalIndent)
            make.bottom.equalToSuperview().inset(TripCellConstants.Picture.verticalIndent)
        }
    }
    // TODO: send data to view
    
    func configure(image: UIImage) {
        picture.image = image ?? UIImage()
    }
}

private extension EventPictureCell {

    struct TripCellConstants {
        static let horisontalIndentForAllSubviews: CGFloat = 16.0
        struct Picture {
            static let horisontalIndent: CGFloat = horisontalIndentForAllSubviews
            static let verticalIndent: CGFloat = 10

            static let cornerRadius: CGFloat = 15.0
        }
        struct DatesLabel {
            static let leadingIndent: CGFloat = 12
            static let topIndent: CGFloat = 13.0

            static let minIndentFromBookmarkIcon: CGFloat = 16
        }
        struct BookmarkButton {
            static let trailingIndent: CGFloat = horisontalIndentForAllSubviews
            static let topIndent: CGFloat = DatesLabel.topIndent

            static let width: CGFloat = 23.0
            static let height: CGFloat = 23.0
        }
        struct TownsRouteLabel {
            static let horisontalIndent: CGFloat = horisontalIndentForAllSubviews
            static let bottomIndent: CGFloat = 17.0
        }
        struct Cell {
            static let borderRadius: CGFloat = 10.0
        }
    }
}

