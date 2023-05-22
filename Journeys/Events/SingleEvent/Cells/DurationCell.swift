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
    let sartTime: String
    let endTime: String
}

final class DurationCell: UICollectionViewCell {
    
    private let startTime: UILabel = UILabel()
    private let endTime: UILabel = UILabel()
    
    private let begin: UILabel = UILabel()
    private let end: UILabel = UILabel()
    
    private let clockImage: UIImageView = UIImageView()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
        setupSubviews()
        setupFonts()
        setupConstantText()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        setupSubviews()
        setupFonts()
        setupConstantText()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        startTime.text = nil
        endTime.text = nil
        setupSubviews()
    }

    // MARK: Private functions
    
    private func setupCell() {
        layer.cornerRadius = DurationCellConstants.Cell.cornerRadius
        layer.masksToBounds = false
        
        layer.shadowRadius = 3.0
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    private func setupSubviews() {
        contentView.addSubview(startTime)
        contentView.addSubview(endTime)
        contentView.addSubview(begin)
        contentView.addSubview(end)
        contentView.addSubview(clockImage)
        setupImageView()
        setupColors()
        makeConstraints()
    }
    
    private func setupColors() {
        backgroundColor = UIColor(asset: Asset.Colors.Background.brightColor)
        startTime.textColor = UIColor(asset: Asset.Colors.Text.mainTextColor)
        endTime.textColor = UIColor(asset: Asset.Colors.Text.mainTextColor)
        begin.textColor = UIColor(asset: Asset.Colors.Text.mainTextColor)
        end.textColor = UIColor(asset: Asset.Colors.Text.mainTextColor)
    }
    
    private func setupImageView() {
        clockImage.image = UIImage(systemName: "clock")
        clockImage.contentMode = .scaleAspectFill
        clockImage.tintColor = UIColor(asset: Asset.Colors.PlacesInfo.WeatherCell.dateColor)
    }
    
    private func setupConstantText() {
        begin.text = L10n.begin
        end.text = L10n.end
    }
    
    private func setupFonts() {
        begin.font = .boldSystemFont(ofSize: DurationCellConstants.Text.sizeOfFont)
        end.font = .boldSystemFont(ofSize: DurationCellConstants.Text.sizeOfFont)
        startTime.font = .systemFont(ofSize: DurationCellConstants.Text.sizeOfFont)
        endTime.font = .systemFont(ofSize: DurationCellConstants.Text.sizeOfFont)
    }
    
    private func makeConstraints() {
        clockImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(DurationCellConstants.Text.horisontalIndent)
            make.top.equalToSuperview().inset(DurationCellConstants.Text.verticalIndentForImage)
            make.bottom.equalToSuperview().inset(DurationCellConstants.Text.verticalIndentForImage)
        }
        begin.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(DurationCellConstants.Text.horisontalIndentStart)
            make.trailing.equalToSuperview().inset(DurationCellConstants.Text.horisontalIndent)
            make.top.equalToSuperview().inset(DurationCellConstants.Text.verticalIndentStart)
        }
        end.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(DurationCellConstants.Text.horisontalIndentStart)
            make.trailing.equalToSuperview().inset(DurationCellConstants.Text.horisontalIndent)
            make.top.equalToSuperview().inset(DurationCellConstants.Text.verticalIndentFinish)
        }
        startTime.snp.makeConstraints { make in
            make.leading.equalTo(begin).inset(DurationCellConstants.Text.horisontalIndentFinish)
            make.trailing.equalToSuperview().inset(DurationCellConstants.Text.horisontalIndent)
            make.top.equalToSuperview().inset(DurationCellConstants.Text.verticalIndentStart)
        }
        endTime.snp.makeConstraints { make in
            make.leading.equalTo(end).inset(DurationCellConstants.Text.horisontalIndentFinish)
            make.trailing.equalToSuperview().inset(DurationCellConstants.Text.horisontalIndent)
            make.top.equalToSuperview().inset(DurationCellConstants.Text.verticalIndentFinish)
        }
    }
        
        
        func configure(data: DurationCellDisplayData) {
            startTime.text = data.sartTime
            endTime.text = data.endTime
        }
}
    
private extension DurationCell {
    
    struct DurationCellConstants {
        static let horisontalIndentForAllSubviews: CGFloat = 16.0
        struct Text {
            static let horisontalIndent: CGFloat = horisontalIndentForAllSubviews
            static let verticalIndentForImage: CGFloat = 24
            static let verticalIndentStart: CGFloat = 14
            static let verticalIndentFinish: CGFloat = 36
            static let horisontalIndentStart: CGFloat = 45
            static let horisontalIndentFinish: CGFloat = 70
            
            static let cornerRadius: CGFloat = 15.0
            static let sizeOfFont: CGFloat = 17
        }
        struct Cell {
            static let cornerRadius: CGFloat = 10.0
        }
    }
}
