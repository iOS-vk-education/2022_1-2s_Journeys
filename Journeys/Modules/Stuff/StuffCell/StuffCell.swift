//
//  StuffCell.swift
//  Journeys
//
//  Created by Сергей Адольевич on 19.12.2022.
//

import Foundation
import UIKit
import SnapKit

final class StuffCell: UITableViewCell {
    
    struct DisplayData {
        let emoji: String?
        let name: String?
        let isPacked: Bool
    }

    private var nameLabel = UITextField()
    private let emojiLabel = UITextField()
    private let packButton: UIButton = {
        let button = UIButton()
//        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
//        button.contentMode = .scaleAspectFit
        return button
    }()
    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(asset: Asset.Colors.Stuff.cellSeparator)
        return view
    }()

    private var isPacked: Bool? = nil

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
        nameLabel.text = nil
        emojiLabel.text = nil
        setupSubiews()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0))
    }

    private func setupSubiews() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(emojiLabel)
        contentView.addSubview(packButton)
        contentView.addSubview(separator)
        
        nameLabel.delegate = self
        emojiLabel.delegate = self
        nameLabel.isUserInteractionEnabled = false
        emojiLabel.isUserInteractionEnabled = false

        makeConstraints()
    }

    private func makeConstraints() {
        emojiLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(10)
            make.height.equalTo(20)
            make.width.equalTo(20)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.bottom.equalTo(emojiLabel.snp.bottom)
            make.leading.equalTo(emojiLabel.snp.trailing).offset(12)
            make.trailing.lessThanOrEqualTo(packButton).offset(-20)
        }
        
        packButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(8)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(4)
            make.width.equalTo(packButton.snp.height)
//            make.height.equalTo(24)
        }
        separator.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(2)
            make.bottom.equalToSuperview()
        }
    }

    func configure(data: DisplayData) {
        emojiLabel.text = data.emoji ?? ""
        nameLabel.text = data.name ?? ""
        isPacked = data.isPacked

        if data.emoji == nil && data.name == nil {
            nameLabel.isUserInteractionEnabled = true
            emojiLabel.isUserInteractionEnabled = true
        }
        if data.isPacked {
            packButton.setImage(UIImage(systemName: "bag.circle.fill"), for: .normal)
            packButton.tintColor = UIColor(asset: Asset.Colors.Stuff.StuffButton.stuffIsPacked)
        } else {
            packButton.setImage(UIImage(systemName: "bag.circle"), for: .normal)
            packButton.tintColor = UIColor(asset: Asset.Colors.Stuff.StuffButton.stuffIsUnpacked)
        }
    }
}

extension StuffCell: UITextFieldDelegate {
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange,
                           replacementString string: String) -> Bool
    {
        let maxLength = 1
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)

        return newString.count <= maxLength
    }
}
