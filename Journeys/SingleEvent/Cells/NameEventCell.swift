//
//  NameEventCell.swift
//  Journeys
//
//  Created by Ангелина Решетникова on 16.05.2023.
//

import Foundation
import UIKit
import SnapKit

struct NameEventCellDisplayData {
    let name: String
    let type: String
}

protocol NameEventCellDelegate: AnyObject {
    func didLike(isLiked: Bool)
}

final class NameEventCell: UICollectionViewCell {
    
    private let likeImageView: UIImageView = UIImageView()
    var isLiked = false
    weak var delegate: NameEventCellDelegate?
    private let nameField: UILabel = {
        let inpField = UILabel()
        inpField.font = .boldSystemFont(ofSize: NameCellConstants.Cell.nameFont)
        return inpField
    }()
    
    private let typeField: UILabel = {
        let inpField = UILabel()
        inpField.font = .systemFont(ofSize: NameCellConstants.Cell.typeFont)
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
        setupLikeImage()
        setupSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameField.text = nil
        typeField.text = nil
        setupSubviews()
    }
    
    // MARK: Private functions
    
    private func setupCell() {
        layer.cornerRadius = NameCellConstants.Cell.borderRadius
        layer.masksToBounds = false
        
        layer.shadowRadius = 3.0
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    @objc
    private func setupLike() {
        updateLikeImage(with: !isLiked)
        isLiked = !isLiked
    }
        
    
    private func setupLikeImage() {
        clipsToBounds = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(setupLike))
        likeImageView.addGestureRecognizer(tapRecognizer)
        likeImageView.isUserInteractionEnabled = true
        likeImageView.tintColor = .systemPink
        likeImageView.contentMode = .scaleAspectFill
        
        likeImageView.image = UIImage(systemName: "heart")
    }
    
    private func setupSubviews() {
        contentView.addSubview(nameField)
        contentView.addSubview(typeField)
        contentView.addSubview(likeImageView)
        setupColors()
        makeConstraints()
    }
    
    private func setupColors() {
        backgroundColor = UIColor(asset: Asset.Colors.Background.brightColor)
        nameField.textColor = UIColor(asset: Asset.Colors.Text.mainTextColor)
        typeField.textColor = UIColor(asset: Asset.Colors.Text.addressTextColor)
    }
    
    private func makeConstraints() {
        nameField.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(NameCellConstants.InputField.horisontalIndent)
            make.top.equalToSuperview().inset(NameCellConstants.InputField.verticalIndentName)
            make.trailing.equalTo(likeImageView).inset(NameCellConstants.InputField.horisontalIndentType)
        }
        typeField.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(NameCellConstants.InputField.horisontalIndent)
            make.trailing.equalTo(likeImageView).inset(NameCellConstants.InputField.horisontalIndentType)
            make.top.equalTo(nameField).inset(NameCellConstants.InputField.horisontalIndentType)
        }
        likeImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(NameCellConstants.InputField.horisontalIndent)
            make.top.equalToSuperview().inset(NameCellConstants.InputField.verticalIndentImage)
            make.bottom.equalToSuperview().inset(NameCellConstants.InputField.verticalIndentImage)
        }
    }
    
    private func updateLikeImage(with isLiked: Bool) {
        likeImageView.image = isLiked ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
    }
    
        
    func configure(data: NameEventCellDisplayData) {
        nameField.text = data.name
        typeField.text = data.type
    }
}
    
private extension NameEventCell {
    
    struct NameCellConstants {
        static let horisontalIndentForAllSubviews: CGFloat = 16.0
        struct InputField {
            static let horisontalIndent: CGFloat = horisontalIndentForAllSubviews
            static let verticalIndent: CGFloat = 0
            
            static let cornerRadius: CGFloat = 15.0
            static let verticalIndentName: CGFloat = 10
            static let verticalIndentImage: CGFloat = 20
            static let horisontalIndentType: CGFloat = 30
        }
        struct Cell {
            static let borderRadius: CGFloat = 20
            static let nameFont: CGFloat = 20
            static let typeFont: CGFloat = 17
        }
    }
}
