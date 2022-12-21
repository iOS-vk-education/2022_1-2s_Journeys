//
//  EventCell.swift
//  Journeys
//
//  Created by Анастасия Ищенко on 03.11.2022.
//

import Foundation
import UIKit
import SnapKit


final class EventCell: UICollectionViewCell {

    // MARK: Private properties

    private var mapView = UIView()

    // MARK: Lifecycle

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        setupSubviews()
    }
    lazy var width: NSLayoutConstraint = {
        let width = contentView.widthAnchor.constraint(equalToConstant: bounds.size.width)
        width.isActive = true
        return width
    }()
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        width.constant = bounds.size.width
        return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 1))
    }

    // MARK: Private functions

    private func setupSubviews() {
        contentView.addSubview(mapView)
        makeConstraints()
    }

    private func makeConstraints() {
        mapView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    func configure(mapView: UIView) {
        self.mapView = mapView
    }
}

