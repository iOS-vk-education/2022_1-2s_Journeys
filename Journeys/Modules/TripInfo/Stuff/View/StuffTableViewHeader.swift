//
//  StuffTableViewHeader.swift
//  Journeys
//
//  Created by Сергей Адольевич on 19.12.2022.
//

import Foundation
import UIKit

final class StuffTableViewHeader: UITableViewHeaderFooterView {
    private let title = UILabel()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
    }

    private func setupView() {
        addSubview(title)
        title.textAlignment = .center
        title.font = .systemFont(ofSize: 17, weight: .medium)
        setupConstraints()
    }

    private func setupConstraints() {
        title.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(3)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
    func configure(title: String) {
        self.title.text = title
    }
}
