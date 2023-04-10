//
//  ViewControllerWithDimBackground.swift
//  Journeys
//
//  Created by Сергей Адольевич on 18.03.2023.
//

import Foundation
import UIKit

class ViewControllerWithDimBackground: UIViewController {
    // MARK: Public properties
    
    let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(asset: Asset.Colors.Background.dimColor)
        return view
    }()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.addSubview(backgroundView)
        view.backgroundColor = UIColor(asset: Asset.Colors.Background.brightColor)
        setupConstrains()
    }
    
    private func setupConstrains() {
        backgroundView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
}
