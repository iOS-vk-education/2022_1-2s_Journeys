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
        imageView.image = UIImage()
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let pictureEmptyViewForSkeletonLayer = UIView()
    private let pictureLayer = CAGradientLayer()
    
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
    private let datesLayer = CAGradientLayer()
    
    private let routeLabel = UILabel()
    private let routeLayer = CAGradientLayer()
    
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
        pictureLayer.isHidden = false
        routeLayer.isHidden = false
        datesLayer.isHidden = false
        picture.image = nil
        bookmarkButton.setImage(nil, for: .normal)
        datesLabel.text = nil
        routeLabel.text = nil
        
        setAllSubviewsAlphaToZero()
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
        
        bookmarkButton.addTarget(self, action: #selector(didTapBookmarkButton), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(didTapEditButton), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        
        setupColors()
        setupFonts()
        makeConstraints()
        
        makeSkeletonConstraints()
        setupSkeleton()
        
        setAllSubviewsAlphaToZero()
    }
    
    func makeSkeletonConstraints() {
        contentView.addSubview(pictureEmptyViewForSkeletonLayer)
        pictureEmptyViewForSkeletonLayer.snp.makeConstraints { make in
            make.edges.equalTo(picture.snp.edges)
        }
        pictureEmptyViewForSkeletonLayer.layer.addSublayer(pictureLayer)
        pictureLayer.frame = CGRect(x: 0, y: 0, width: 311.0, height: 180.0)
        pictureLayer.cornerRadius = picture.layer.cornerRadius
    }
    
    private func setupSkeleton() {
        pictureLayer.startPoint = CGPoint(x: 0, y: 0.5)
        pictureLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        let pictureGroup = makeAnimationGroup()
        pictureGroup.beginTime = 0.0
        pictureLayer.add(pictureGroup, forKey: "backgroundColor")
    }

    private func setupFonts() {
        datesLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .medium)
        routeLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .medium)
    }

    private func setupColors() {
        backgroundColor = UIColor(asset: Asset.Colors.Background.brightColor)
        datesLabel.textColor = UIColor(asset: Asset.Colors.Text.mainTextColor)
        routeLabel.textColor = UIColor(asset: Asset.Colors.Text.mainTextColor)
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
        contentView.addSubview(picture)
        contentView.addSubview(bookmarkButton)
        contentView.addSubview(editButton)
        contentView.addSubview(deleteButton)
        contentView.addSubview(datesLabel)
        contentView.addSubview(routeLabel)
        
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

        routeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(TripCellConstants.TownsRouteLabel.horisontalIndent)
            make.trailing.equalToSuperview().inset(TripCellConstants.TownsRouteLabel.horisontalIndent)
            make.bottom.equalToSuperview().inset(TripCellConstants.TownsRouteLabel.bottomIndent)
        }
    }
    
    private func setAllSubviewsAlphaToZero() {
        picture.alpha = 0
        bookmarkButton.alpha = 0
        deleteButton.alpha = 0
        editButton.alpha = 0
        editButton.alpha = 0
        datesLabel.alpha = 0
        routeLabel.alpha = 0
    }
    
    private func setSubviewsAlphaToOne() {
        bookmarkButton.alpha = 1
        deleteButton.alpha = 1
        editButton.alpha = 1
        editButton.alpha = 1
        datesLabel.alpha = 1
        routeLabel.alpha = 1
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
        if let image = data.picture {
            setupImage(image)
        }
        
        datesLabel.text = data.dates
        routeLabel.text = data.route
        isInFavourites = data.isInFavourites
        setBookmarkButtonImage()
        
        datesLayer.isHidden = true
        routeLayer.isHidden = true
        
        UIView.animate(
            withDuration: 0.5,
            animations: { [weak self] in
                self?.setSubviewsAlphaToOne()
            })
        
        self.indexPath = indexPath
        self.delegate = delegate
    }
    
    func setupImage(_ image: UIImage) {
        self.pictureLayer.isHidden = true
        self.picture.image = image
        UIView.animate(
            withDuration: 0.5,
            animations: { [weak self] in
                self?.picture.alpha = 1
            })
    }
}

extension TripCell: SkeletonLoadable {
}

private extension TripCell {

    enum TripCellConstants {
        static let horisontalIndentForAllSubviews: CGFloat = 16.0
        enum Picture {
            static let horisontalIndent: CGFloat = horisontalIndentForAllSubviews
            static let verticalIndent: CGFloat = 46.0

            static let cornerRadius: CGFloat = 15.0
        }
        enum DatesLabel {
            static let leadingIndent: CGFloat = 12
            static let topIndent: CGFloat = 13.0

            static let minIndentFromBookmarkIcon: CGFloat = 16
        }
        enum BookmarkButton {
            static let trailingIndent: CGFloat = horisontalIndentForAllSubviews
            static let topIndent: CGFloat = DatesLabel.topIndent

            static let width: CGFloat = 23.0
            static let height: CGFloat = 23.0
        }
        enum TownsRouteLabel {
            static let horisontalIndent: CGFloat = horisontalIndentForAllSubviews
            static let bottomIndent: CGFloat = 17.0
        }
        enum Cell {
            static let borderRadius: CGFloat = 10.0
        }
    }
}

protocol TripCellDelegate: AnyObject {
    func didTapBookmarkButton(_ indexPath: IndexPath)
    func didTapEditButton(_ indexPath: IndexPath)
    func didTapDeleteButton(_ indexPath: IndexPath)
}
