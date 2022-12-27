//
//  ImageRouteCell.swift
//  Journeys
//
//  Created by Сергей Адольевич on 24.12.2022.
//

import Foundation
import UIKit
import SnapKit

final class ImageRouteCell: UITableViewCell {
    
    private let picture: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: NSCoder())
        setupCell()
        setupSubviews()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        setupSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        picture.image = nil
        setupSubviews()
    }

    // MARK: Private functions

    private func setupCell() {
       layer.cornerRadius = 20
       layer.masksToBounds = false
   }
    
    private func setupSubviews() {
        contentView.addSubview(picture)
        makeConstraints()
    }
    
    private func makeConstraints() {
        picture.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func configure(image: UIImage) {
        picture.image = image
    }
}

