//
//  LoadingView.swift
//  Journeys
//
//  Created by Сергей Адольевич on 26.12.2022.
//

import Foundation
import UIKit
import SnapKit

class LoadingView: UIView {

    private var loadingActivityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.color = UIColor(asset: Asset.Colors.loaderColor)
        indicator.startAnimating()
        indicator.autoresizingMask = [
            .flexibleLeftMargin, .flexibleRightMargin,
            .flexibleTopMargin, .flexibleBottomMargin
        ]
        return indicator
    }()

    private let backgroungView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(asset: Asset.Colors.Background.brightColor)?.withAlphaComponent(0.4)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }
    
    func setupSubviews() {
        addSubview(backgroungView)
        backgroungView.addSubview(loadingActivityIndicator)

        loadingActivityIndicator.center = CGPoint(
            x: backgroungView.bounds.midX,
            y: backgroungView.bounds.midY
        )

        backgroungView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
}
