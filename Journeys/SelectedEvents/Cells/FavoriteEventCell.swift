//
//  EventCell.swift
//  Journeys
//
//  Created by Ангелина Решетникова on 23.05.2023.
//

import Foundation
import UIKit
import SnapKit

final class FavoriteEventCell: UICollectionViewCell {
    struct DisplayData {
        var picture: UIImage?
        let startDate: String
        let endDate: String
        let name: String
        let address: String
        let isInFavourites: Bool
        let cellType: CellType
    }
    
    enum  CellType {
        case favoretes
        case created
    }

    // MARK: Private properties
    private var isInFavourites = Bool()
    private var delegate: FavoriteEventCellDelegate?
    
    private var indexPath: IndexPath?
    
    private let picture: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = EventCellConstants.Picture.cornerRadius
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()

    private let nameField: UILabel = {
        let inpField = UILabel()
        inpField.font = .boldSystemFont(ofSize: EventCellConstants.Labels.nameFont)
        return inpField
    }()

    private let startDate: UILabel = {
        let inpField = UILabel()
        inpField.font = .boldSystemFont(ofSize: EventCellConstants.Labels.nameFont)
        return inpField
    }()
    
    private let datesOfTteEvent: UILabel = {
        let inpField = UILabel()
        inpField.text = L10n.duration
        return inpField
    }()

    private let endDate: UILabel = {
        let inpField = UILabel()
        inpField.font = .boldSystemFont(ofSize: EventCellConstants.Labels.nameFont)
        return inpField
    }()

    private let address: UILabel = {
        let inpField = UILabel()
        inpField.font = .boldSystemFont(ofSize: EventCellConstants.Labels.nameFont)
        return inpField
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
        nameField.text = nil
        endDate.text = nil
        startDate.text = nil
        address.text = nil
        likeButton.setImage(nil, for: .normal)
        editButton.isHidden = true
        deleteButton.isHidden = true
        likeButton.isHidden = true

        setupSubviews()
    }

    // MARK: Private functions

    private func setupCell() {
        layer.cornerRadius = EventCellConstants.Cell.borderRadius
        layer.masksToBounds = false
        
        layer.shadowRadius = 3.0
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
    }

    private func setupSubviews() {
        contentView.addSubview(picture)
        contentView.addSubview(nameField)
        contentView.addSubview(editButton)
        contentView.addSubview(deleteButton)
        contentView.addSubview(startDate)
        contentView.addSubview(endDate)
        contentView.addSubview(likeButton)
        contentView.addSubview(address)
        contentView.addSubview(datesOfTteEvent)

        likeButton.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(didTapEditButton), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        setupColors()
        setupFonts()
        makeConstraints()
    }

    private func setupFonts() {
        nameField.font = .boldSystemFont(ofSize: EventCellConstants.Labels.nameFont)
        startDate.font = .systemFont(ofSize: EventCellConstants.Labels.fontSize)
        endDate.font = .systemFont(ofSize: EventCellConstants.Labels.fontSize)
        address.font = UIFont.systemFont(ofSize: EventCellConstants.Labels.addressFont, weight: .medium)
        datesOfTteEvent.font = .boldSystemFont(ofSize: EventCellConstants.Labels.fontSize)
        
    }

    private func setupColors() {
        backgroundColor = UIColor(asset: Asset.Colors.Background.brightColor)
        startDate.textColor = UIColor(asset: Asset.Colors.Text.addressTextColor)
        endDate.textColor = UIColor(asset: Asset.Colors.Text.addressTextColor)
        datesOfTteEvent.textColor = UIColor(asset: Asset.Colors.Text.addressTextColor)
        address.textColor = UIColor(asset: Asset.Colors.Text.mainTextColor)
        nameField.textColor = UIColor(asset: Asset.Colors.Text.mainTextColor)
        likeButton.tintColor = .systemPink
        editButton.tintColor = UIColor(asset: Asset.Colors.Icons.iconsColor)
        deleteButton.tintColor = UIColor(asset: Asset.Colors.Icons.iconsColor)
    }
    
    private func setLikeButtonImage() {
        if isInFavourites {
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }

    private func makeConstraints() {
        picture.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(EventCellConstants.Picture.horisontalIndent)
            make.trailing.equalToSuperview().inset(EventCellConstants.Picture.trailing)
            make.top.equalToSuperview().inset(EventCellConstants.Picture.verticalIndent)
            make.bottom.equalToSuperview().inset(EventCellConstants.Picture.horisontalIndent)
        }

        likeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(EventCellConstants.BookmarkButton.trailingIndent)
            make.top.equalToSuperview().inset(EventCellConstants.BookmarkButton.topIndent)
            make.width.equalTo(EventCellConstants.BookmarkButton.width)
            make.height.equalTo(EventCellConstants.BookmarkButton.height)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(EventCellConstants.BookmarkButton.trailingIndent)
            make.top.equalToSuperview().inset(EventCellConstants.BookmarkButton.topIndent)
            make.width.equalTo(EventCellConstants.BookmarkButton.width)
            make.height.equalTo(EventCellConstants.BookmarkButton.height)
        }
        
