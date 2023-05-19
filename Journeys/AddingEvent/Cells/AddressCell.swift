//
//  suggestion.swift
//  YMKtry
//
//  Created by User on 20.12.2022.
//

import Foundation
import UIKit
import SnapKit

struct AddressCellDisplayData {
    let text : String
}

final class AddressCell: UICollectionViewCell {
    
    private let inputField: UILabel = {
        let inpField = UILabel()
        inpField.font = .boldSystemFont(ofSize: 17)
        return inpField
    }()
    
    
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
        inputField.text = nil
        setupSubviews()
    }
    
    // MARK: Private functions
    
    private func setupCell() {
        layer.cornerRadius = 10
        layer.masksToBounds = false
        
        layer.shadowRadius = 3.0
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    private func setupSubviews() {
        contentView.addSubview(inputField)
        setupColors()
        makeConstraints()
    }
    
    private func setupColors() {
        backgroundColor = UIColor(asset: Asset.Colors.Background.brightColor)
        inputField.textColor = UIColor(asset: Asset.Colors.Text.mainTextColor)
    }
    
    private func makeConstraints() {
        inputField.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(AddressCellConstants.InputField.horisontalIndent)
            make.trailing.equalToSuperview().inset(AddressCellConstants.InputField.horisontalIndent)
            make.top.equalToSuperview().inset(AddressCellConstants.InputField.verticalIndent)
            make.bottom.equalToSuperview().inset(AddressCellConstants.InputField.verticalIndent)
            
        }
    }
        
        
    func configure(data: AddressCellDisplayData, cornerRadius: CGFloat) {
            inputField.text = data.text
        layer.cornerRadius = cornerRadius
        }
}
    
    private extension AddressCell {
        
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


