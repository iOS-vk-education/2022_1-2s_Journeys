//
//  AddStuffCell.swift
//  Journeys
//
//  Created by Сергей Адольевич on 19.12.2022.
//

import Foundation
import UIKit
import SnapKit


final class AddStuffCell: UITableViewCell {

    private var title: UILabel = {
        let label = UILabel()
        label.text = L10n.add
        label.tintColor = UIColor(asset: Asset.Colors.Stuff.addCellColor)
        return label
    }()
    private let icon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "plus")
        imageView.tintColor = UIColor(asset: Asset.Colors.Stuff.addCellColor)
        return imageView
    }()
    
    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(asset: Asset.Colors.Stuff.cellSeparator)
        return view
    }()

    required init?(coder: NSCoder) {
        super.init(coder: NSCoder())
        setupSubiews()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubiews()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0))
    }

    private func setupSubiews() {
        backgroundColor = UIColor(asset: Asset.Colors.Background.brightColor)
        
        contentView.addSubview(title)
        contentView.addSubview(icon)
        contentView.addSubview(separator)

        makeConstraints()
    }

    private func makeConstraints() {
        icon.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(8)
            make.height.equalTo(24)
            make.width.equalTo(20)
        }
        title.snp.makeConstraints { make in
            make.bottom.equalTo(icon.snp.bottom)
            make.leading.equalTo(icon.snp.trailing).offset(12)
        }
        
        separator.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
    }
}
