//
//  CurrencyCell.swift
//  Journeys
//
//  Created by Сергей Адольевич on 01.04.2023.
//

import Foundation
import UIKit
import SnapKit

protocol CurrencyCellDelegate: AnyObject {
    func didFinishEditingTextField(at indexPath: IndexPath,
                                   text: String,
                                   viewType: CurrencyView.ViewType)
    func didTapCurrencyNameButton(touch: UITapGestureRecognizer,
                                  at indexPath: IndexPath,
                                  currentCurrency: String,
                                  viewType: CurrencyView.ViewType)
}

final class CurrencyCell: UICollectionViewCell {
    
    struct DisplayData {
        let title: String
        let currentCurrencyAmount: String
        let localCurrencyAmount: String
        let currentCurrencyName: String
        let localCurrencyName: String
    }
    
    // MARK: Public Properties
    let identifier: String = "CurrencyCell"
    private var indexPath: IndexPath?
    
    // MARK: Private Properties
    
    private let title: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        return label
    }()
    
    private let currentCurrencyView = CurrencyView()
    private let localCurrencyView = CurrencyView()
    
    private let arrowsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "arrow.left.arrow.right",
                                  withConfiguration: UIImage.SymbolConfiguration(weight: .light))
        imageView.tintColor = UIColor(asset: Asset.Colors.BaseColors.contrastToThemeColor)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private weak var delegate: CurrencyCellDelegate?
    
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
        localCurrencyView.prepareForReuse()
        currentCurrencyView.prepareForReuse()
    }
    
    func textFieldValue(from viewType: CurrencyView.ViewType) -> String? {
        switch viewType {
        case .currentCurrency: return currentCurrencyView.textFieldValue()
        case .localCurrency: return localCurrencyView.textFieldValue()
        }
    }
    
    func setTextFieldText(to text: String, viewType: CurrencyView.ViewType) {
        switch viewType {
        case .currentCurrency: currentCurrencyView.setTextFieldValue(to: text)
        case .localCurrency: localCurrencyView.setTextFieldValue(to: text)
        }
    }
    
    func updateDisplayData(displayData: DisplayData) {
        title.text = displayData.title
        
        currentCurrencyView.configure(data: CurrencyView
            .DisplayData(title: "Текущая валюта",
                         currencyAmount: displayData.currentCurrencyAmount,
                         currencyName: displayData.currentCurrencyName),
                                      delegate: self,
                                      viewType: .currentCurrency)
        localCurrencyView.configure(data: CurrencyView
            .DisplayData(title: "Местная валюта",
                         currencyAmount: displayData.localCurrencyAmount,
                         currencyName: displayData.localCurrencyName),
                                    delegate: self,
                                    viewType: .localCurrency)
    }
    
    func configure(displayData: DisplayData, delegate: CurrencyCellDelegate?, indexPath: IndexPath) {
        updateDisplayData(displayData: displayData)
        self.delegate = delegate
        self.indexPath = indexPath
    }
    
    private func setupView() {
        setupSubviews()
        makeConstraints()
    }
    
    private func setupSubviews() {
        contentView.addSubview(title)
        contentView.addSubview(currentCurrencyView)
        contentView.addSubview(localCurrencyView)
        contentView.addSubview(arrowsImageView)
    }
    
    
    private func makeConstraints() {
        title.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }

        currentCurrencyView.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(4)
            make.leading.equalToSuperview()
            make.trailing.equalTo(arrowsImageView.snp.leading).offset(-8)
            make.bottom.equalToSuperview()
        }
        
        arrowsImageView.snp.makeConstraints { make in
            make.trailing.equalTo(localCurrencyView.snp.leading).offset(-8)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(3)
            make.height.equalTo(22)
            make.width.equalTo(18)
        }
        
        localCurrencyView.setContentCompressionResistancePriority(.defaultHigh,
                                                          for: .horizontal)
        localCurrencyView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalTo(currentCurrencyView.snp.top)
            make.bottom.equalToSuperview()
            make.width.equalTo(currentCurrencyView.snp.width)
        }
    }
}

extension CurrencyCell: UITextFieldDelegate {
    
}

extension CurrencyCell: CurrencyViewDelegate {
    func didTapCurrencyNameButton(touch: UITapGestureRecognizer,
                                  currentCurrency: String,
                                  viewType: CurrencyView.ViewType) {
        guard let indexPath else { return }
        delegate?.didTapCurrencyNameButton(touch: touch,
                                           at: indexPath,
                                           currentCurrency: currentCurrency,
                                           viewType: viewType)
    }
    
    func didFinishEditingTextField(text: String, viewType: CurrencyView.ViewType) {
        guard let indexPath else { return }
        delegate?.didFinishEditingTextField(at: indexPath, text: text, viewType: viewType)
    }
}
