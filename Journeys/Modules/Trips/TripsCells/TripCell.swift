//
//  TripCell.swift
//  Journeys
//
//  Created by Анастасия Ищенко on 03.11.2022.
//

import Foundation
import UIKit
import SnapKit

final class TripCell: UICollectionViewCell {
    
    struct DisplayData {
        let picture: UIImage?
        let dates: String?
        let route: String
        let isInFavourites: Bool
    }

    // MARK: Private properties
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
    private let editButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    private let datesLabel = UILabel()
    private let townsRouteLabel = UILabel()
    private var isInFavourites = Bool()
    private var delegate: TripCellDelegate!
    
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
        contentView.addSubview(editButton)
        contentView.addSubview(deleteButton)
        contentView.addSubview(datesLabel)
        contentView.addSubview(townsRouteLabel)

        bookmarkButton.addTarget(self, action: #selector(didTapBookmarkButton), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(didTapEditButton), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        setupColors()
        setupFonts()
        makeConstraints()
    }

    private func setupFonts() {
        datesLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .medium)
        townsRouteLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .medium)
    }

    private func setupColors() {
        backgroundColor = UIColor(asset: Asset.Colors.Background.brightColor)
        datesLabel.textColor = UIColor(asset: Asset.Colors.Text.mainTextColor)
        townsRouteLabel.textColor = UIColor(asset: Asset.Colors.Text.mainTextColor)
        bookmarkButton.tintColor = UIColor(asset: Asset.Colors.Icons.iconsColor)
        editButton.tintColor = UIColor(asset: Asset.Colors.Icons.iconsColor)
        deleteButton.tintColor = UIColor(asset: Asset.Colors.Icons.iconsColor)
    }

    private func setBookmarkButtonImage() {
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

        bookmarkButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(TripCellConstants.BookmarkButton.trailingIndent)
            make.top.equalToSuperview().inset(TripCellConstants.BookmarkButton.topIndent)
            make.width.equalTo(TripCellConstants.BookmarkButton.width)
            make.height.equalTo(TripCellConstants.BookmarkButton.height)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(TripCellConstants.BookmarkButton.trailingIndent)
            make.top.equalToSuperview().inset(TripCellConstants.BookmarkButton.topIndent)
            make.width.equalTo(TripCellConstants.BookmarkButton.width)
            make.height.equalTo(TripCellConstants.BookmarkButton.height)
        }
        
        editButton.snp.makeConstraints { make in
            make.trailing.equalTo(deleteButton.snp.leading).offset(-12)
            make.top.equalToSuperview().inset(TripCellConstants.BookmarkButton.topIndent)
            make.width.equalTo(TripCellConstants.BookmarkButton.width)
            make.height.equalTo(TripCellConstants.BookmarkButton.height)
        }
        
        datesLabel.snp.makeConstraints { make in
            make.leading.equalTo(bookmarkButton.snp.trailing).offset(TripCellConstants.DatesLabel.leadingIndent)
            make.trailing.lessThanOrEqualToSuperview().inset(TripCellConstants.DatesLabel.minIndentFromBookmarkIcon)
            make.top.equalToSuperview().inset(TripCellConstants.DatesLabel.topIndent)
        }

        townsRouteLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(TripCellConstants.TownsRouteLabel.horisontalIndent)
            make.trailing.equalToSuperview().inset(TripCellConstants.TownsRouteLabel.horisontalIndent)
            make.bottom.equalToSuperview().inset(TripCellConstants.TownsRouteLabel.bottomIndent)
        }
    }

    func changeIsSavedStatus(status: Bool) {
        isInFavourites = status
        setBookmarkButtonImage()
    }
    // TODO: send data to view
    @objc
    private func didTapBookmarkButton() {
        guard let indexPath = indexPath else { return }
        delegate.didTapBookmarkButton(indexPath)
    }

    @objc
    private func didTapEditButton() {
        guard let indexPath = indexPath else { return }
        delegate.didTapEditButton(indexPath)
    }
    
    @objc
    private func didTapDeleteButton() {
        guard let indexPath = indexPath else { return }
        delegate.didTapDeleteButton(indexPath)
    }
    
    func configure(data: DisplayData, delegate: TripCellDelegate, indexPath: IndexPath) {
        picture.image = data.picture ?? UIImage()
        datesLabel.text = data.dates
        townsRouteLabel.text = data.route
        isInFavourites = data.isInFavourites
        setBookmarkButtonImage()
        
        self.indexPath = indexPath
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

protocol TripCellDelegate: AnyObject {
    func didTapBookmarkButton(_ indexPath: IndexPath)
    func didTapEditButton(_ indexPath: IndexPath)
    func didTapDeleteButton(_ indexPath: IndexPath)
}
