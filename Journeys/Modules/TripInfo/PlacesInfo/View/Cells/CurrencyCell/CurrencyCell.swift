//
//  CurrencyCell.swift
//  Journeys
//
//  Created by Сергей Адольевич on 01.04.2023.
//

import Foundation
import UIKit
import SnapKit

protocol CurrencyViewDelegate: AnyObject {
}

final class CurrencyCell: UICollectionViewCell {
    
    struct DisplayData {
        let title: String
        let course: Decimal
        let currentCurrencyName: String
        let localCurrencyName: String
    }
    
    // MARK: Public Properties
    
    weak var delegate: CurrencyViewDelegate?
    let identifier: String = "CurrencyCell"
    
    // MARK: Private Properties
    
    
    private let title: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        return label
    }()
    
    private let currentCurrencyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .light)
        label.textColor = UIColor(asset: Asset.Colors.Text.secondaryTextColor)
        return label
    }()
    private let currentCurrencyTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.font = .systemFont(ofSize: 15, weight: .light)
        return textField
    }()
    
    private lazy var localCurrencyLabel: UILabel = currentCurrencyLabel
    private lazy var localCurrencyTextField: UITextField = currentCurrencyTextField
    
    private let arrowsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "arrow.left.arrow.right",
                                  withConfiguration: UIImage.SymbolConfiguration(weight: .light))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var course: Decimal?
    private var currentCurrencyName: String?
    private var localCurrencyName: String?
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        title.text = nil
        currentCurrencyTextField.text = nil
        currentCurrencyLabel.text = nil
        localCurrencyTextField.text = nil
        localCurrencyLabel.text = nil
    }
    
    func configure(displayData: DisplayData) {
        self.title.text = displayData.title
        self.course = displayData.course
        
        self.currentCurrencyName = displayData.currentCurrencyName
        self.localCurrencyName = displayData.currentCurrencyName
    }
    
    private func setupView() {
        setupSubviews()
        makeConstraints()
//        backgroundColor = .blue
    }
    
    private func setupSubviews() {
        contentView.addSubview(title)
        contentView.addSubview(currentCurrencyLabel)
        contentView.addSubview(localCurrencyLabel)
        contentView.addSubview(arrowsImageView)
        contentView.addSubview(currentCurrencyTextField)
        contentView.addSubview(localCurrencyTextField)
        
        currentCurrencyLabel.textAlignment = .center
        localCurrencyLabel.textAlignment = .center
        
        currentCurrencyLabel.text = "Текущая валюта"
        localCurrencyLabel.text = "Местная валюта"
        currentCurrencyTextField.text = "1.0"
    }
    
    private func makeConstraints() {
        title.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        currentCurrencyLabel.snp.makeConstraints { make in
            make.leading.equalTo(currentCurrencyTextField.snp.leading)
            make.top.equalTo(title.snp.bottom).offset(17)
        }
        currentCurrencyTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(currentCurrencyLabel.snp.bottom).offset(5)
            make.bottom.equalToSuperview()
            make.width.equalTo(136)
        }

        currentCurrencyTextField.tintColor = .red
        localCurrencyTextField.backgroundColor = .blue

        arrowsImageView.snp.makeConstraints { make in
            make.leading.equalTo(currentCurrencyTextField.snp.trailing).offset(8)
            make.centerY.equalTo(currentCurrencyTextField.snp.centerY)
            make.height.equalTo(22)
            make.width.equalTo(18)
        }

        localCurrencyLabel.snp.makeConstraints { make in
            make.leading.equalTo(localCurrencyTextField.snp.leading)
            make.top.equalTo(currentCurrencyLabel.snp.top)
        }
        
        localCurrencyTextField.snp.makeConstraints { make in
            make.leading.equalTo(arrowsImageView.snp.trailing).offset(8)
            make.top.equalTo(localCurrencyLabel.snp.bottom).offset(5)
            make.bottom.equalToSuperview()
            make.width.equalTo(136)
        }
    }
}
