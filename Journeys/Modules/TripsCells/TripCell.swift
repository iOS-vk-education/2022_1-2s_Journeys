//
//  TripCell.swift
//  Journeys
//
//  Created by Анастасия Ищенко on 03.11.2022.
//

import Foundation
import UIKit
import SnapKit


struct TripCellDisplayData {
    let picture: UIImage?
    let dates: String
    let route: String
    let isInFavourites: Bool
}

final class TripCell: UICollectionViewCell {
    
    //MARK: Private properties
    
    private let picture = UIImageView()
    private let bookmarkIcon = UIImageView()
    private let datesLabel = UILabel()
    private let townsRouteLabel = UILabel()
    private var isInFavourites: Bool? = nil

    
    //MARK: Lifecycle
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        picture.image = nil
        bookmarkIcon.image = nil
        datesLabel.text = nil
        townsRouteLabel.text = nil
    }

    override func systemLayoutSizeFitting(
        _ targetSize: CGSize,
        withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
        verticalFittingPriority: UILayoutPriority
    ) -> CGSize {
        var targetSize = targetSize
        targetSize.height = CGFloat.greatestFiniteMagnitude
        let size = super.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        return size
    }
    
    // MARK: Private properties
    
    private func setupCell() {
       layer.cornerRadius = Constants.Cell.borderRadius
       layer.masksToBounds = false

       layer.shadowRadius = 3.0
       layer.shadowColor = UIColor.black.cgColor
       layer.shadowOpacity = 0.1
       layer.shadowOffset = CGSize(width: 0, height: 2)
   }
    
    private func setupSubiews() {
        contentView.addSubview(picture)
        contentView.addSubview(bookmarkIcon)
        contentView.addSubview(datesLabel)
        contentView.addSubview(townsRouteLabel)
        
        setupColors()
        setupFonts()
        bookmarkIcon.image = bookmarkIconImage()
        makeConstraints()
    }

    private func setupFonts() {
        datesLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .medium)
        townsRouteLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .medium)
    }
    
    private func setupColors() {
        backgroundColor = JourneysColors.Dynamic.Background.lightColor
        datesLabel.textColor = JourneysColors.Dynamic.Text.mainTextColor
        townsRouteLabel.textColor = JourneysColors.Dynamic.Text.mainTextColor
        bookmarkIcon.tintColor = JourneysColors.Dynamic.Icons.iconsColor
    }
    
    private func bookmarkIconImage() -> UIImage {
        guard let isInFavouritesUnwrapped = isInFavourites else {
            return UIImage()
        }
        if isInFavouritesUnwrapped {
            return UIImage(systemName: "bookmark.fill") ?? UIImage()
        } else {
            return UIImage(systemName: "bookmark") ?? UIImage()
        }
    }
    
    private func makeConstraints() {
        picture.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(Constants.Picture.horisontalIndent)
            make.trailing.equalToSuperview().inset(Constants.Picture.horisontalIndent)
            make.top.equalToSuperview().inset(Constants.Picture.verticalIndent)
            make.bottom.equalToSuperview().inset(Constants.Picture.verticalIndent)
        }
        
        datesLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(Constants.DatesLabel.leadingIndent)
            make.trailing.lessThanOrEqualTo(bookmarkIcon.snp.leading).offset(-Constants.DatesLabel.minIndentFromBookmarkIcon)
            make.top.equalToSuperview().inset(Constants.DatesLabel.topIndent)
        }
        
        bookmarkIcon.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(Constants.BookmarkIcon.trailingIndent)
            make.top.equalToSuperview().inset(Constants.BookmarkIcon.topIndent)
            make.width.equalTo(Constants.BookmarkIcon.wigth)
            make.height.equalTo(Constants.BookmarkIcon.height)
        }
        
        townsRouteLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(Constants.TownsRouteLabel.horisontalIndent)
            make.trailing.equalToSuperview().inset(Constants.TownsRouteLabel.horisontalIndent)
            make.bottom.equalToSuperview().inset(Constants.TownsRouteLabel.bottomIndent)
        }
    }
    
    func configure(data: TripCellDisplayData) {
        picture.image = data.picture ?? UIImage(named: "")
        datesLabel.text = data.dates
        townsRouteLabel.text = data.route
        isInFavourites = data.isInFavourites
        setupSubiews()
    }
}

private extension TripCell {
    struct Constants {
        static let horisontalIndentForAllSubviews: CGFloat = 16.0
        struct Picture {
            static let horisontalIndent: CGFloat = horisontalIndent
            static let verticalIndent: CGFloat = 46.0
        }
        struct DatesLabel {
            static let leadingIndent: CGFloat = horisontalIndentForAllSubviews
            static let topIndent: CGFloat = 13.0
            
            static let minIndentFromBookmarkIcon: CGFloat = 16
        }
        struct BookmarkIcon {
            static let trailingIndent: CGFloat = horisontalIndentForAllSubviews
            static let topIndent: CGFloat = DatesLabel.topIndent
            
            static let wigth: CGFloat = 12.0
            static let height: CGFloat = 20.0
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
