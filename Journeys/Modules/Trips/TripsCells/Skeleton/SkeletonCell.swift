//
//  SkeletonCell.swift
//  Journeys
//
//  Created by Сергей Адольевич on 08.03.2023.
//

import Foundation
import UIKit
import SnapKit

class SkeletonTripCell: UICollectionViewCell {

    private let datesLabel: UILabel = {
        let label = UILabel()
        label.text = "22.22.2222 - 22.22.2222"
        return label
    }()
    private let datesLayer = CAGradientLayer()

    private let routeLabel: UILabel = {
        let label = UILabel()
        label.text = "A"
        return label
    }()
    private let routeLayer = CAGradientLayer()
    
    private let picture: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = TripCellConstants.Picture.cornerRadius
        imageView.clipsToBounds = true
        return imageView
    }()
    private let pictureLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        setup()
        layout()
        backgroundColor = UIColor(asset: Asset.Colors.Background.brightColor)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setup()
        layout()
    }
    
    private func setupCell() {
       layer.cornerRadius = TripCellConstants.Cell.borderRadius
       layer.masksToBounds = false

       layer.shadowRadius = 3.0
       layer.shadowColor = UIColor.black.cgColor
       layer.shadowOpacity = 0.1
       layer.shadowOffset = CGSize(width: 0, height: 2)
   }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        datesLayer.frame = datesLabel.bounds
        datesLayer.cornerRadius = datesLabel.bounds.height / 2
        
        pictureLayer.frame = picture.bounds
        pictureLayer.cornerRadius = picture.layer.cornerRadius
        
        routeLayer.frame = routeLabel.bounds
        routeLayer.cornerRadius = routeLabel.bounds.height / 2
    }

    func setup() {
        datesLayer.startPoint = CGPoint(x: 0, y: 0.5)
        datesLayer.endPoint = CGPoint(x: 1, y: 0.5)
        datesLabel.layer.addSublayer(datesLayer)
        
        pictureLayer.startPoint = CGPoint(x: 0, y: 0.5)
        pictureLayer.endPoint = CGPoint(x: 1, y: 0.5)
        picture.layer.addSublayer(pictureLayer)

        routeLayer.startPoint = CGPoint(x: 0, y: 0.5)
        routeLayer.endPoint = CGPoint(x: 1, y: 0.5)
        routeLabel.layer.addSublayer(routeLayer)

        let datesGroup = makeAnimationGroup()
        datesGroup.beginTime = 0.0
        datesLayer.add(datesGroup, forKey: "backgroundColor")
        
        let pictureGroup = makeAnimationGroup(previousGroup: datesGroup)
        pictureLayer.add(pictureGroup, forKey: "backgroundColor")
        
        let routeGroup = makeAnimationGroup(previousGroup: pictureGroup)
        routeLayer.add(routeGroup, forKey: "backgroundColor")
    }
    
    func layout() {
        addSubview(datesLabel)
        addSubview(picture)
        addSubview(routeLabel)
        
        datesLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(TripCellConstants.DatesLabel.leadingIndent
                                                   + TripCellConstants.BookmarkButton.width
                                                   + TripCellConstants.BookmarkButton.trailingIndent)
            make.top.equalToSuperview().inset(TripCellConstants.DatesLabel.topIndent)
        }

        picture.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(TripCellConstants.Picture.horisontalIndent)
            make.trailing.equalToSuperview().inset(TripCellConstants.Picture.horisontalIndent)
            make.top.equalToSuperview().inset(TripCellConstants.Picture.verticalIndent)
            make.bottom.equalToSuperview().inset(TripCellConstants.Picture.verticalIndent)
        }
        
        routeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(TripCellConstants.TownsRouteLabel.horisontalIndent)
            make.trailing.equalToSuperview().inset(TripCellConstants.TownsRouteLabel.horisontalIndent)
            make.bottom.equalToSuperview().inset(TripCellConstants.TownsRouteLabel.bottomIndent)
        }
    }
    
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

// inherit
extension SkeletonTripCell: SkeletonLoadable {}
