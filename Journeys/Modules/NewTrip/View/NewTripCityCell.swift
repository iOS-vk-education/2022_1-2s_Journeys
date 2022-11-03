//
//  NewTripCityCell.swift
//  Journeys
//
//  Created by Pritex007 on 03.11.2022.
//

import UIKit
import SnapKit

final class NewTripCityCell: UITableViewCell {
    
    // MARK: Private constants
    
    private enum Constants {
        enum PictureView {
            static let length: CGFloat = 17
        }
        enum TitleLabel {
            static let fontSize: CGFloat = 17
            static let leadingOffset: CGFloat = 10
        }
        enum Cell {
            static let topBottomIndent: CGFloat = 0
            static let leftRightIndent: CGFloat = 16
        }
    }
    
    // MARK: Display data
    
    struct DisplayData {
        var pictureSystemName: String
        var title: String
        var isTextActive: Bool
    }
    
    static let reuseId = "NewTripCity"
    
    private let pictureView: UIImageView = UIImageView()
    private let titleLabel: UILabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(
            top: Constants.Cell.topBottomIndent,
            left: Constants.Cell.leftRightIndent,
            bottom: Constants.Cell.topBottomIndent,
            right: Constants.Cell.leftRightIndent)
        )
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(displayData: DisplayData) {
        if let picture = UIImage(systemName: displayData.pictureSystemName) {
            pictureView.image = picture
        } else {
            pictureView.image = UIImage(systemName: "circle")
        }
        titleLabel.text = displayData.title
        let color = displayData.isTextActive ? UIColor.label : UIColor.systemGray
        titleLabel.textColor = color
        pictureView.tintColor = color
    }
    
    private func setupViews() {
        [pictureView, titleLabel].forEach(contentView.addSubview(_:))
        
        titleLabel.font = UIFont.systemFont(ofSize: Constants.TitleLabel.fontSize, weight: .regular)
    }
    
    private func setupConstraints() {
        pictureView.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
            make.height.width.equalTo(Constants.PictureView.length)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(pictureView.snp.trailing).offset(Constants.TitleLabel.leadingOffset)
            make.centerY.equalToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
        }
    }
}
