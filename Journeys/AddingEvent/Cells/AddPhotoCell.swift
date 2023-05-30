//
//  suggestion.swift
//  YMKtry
//
//  Created by User on 20.12.2022.
//

import Foundation
import UIKit
import SnapKit
import PureLayout

struct ImageEventCellDisplayData {
    let text : String
}

final class ImageEventCell: UICollectionViewCell {
    private var delegate: ImageEventCellDelegate?

    private let photoLabel: UILabel = {
        let inpField = UILabel()
        inpField.text = L10n.photo

        return inpField
    }()

    private let addPhotoButton: UIButton = {
        let addPhotoButton = UIButton()
        addPhotoButton.backgroundColor = UIColor(asset: Asset.Colors.SpecifyAdress.photoButton)
        addPhotoButton.layer.cornerRadius = Constants.cornerRadius
        addPhotoButton.setImage(UIImage(systemName: "photo.on.rectangle.angled")?.withTintColor(.black, renderingMode: .alwaysOriginal), for: .normal)
        return addPhotoButton
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
        setupSubviews()
    }
    
    // MARK: Private functions
    
    private func setupCell() {
        layer.cornerRadius = Constants.cornerRadius
        layer.masksToBounds = false
        
        layer.shadowRadius = 3.0
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    private func setupSubviews() {
        contentView.addSubview(addPhotoButton)
        contentView.addSubview(photoLabel)
        
        setupColors()
        makeConstraints()
        setupFonts()
        addPhotoButton.addTarget(self, action: #selector(didTapAddPhotoButton), for: .touchUpInside)

    }
    
    private func setupColors() {
        backgroundColor = UIColor(asset: Asset.Colors.Background.brightColor)
        photoLabel.textColor = UIColor(asset: Asset.Colors.Text.mainTextColor)
    }
    
    private func makeConstraints() {
        addPhotoButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(ImageEventCellConstants.InputField.horisontalIndent)
            make.trailing.equalToSuperview().inset(ImageEventCellConstants.InputField.horisontalIndent)
            make.top.equalToSuperview().inset(50)
            make.bottom.equalToSuperview().inset(ImageEventCellConstants.InputField.verticalIndent)
            
        }
        photoLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(ImageEventCellConstants.InputField.horisontalIndent)
            make.trailing.equalToSuperview().inset(ImageEventCellConstants.InputField.horisontalIndent)
            make.top.equalToSuperview().inset(15)

        }
    }
    
    private func setupFonts() {
        photoLabel.font = UIFont.systemFont(ofSize: 22.0, weight: .bold)
    }
        
    @objc
    private func didTapAddPhotoButton() {
        delegate?.didTapAddPhotoButton()
    }
    
    func configure(delegate: ImageEventCellDelegate) {
        self.delegate = delegate
    }
    
    func configureAddPhotoButton(image: UIImage?) {
        addPhotoButton.setImage(image, for: .normal)
        addPhotoButton.imageView?.clipsToBounds = true
        addPhotoButton.imageView?.layer.cornerRadius = Constants.cornerRadius
        addPhotoButton.imageView?.contentMode = .scaleAspectFill
    }
    
    
}


    
    private extension ImageEventCell {
        
        struct ImageEventCellConstants {
            static let horisontalIndentForAllSubviews: CGFloat = 16
            struct InputField {
                static let horisontalIndent: CGFloat = horisontalIndentForAllSubviews
                static let verticalIndent: CGFloat = horisontalIndentForAllSubviews
                
                static let cornerRadius: CGFloat = 0
            }
            struct Cell {
                static let borderRadius: CGFloat = 0
            }
        }
    }

protocol ImageEventCellDelegate: AnyObject {
    func didTapAddPhotoButton()
}

private extension ImageEventCell {
    struct Constants {
        static let cornerRadius : CGFloat = 10
    }
}
