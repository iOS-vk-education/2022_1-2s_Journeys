//
//  ViewController.swift
//  journeys.1
//
//  Created by User on 04.12.2022.
//

import UIKit
import YandexMapsMobile
import PureLayout

class SuggestCell: UITableViewCell {
    
    
    lazy var itemName: UILabel = {
        let button = UILabel()
        button.font = UIFont(name: "SFPRODISPLAY", size: 17)
        button.textColor = .black
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        updateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        self.addSubview(itemName)
    }
    
    func setupConstraints() {
        itemName.autoAlignAxis(toSuperviewAxis: .vertical)
        itemName.autoPinEdge(toSuperviewSafeArea: .left, withInset: 20)
        itemName.autoPinEdge(toSuperviewSafeArea: .right, withInset: 20)
    }
    
    override func updateConstraints() {
        let titleInsets = UIEdgeInsets(top: 13, left: 16, bottom: 0, right: 8)
        itemName.autoPinEdgesToSuperviewEdges(with: titleInsets, excludingEdge: .bottom)
        super.updateConstraints()
    }
}


