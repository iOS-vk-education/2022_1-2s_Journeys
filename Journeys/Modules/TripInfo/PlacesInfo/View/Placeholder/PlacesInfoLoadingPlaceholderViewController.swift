//
//  PlacesInfoLoadingPlaceholderViewController.swift
//  Journeys
//
//  Created by Сергей Адольевич on 10.04.2023.
//

import Foundation
import UIKit
import SnapKit

// MARK: - PlacesInfoLoadingPlaceholderViewController

final class PlacesInfoLoadingPlaceholderViewController: UIViewController {

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view = PlacesInfoLoadingPlaceholderView()
    }

}

// MARK: - PlacesInfoLoadingPlaceholderView

final class PlacesInfoLoadingPlaceholderView: UIView {
    // MARK: Private properties

    private let progressView = ProgressViewWithImage()

    // MARK: - Constants

    private enum Constants {
        static let titleLabelTopOffset: CGFloat = 60
        static let subtitleLabelTopOffset: CGFloat = 22
        static let labelsHeight: CGFloat = 20

        enum FontSizes {
            static let titleLabelFontSize: CGFloat = 17
            static let subtitleLabelFontSize: CGFloat = 15
        }

        enum Image {
            static let topOffset: CGFloat = 110
            static let width: CGFloat = 172
            static let height: CGFloat = 172
        }
    }

    // MARK: Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupProgressView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupProgressView()
    }

    // MARK: Public Methods
    
    func prepareForReuse() {
        progressView.prepareForReuse()
    }
    
    func configure(tasksCount: Int) {
        progressView.setTasksCount(tasksCount)
    }
    
    func setTasksCount(_ count: Int) {
        progressView.setTasksCount(count)
    }
    
    func taskIsDone() {
        progressView.taskDone()
    }
    
    func setAllTasksDone() {
        progressView.setAllTasksDone()
    }

    // MARK: Private Methods
    
    private func setupProgressView() {
        addSubview(progressView)
        
        progressView.configure(image:  UIImage(systemName: "sun.max.fill"),
                               imageColor: UIColor(asset: Asset.Colors.Weather.sunny))
        
        progressView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(UIScreen.main.bounds.height / 4)
            make.centerX.equalToSuperview()
            make.width.equalTo(Constants.Image.width)
            make.height.equalTo(Constants.Image.height)
        }
    }
}
