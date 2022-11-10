//
//  AddTripCell.swift
//  Journeys
//
//  Created by Анастасия Ищенко on 03.11.2022.
//

import Foundation
import UIKit
import SnapKit

final class AddTripCell: UICollectionViewCell {
    
    //MARK: Private properties
    
    private let plusIcon = UIImageView()
    private let addLabel = UILabel()
    
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
        plusIcon.image = nil
        addLabel.text = nil
    }
    
    
    // MARK: Private properties
    
    private func setupCell() {
       layer.cornerRadius = Constants.Cell.borderRadius
       layer.masksToBounds = false

       layer.shadowRadius = 3.0
       layer.shadowColor = UIColor.black.cgColor
       layer.shadowOpacity = 0.1
       layer.shadowOffset = CGSize(width: 0, height: 2)
   }
    
    private func setupSubiews() {
        contentView.addSubview(addLabel)
        contentView.addSubview(plusIcon)
        
        setupColors()
        setupFonts()
        plusIcon.image = UIImage(systemName: "plus.circle.fill")
        addLabel.text = "Добавить"
        makeConstraints()
    }

    private func setupFonts() {
        addLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .medium)
    }
    
    private func setupColors() {
        backgroundColor = JourneysColors.Dynamic.Background.lightColor
        addLabel.textColor = JourneysColors.Dynamic.Text.mainTextColor
        plusIcon.tintColor = JourneysColors.Dynamic.Icons.iconsColor
    }
    
    private func makeConstraints() {
        plusIcon.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(Constants.PlusIcon.leadingIndent)
            make.centerY.equalToSuperview()
            make.height.equalTo(Constants.PlusIcon.height)
            make.width.equalTo(Constants.PlusIcon.width)
        }
        
        addLabel.snp.makeConstraints { make in
            make.leading.equalTo(plusIcon.snp.trailing).offset(Constants.AddLabel.leadingIndentFromPlusIcon)
            make.centerY.equalTo(plusIcon.snp.centerY)
        }
    }
    
    func configure() {
        setupSubiews()
    }
}

private extension AddTripCell {
    struct Constants {
        struct PlusIcon {
            static let leadingIndent: CGFloat = 26.0
            static let height: CGFloat = 26.0
            static let width: CGFloat = height
        }
        struct AddLabel {
            static let leadingIndentFromPlusIcon: CGFloat = 30.0
        }
        struct Cell {
            static let borderRadius: CGFloat = 10.0
        }
    }
}
