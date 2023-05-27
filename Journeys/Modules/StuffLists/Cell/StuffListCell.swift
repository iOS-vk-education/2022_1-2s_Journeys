//
//  StuffListCell.swift
//  Journeys
//
//  Created by Сергей Адольевич on 07.05.2023.
//

import Foundation
import UIKit

protocol StuffListCellDelegate: AnyObject {
    func didTapColorRoundView(selectedColor: UIColor)
}

final class StuffListCell: UICollectionViewCell {
    
    enum CellType {
        case usual
        case editable(delegate: StuffListCellDelegate)
    }
    
    struct Displaydata {
        let stuffListData: StuffListData
        let cellType: CellType
    }
    
    struct StuffListData {
        let title: String
        let roundColor: UIColor
    }
    
    private weak var delegate: StuffListCellDelegate?
    
    private let coloredRoundView = ViewWithChangeableTouchableArea()
    private let titleTextField: TextFieldWithChangeableTouchableArea = {
        let textField = TextFieldWithChangeableTouchableArea()
        textField.font = .systemFont(ofSize: 17)
        textField.placeholder = "Название"
        return textField
    }()
    private let titleTextFieldEmptyViewForSkeletonLayer = UIView()
    private let titleTextFieldLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
        setupSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleTextField.text = nil
        coloredRoundView.backgroundColor = nil
        titleTextFieldLayer.isHidden = false
        titleTextFieldEmptyViewForSkeletonLayer.isHidden = false
        setAllSubviewsAlphaToZero()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        coloredRoundView.layer.cornerRadius = Constants.RoundView.cornerRadius
        
        coloredRoundView.setNewTouchableArea(CGRect(x: -coloredRoundView.frame.origin.x,
                                                    y: -coloredRoundView.frame.origin.y,
                                                    width: titleTextField.frame.origin.x - 5,
                                                    height: contentView.bounds.height))
        titleTextField.setNewTouchableArea(CGRect(x: titleTextField.bounds.origin.x,
                                                  y: titleTextField.bounds.origin.y,
                                                  width: contentView.frame.width - titleTextField.frame.origin.x - 10,
                                                  height: contentView.bounds.height))
        
        titleTextFieldEmptyViewForSkeletonLayer.frame = CGRect(x: contentView.bounds.origin.x
                                                               + Constants.RoundView.leadingInset
                                                               + Constants.RoundView.width
                                                               + Constants.TitleTextField.leadingInset,
                                                               y: contentView.bounds.origin.y + contentView.bounds.height / 3,
                                                               width: contentView.bounds.width / 2,
                                                               height: contentView.bounds.height / 3)
        titleTextFieldLayer.frame = titleTextFieldEmptyViewForSkeletonLayer.bounds
        titleTextFieldLayer.cornerRadius = titleTextFieldLayer.bounds.height / 2
    }
    
    func changeColoredViewColor(to color: UIColor) {
        coloredRoundView.backgroundColor = color
    }
    
    func getCellData() -> StuffListData? {
        guard let title = titleTextField.text,
              titleTextField.text?.count ?? 0 > 0,
              let color = coloredRoundView.backgroundColor else { return nil }
        return StuffListData(title: title, roundColor: color)
    }
    
    func configure(data: Displaydata) {
        titleTextField.text = data.stuffListData.title
        coloredRoundView.backgroundColor = data.stuffListData.roundColor
        switch data.cellType {
        case .usual:
            titleTextField.isUserInteractionEnabled = false
        case .editable(let delegate):
            self.delegate = delegate
            titleTextField.isUserInteractionEnabled = true
            addColorRoundViewInteractions()
        }
        
        titleTextFieldLayer.isHidden = true
        titleTextFieldEmptyViewForSkeletonLayer.isHidden = true
        
        UIView.animate(
            withDuration: 0.5,
            animations: { [weak self] in
                self?.setSubviewsAlphaToOne()
            })
    }
    
    private func setupCell() {
        backgroundColor = UIColor(asset: Asset.Colors.Background.brightColor)
        layer.cornerRadius = 10
        layer.masksToBounds = false

        layer.shadowRadius = 2.0
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    private func setupSubviews() {
        setAllSubviewsAlphaToZero()
        titleTextField.autocorrectionType = .no
        
        makeConstraints()
        setupSkeletons()
    }
    
    private func setupSkeletons() {
        titleTextFieldLayer.startPoint = CGPoint(x: 0, y: 0.5)
        titleTextFieldLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        let titleTextFieldGroup = makeAnimationGroup()
        titleTextFieldGroup.beginTime = 0.0
        titleTextFieldLayer.add(titleTextFieldGroup, forKey: "backgroundColor")
    }
    
    private func makeConstraints() {
        contentView.addSubview(coloredRoundView)
        contentView.addSubview(titleTextField)
        contentView.addSubview(titleTextFieldEmptyViewForSkeletonLayer)
        titleTextFieldEmptyViewForSkeletonLayer.layer.addSublayer(titleTextFieldLayer)
        
        coloredRoundView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(Constants.RoundView.leadingInset)
            make.width.equalTo(Constants.RoundView.width)
            make.height.equalTo(Constants.RoundView.height)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(coloredRoundView.snp.trailing).offset(Constants.TitleTextField.leadingInset)
            make.trailing.lessThanOrEqualToSuperview().inset(Constants.TitleTextField.trailingInset)
        }
    }
    
    private func addColorRoundViewInteractions() {
        let tapRecognizer = UITapGestureRecognizer(target: self,
                                                   action: #selector(didTapColorRoundView))
        coloredRoundView.isUserInteractionEnabled = true
        coloredRoundView.addGestureRecognizer(tapRecognizer)
    }
    
    private func setAllSubviewsAlphaToZero() {
        coloredRoundView.alpha = 0
        titleTextField.alpha = 0
    }
    
    private func setSubviewsAlphaToOne() {
        coloredRoundView.alpha = 1
        titleTextField.alpha = 1
    }
    
    @objc
    private func didTapColorRoundView() {
        delegate?.didTapColorRoundView(selectedColor: coloredRoundView.backgroundColor ?? UIColor())
    }
}

extension StuffListCell: SkeletonLoadable {
}

private extension StuffListCell {
    enum Constants {
        enum RoundView {
            static let leadingInset: CGFloat = 18
            static let width: CGFloat = 12
            static let height: CGFloat = width
            static let cornerRadius: CGFloat = width / 2
        }
        
        enum TitleTextField {
            static let leadingInset: CGFloat = 16
            static let trailingInset: CGFloat = 16
        }
    }
}
