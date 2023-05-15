//
//  suggestion.swift
//  YMKtry
//
//  Created by User on 20.12.2022.
//

import Foundation
import UIKit
import SnapKit

struct PlacemarkCellDisplayData {
    let placeholder: String
}

final class PlacemarkCell: UICollectionViewCell {
    
    private let inputField: UITextField = {
        let inpField = UITextField()
        return inpField
    }()
    
    private var isInFavourites = Bool()
    private var delegate: PlacemarkCellDelegate!

    
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
        inputField.placeholder = nil
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
        inputField.addTarget(self, action: #selector(editingBegan(_:)), for: .editingDidBegin)
    }
    
    
    private func setupColors() {
        backgroundColor = UIColor(asset: Asset.Colors.Background.brightColor)
        inputField.textColor = UIColor(asset: Asset.Colors.Text.mainTextColor)
    }
    
    private func makeConstraints() {
        inputField.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(PlacemarkCellConstants.InputField.horisontalIndent)
            make.trailing.equalToSuperview().inset(PlacemarkCellConstants.InputField.horisontalIndent)
            make.top.equalToSuperview().inset(PlacemarkCellConstants.InputField.verticalIndent)
            make.bottom.equalToSuperview().inset(PlacemarkCellConstants.InputField.verticalIndent)
            
        }
        
    }
    
    @objc func editingBegan(_ searchBar: UITextField) {
        if isInFavourites == true {
            
        }
    }
        
        func configure(data: PlacemarkCellDisplayData, delegate: PlacemarkCellDelegate) {
            inputField.placeholder = data.placeholder
            self.delegate = delegate
        }
    
    func returnText() -> String {
        return inputField.text!
    }
}
    
    private extension PlacemarkCell {
        
        struct PlacemarkCellConstants {
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

protocol PlacemarkCellDelegate: AnyObject {
    func editingBegan()
}
