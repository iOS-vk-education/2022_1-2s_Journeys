//
//  TripCell.swift
//  Journeys
//
//  Created by Сергей Адольевич on 03.11.2022.
//

import Foundation
import UIKit


final class TripCell: UICollectionViewCell {
    
    //MARK: Private properties
    
    private struct Constants {
        struct Picture {
            static let horisontalIndent: CGFloat = 16.0
            static let verticalIndent: CGFloat = 46.0
        }
        struct BookmarkIcon {
            static let
        }
        struct DatesLabel {
            
        }
        struct TownsRouteLabel {
            
        }
    }
    
    private let picture = UIImageView()
    private let bookmarkIcon = UIImageView()
    private let datesLabel = UILabel()
    private let townsRouteLabel = UILabel()
    
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
    
    private func setupCell() {
        
    }
    
    private func makeConstraints() {
        picture.
    }
}
