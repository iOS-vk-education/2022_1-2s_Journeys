//
//  SuggestCell.swift
//  Journeys
//
//  Created by Ангелина Решетникова on 26.03.2023.
//

import UIKit
import YandexMapsMobile
import PureLayout
import CoreLocation

class SuggestCell: UITableViewCell {
    
    
    lazy var address: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFPRODISPLAY", size: 17)
        label.textColor = UIColor(asset: Asset.Colors.Text.mainTextColor)
        return label
    }()
    
    lazy var area: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFPRODISPLAY", size: 12)
        label.textColor = UIColor(asset: Asset.Colors.Text.addressTextColor)
        return label
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        self.addSubview(address)
        self.addSubview(area)
    }
    
    func setupConstraints() {
        address.autoPinEdge(toSuperviewSafeArea: .top, withInset: 10)
        address.autoPinEdge(toSuperviewSafeArea: .left, withInset: 20)
        address.autoPinEdge(toSuperviewSafeArea: .right, withInset: 20)
        area.autoPinEdge(toSuperviewSafeArea: .right, withInset: 20)
        area.autoPinEdge(toSuperviewSafeArea: .left, withInset: 20)
        area.autoPinEdge(.top, to: .bottom, of: address, withOffset: 5.0)
    }
    
}
