//
//  DurationCell.swift
//  Journeys
//
//  Created by Ангелина Решетникова on 17.05.2023.
//

import Foundation
import UIKit
import SnapKit

struct DurationCellDisplayData {
    let address : String
    let flat : String
    let floor : String
}

final class DurationCell: UICollectionViewCell {
    
    private let address: UILabel = {
        let inpField = UILabel()
        inpField.font = .boldSystemFont(ofSize: 17)
        return inpField
    }()
    
    private let floorAndFlat: UILabel = {
        let inpField = UILabel()
        inpField.font = .systemFont(ofSize: 15)
        return inpField
    }()
    
    private let mappin: UIImageView = UIImageView()
    
    
    
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
        floorAndFlat.text = nil
        address.text = nil
        setupSubviews()
    }
    
    // MARK: Private functions
    
    private func setupCell() {
        layer.cornerRadius = 20
        layer.masksToBounds = false
        
        layer.shadowRadius = 3.0
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    private func setupSubviews() {
        contentView.addSubview(address)
        contentView.addSubview(floorAndFlat)
        contentView.addSubview(mappin)
        setupImageView()
        setupColors()
        makeConstraints()
    }
    
    private func setupColors() {
        backgroundColor = UIColor(asset: Asset.Colors.Background.brightColor)
        address.textColor = UIColor(asset: Asset.Colors.Text.mainTextColor)
        floorAndFlat.textColor = UIColor(asset: Asset.Colors.Text.addressTextColor)
    }
    
    private func setupImageView() {
        mappin.image = UIImage(systemName: "clock")
        mappin.contentMode = .scaleAspectFill
        mappin.tintColor = UIColor(asset: Asset.Colors.PlacesInfo.WeatherCell.dateColor)
    }
    
    private func makeConstraints() {
        mappin.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(AddressCellConstants.InputField.horisontalIndent)
            make.top.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(24)
        }
        address.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(45)
            make.trailing.equalToSuperview().inset(AddressCellConstants.InputField.horisontalIndent)
            make.top.equalToSuperview().inset(10)
        }
        floorAndFlat.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(45)
            make.trailing.equalToSuperview().inset(AddressCellConstants.InputField.horisontalIndent)
            make.top.equalTo(address).inset(30)
        }
    }
        
        
        func configure(data: PlaceCellDisplayData) {
            address.text = data.address
            floorAndFlat.text = L10n.floor + ": " + data.floor + "  " + L10n.apartmentOffice + ": " + data.flat
            
        }
}
    
    private extension DurationCell {
        
        struct AddressCellConstants {
            static let horisontalIndentForAllSubviews: CGFloat = 16.0
            struct InputField {
                static let horisontalIndent: CGFloat = horisontalIndentForAllSubviews
                static let verticalIndent: CGFloat = 0
                
                static let cornerRadius: CGFloat = 15.0
            }
            struct Cell {
                static let borderRadius: CGFloat = 10.0
            }
        }
    }
