//
//  LinkCell.swift
//  Journeys
//
//  Created by Ангелина Решетникова on 21.05.2023.
//

import Foundation
import UIKit
import SnapKit

struct LinkCellDisplayData {
    let link: String
}

final class LinkCell: UICollectionViewCell {
    
    private let link: UILabel = {
        let inpField = UILabel()
        inpField.font = .systemFont(ofSize: LinkCellConstants.InputField.fontSize)
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        let underlineAttributedString = NSAttributedString(string: "StringWithUnderLine", attributes: underlineAttribute)
        inpField.attributedText = underlineAttributedString
        return inpField
    }()
    
    private let source: UILabel = {
        let inpField = UILabel()
        inpField.font = .systemFont(ofSize: LinkCellConstants.InputField.fontSize)
        inpField.text = L10n.sourse + ":"
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
        link.text = nil
        setupSubviews()
    }
    
    // MARK: Private functions
    
    private func setupCell() {
        layer.cornerRadius = LinkCellConstants.Cell.borderRadius
        layer.masksToBounds = false
        
        layer.shadowRadius = 3.0
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    private func setupSubviews() {
        contentView.addSubview(link)
        contentView.addSubview(source)
        setupColors()
        makeConstraints()
    }
    
    private func setupColors() {
        backgroundColor = UIColor(asset: Asset.Colors.Background.brightColor)
        link.textColor = .systemBlue
        source.textColor = UIColor(asset: Asset.Colors.Text.mainTextColor)
    }
    
    private func makeConstraints() {
        source.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(LinkCellConstants.InputField.horisontalIndent)
            make.trailing.equalToSuperview().inset(LinkCellConstants.InputField.horisontalIndent)
            make.top.equalToSuperview().inset(LinkCellConstants.InputField.verticalIndent)
            make.bottom.equalToSuperview().inset(LinkCellConstants.InputField.verticalIndent)
            
        }
        link.snp.makeConstraints { make in
            make.leading.equalTo(source).inset(LinkCellConstants.InputField.equalToSource)
            make.trailing.equalToSuperview().inset(LinkCellConstants.InputField.horisontalIndent)
            make.top.equalToSuperview().inset(LinkCellConstants.InputField.verticalIndent)
            make.bottom.equalToSuperview().inset(LinkCellConstants.InputField.verticalIndent)
            
        }
    }
        
        
    func configure(data: AddressCellDisplayData) {
            link.text = data.text
        }
}
    
private extension LinkCell {
    
    struct LinkCellConstants {
        static let horisontalIndentForAllSubviews: CGFloat = 16.0
        struct InputField {
            static let horisontalIndent: CGFloat = horisontalIndentForAllSubviews
            static let verticalIndent: CGFloat = 0
            static let fontSize: CGFloat = 17
            static let cornerRadius: CGFloat = 15.0
            static let equalToSource: CGFloat = 82
        }
        struct Cell {
            static let borderRadius: CGFloat = 10.0
        }
    }
}