        editButton.snp.makeConstraints { make in
            make.trailing.equalTo(deleteButton.snp.leading).offset(EventCellConstants.EditButton.trailing)
            make.top.equalToSuperview().inset(EventCellConstants.BookmarkButton.topIndent)
            make.width.equalTo(EventCellConstants.BookmarkButton.width)
            make.height.equalTo(EventCellConstants.BookmarkButton.height)
        }
        
        startDate.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(EventCellConstants.Picture.horisontalIndentOfPicture)
            make.trailing.lessThanOrEqualToSuperview().inset(EventCellConstants.Labels.minIndentFromBookmarkIcon)
            make.top.equalToSuperview().inset(EventCellConstants.Dates.startDateTop)
        }
        
        datesOfTteEvent.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(EventCellConstants.Picture.horisontalIndentOfPicture)
            make.trailing.equalToSuperview().inset(EventCellConstants.TownsRouteLabel.horisontalIndent)
            make.top.equalToSuperview().inset(EventCellConstants.Dates.datesTop)
        }

        endDate.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(EventCellConstants.Picture.horisontalIndentOfPicture)
            make.trailing.equalToSuperview().inset(EventCellConstants.TownsRouteLabel.horisontalIndent)
            make.bottom.equalToSuperview().inset(EventCellConstants.Picture.horisontalIndent)
        }
        nameField.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(EventCellConstants.BookmarkButton.topIndent)
            make.leading.equalToSuperview().inset(EventCellConstants.TownsRouteLabel.horisontalIndent)
            make.trailing.equalToSuperview().inset(80)
        }
        address.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(EventCellConstants.Picture.horisontalIndentOfPicture)
            make.trailing.lessThanOrEqualToSuperview().inset(EventCellConstants.Labels.minIndentFromBookmarkIcon)
            make.top.equalToSuperview().inset(EventCellConstants.Picture.verticalIndent+5)
        }
    }
    // TODO: send data to view
    @objc
    private func didTapLikeButton() {
        guard let indexPath = indexPath else { return }
        isInFavourites = !isInFavourites
        setLikeButtonImage()
        delegate?.didTapLikeButton(indexPath)
    }

    @objc
    private func didTapEditButton() {
        guard let indexPath = indexPath else { return }
        delegate?.didTapEditButton(indexPath)
    }
    
    @objc
    private func didTapDeleteButton() {
        guard let indexPath = indexPath else { return }
        delegate?.didTapDeleteButton(indexPath)
    }
    
    func configure(data: DisplayData, delegate: FavoriteEventCellDelegate, indexPath: IndexPath) {
        nameField.text = data.name
        startDate.text = data.startDate
        endDate.text = data.endDate
        address.text = data.address
        isInFavourites = data.isInFavourites
        setLikeButtonImage()
        
        self.indexPath = indexPath
        self.delegate = delegate
        switch data.cellType {
        case .favoretes:
            if let image = data.picture {
                setupImageFav(image)
            }
            editButton.isHidden = true
            deleteButton.isHidden = true
            likeButton.isHidden = false
        case .created:
            if let image = data.picture {
                setupImageCre(image)
            }
            editButton.isHidden = false
            deleteButton.isHidden = false
            likeButton.isHidden = true
        }
    }
    
    func setupImageCre(_ image: UIImage) {
        //self.pictureLayer.isHidden = true
        self.picture.image = image
        UIView.animate(
            withDuration: 0.5,
            animations: { [weak self] in
                self?.picture.alpha = 1
            })
    }
    
    func setupImageFav(_ image: UIImage) {
        //self.pictureLayer.isHidden = true
        self.picture.image = image
        UIView.animate(
            withDuration: 0.5,
            animations: { [weak self] in
                self?.picture.alpha = 1
            })
    }

}

private extension FavoriteEventCell {

    struct EventCellConstants {
        static let horisontalIndentForAllSubviews: CGFloat = 16.0
        struct Picture {
            static let horisontalIndent: CGFloat = horisontalIndentForAllSubviews
            static let verticalIndent: CGFloat = 46.0
            static let trailing: CGFloat = 180
            static let horisontalIndentOfPicture : CGFloat = 176
            static let cornerRadius: CGFloat = 15.0
        }
        struct Labels {
            static let leadingIndent: CGFloat = 12
            static let topIndent: CGFloat = 13.0
            static let nameFont: CGFloat = 20.0
            static let fontSize: CGFloat = 13.0
            static let addressFont: CGFloat = 15
            static let minIndentFromBookmarkIcon: CGFloat = 16
        }
        struct BookmarkButton {
            static let trailingIndent: CGFloat = horisontalIndentForAllSubviews
            static let topIndent: CGFloat = Labels.topIndent
            static let horisontalIndentOfPicture : CGFloat = 202

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
        struct EditButton {
            static let trailing: CGFloat = -12
        }
        struct Dates {
            static let startDateTop: CGFloat = 108
            static let datesTop: CGFloat = 88
        }
    }
}

protocol FavoriteEventCellDelegate: AnyObject {
    func didTapLikeButton(_ indexPath: IndexPath)
    func didTapEditButton(_ indexPath: IndexPath)
    func didTapDeleteButton(_ indexPath: IndexPath)
}
