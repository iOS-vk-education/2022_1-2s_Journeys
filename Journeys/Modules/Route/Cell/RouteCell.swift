//
//  RouteCell.swift
//  Journeys
//
//  Created by Сергей Адольевич on 21.11.2022.
//

import Foundation
import UIKit

final class RouteCell: UITableViewCell {
    
    struct DisplayData {
        let icon: UIImage
        let color: UIColor
        let text: String?
    }
    
    enum CellType {
        case departureTown(location: Location?)
        case arrivalTown(location: Location?)
        case newLocation
    }
    
    private var locationLabel = UILabel()
    private let icon = UIImageView()
    
    required init?(coder: NSCoder) {
        super.init(coder: NSCoder())
        setupSubiews()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubiews()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        locationLabel.text = nil
        icon.image = nil
        setupSubiews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 16, left: 10, bottom: 0, right: 10))
    }

    private func setupSubiews() {
        contentView.addSubview(locationLabel)
        contentView.addSubview(icon)
        
        backgroundColor = UIColor(asset: Asset.Colors.Background.brightColor)
        
        icon.contentMode = .scaleAspectFit
        makeConstraints()
    }
    
    private func makeConstraints() {
        locationLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(8)
            make.leading.equalTo(icon.snp.trailing).offset(11)
            make.trailing.lessThanOrEqualToSuperview().inset(20)
        }
        
        icon.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.bottom.equalTo(locationLabel.snp.bottom)
            make.height.equalTo(20)
            make.width.equalTo(20)
        }
    }
    
    func configure(displayData: DisplayData) {
        if let text = displayData.text {
            locationLabel.text = text
        }
        
        locationLabel.textColor = displayData.color
        icon.image = displayData.icon
        icon.tintColor = displayData.color
    }
}
