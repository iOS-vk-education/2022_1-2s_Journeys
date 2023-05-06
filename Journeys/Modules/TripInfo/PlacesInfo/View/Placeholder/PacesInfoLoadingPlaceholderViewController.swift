//
//  PacesInfoLoadingPlaceholderViewController.swift
//  Journeys
//
//  Created by Сергей Адольевич on 10.04.2023.
//

import Foundation
import UIKit
import SnapKit

// MARK: - PacesInfoLoadingPlaceholderViewController

final class PacesInfoLoadingPlaceholderViewController: UIViewController {
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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupProgressView()
    }

    // MARK: Private Methods
    
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

    private func setupProgressView() {
        view.addSubview(progressView)
        
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
