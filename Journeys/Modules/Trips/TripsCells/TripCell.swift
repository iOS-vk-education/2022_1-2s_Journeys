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
    
    private let picture: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = TripCellConstants.Picture.cornerRadius
        imageView.clipsToBounds = true
        return imageView
    }()
    private let bookmarkButton: UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    private let datesLabel = UILabel()
    private let townsRouteLabel = UILabel()
    private var isInFavourites = Bool()
    private var delegate: TripCellDelegate!

    
    //MARK: Lifecycle
    
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
        bookmarkButton.setImage(nil, for: .normal)
        datesLabel.text = nil
        townsRouteLabel.text = nil
        
        setupSubviews()
    }
    
    // MARK: Private functions
    
    private func setupCell() {
       layer.cornerRadius = TripCellConstants.Cell.borderRadius
       layer.masksToBounds = false

       layer.shadowRadius = 3.0
       layer.shadowColor = UIColor.black.cgColor
       layer.shadowOpacity = 0.1
       layer.shadowOffset = CGSize(width: 0, height: 2)
   }
    
    private func setupSubviews() {
        contentView.addSubview(picture)
        contentView.addSubview(bookmarkButton)
        contentView.addSubview(datesLabel)
        contentView.addSubview(townsRouteLabel)
        
        setupColors()
        setupFonts()
        makeConstraints()
        bookmarkButtonImageSetter()
        bookmarkButton.addTarget(self, action: #selector(didTapBookmarkButton), for: .touchUpInside)
    }

    private func setupFonts() {
        datesLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .medium)
        townsRouteLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .medium)
    }
    
    private func setupColors() {
        backgroundColor = JourneysColors.Dynamic.Background.lightColor
        datesLabel.textColor = JourneysColors.Dynamic.Text.mainTextColor
        townsRouteLabel.textColor = JourneysColors.Dynamic.Text.mainTextColor
        bookmarkButton.tintColor = JourneysColors.Dynamic.Icons.iconsColor
    }
    
    private func bookmarkButtonImageSetter() {
        if isInFavourites {
            bookmarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        } else {
            bookmarkButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
    }
    
    private func makeConstraints() {
        picture.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(TripCellConstants.Picture.horisontalIndent)
            make.trailing.equalToSuperview().inset(TripCellConstants.Picture.horisontalIndent)
            make.top.equalToSuperview().inset(TripCellConstants.Picture.verticalIndent)
            make.bottom.equalToSuperview().inset(TripCellConstants.Picture.verticalIndent)
        }
        
        datesLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(TripCellConstants.DatesLabel.leadingIndent)
            make.trailing.lessThanOrEqualTo(bookmarkButton.snp.leading).offset(-TripCellConstants.DatesLabel.minIndentFromBookmarkIcon)
            make.top.equalToSuperview().inset(TripCellConstants.DatesLabel.topIndent)
        }
        
        bookmarkButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(TripCellConstants.BookmarkButton.trailingIndent)
            make.top.equalToSuperview().inset(TripCellConstants.BookmarkButton.topIndent)
            make.width.equalTo(TripCellConstants.BookmarkButton.width)
            make.height.equalTo(TripCellConstants.BookmarkButton.height)
        }
        
        townsRouteLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(TripCellConstants.TownsRouteLabel.horisontalIndent)
            make.trailing.equalToSuperview().inset(TripCellConstants.TownsRouteLabel.horisontalIndent)
            make.bottom.equalToSuperview().inset(TripCellConstants.TownsRouteLabel.bottomIndent)
        }
    }
    
    //TODO: send data to view
    @objc
    private func didTapBookmarkButton() {
        isInFavourites.toggle()
        bookmarkButtonImageSetter()
    }
    
    func configure(data: TripCellDisplayData, delegate: TripCellDelegate) {
        picture.image = data.picture ?? UIImage(named: "")
        datesLabel.text = data.dates
        townsRouteLabel.text = data.route
        isInFavourites = data.isInFavourites
        self.delegate = delegate
    }
}

private extension TripCell {
    
    struct TripCellConstants {
        static let horisontalIndentForAllSubviews: CGFloat = 16.0
        struct Picture {
            static let horisontalIndent: CGFloat = horisontalIndentForAllSubviews
            static let verticalIndent: CGFloat = 46.0
            
            static let cornerRadius: CGFloat = 15.0
        }
        struct DatesLabel {
            static let leadingIndent: CGFloat = horisontalIndentForAllSubviews
            static let topIndent: CGFloat = 13.0
            
            static let minIndentFromBookmarkIcon: CGFloat = 16
        }
        struct BookmarkButton {
            static let trailingIndent: CGFloat = horisontalIndentForAllSubviews
            static let topIndent: CGFloat = DatesLabel.topIndent
            
            static let width: CGFloat = 14.0
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

protocol TripCellDelegate: AnyObject {
    func didTapBookmarkButton()
}
