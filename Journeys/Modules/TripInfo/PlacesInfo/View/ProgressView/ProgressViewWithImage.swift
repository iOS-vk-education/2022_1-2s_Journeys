//
//  ProgressViewWithImage.swift
//  Journeys
//
//  Created by Сергей Адольевич on 07.05.2023.
//

import Foundation
import UIKit

final class ProgressViewWithImage: UIView {
    private var progress: Float = 0 {
        didSet {
            updateProgress()
        }
    }
    private var tasksCount: Int = 0
    private var tasksDone: Int = 0
    
    private let imageView = UIImageView()
    private let progressBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(asset: Asset.Colors.PlacesInfo.ProgressView.background)
        return view
    }()
    private let progressView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(asset: Asset.Colors.PlacesInfo.ProgressView.progress)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupProgressView()
        setupImage()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupProgressView()
        setupImage()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        progressBackground.layer.cornerRadius = progressBackground.frame.height / 2
    }
    
    func configure(image: UIImage?, imageColor: UIColor?) {
        imageView.image = image
        imageView.tintColor = imageColor
    }
    
    func setProgress(to value: Float) {
        progress = value
    }
    
    func setTasksCount(_ count: Int) {
        tasksCount = count
    }
    
    func taskDone() {
        guard tasksCount > tasksDone else {
            return
        }
        tasksDone += 1
        calculateProgress()
    }
    
    func setAllTasksDone() {
        tasksDone = tasksCount
        calculateProgress()
    }
    
    private func calculateProgress() {
        progress = Float(tasksDone) / Float(tasksCount)
    }
    
    private func setupProgressView() {
        addSubview(progressBackground)
        progressBackground.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(Constants.ProgressView.height)
        }
        
        progressBackground.addSubview(progressView)
        progressView.frame = CGRect(origin: progressBackground.bounds.origin,
                                    size: CGSize(width: 0, height: Constants.ProgressView.height))
        progressView.layer.cornerRadius = progressView.frame.height / 2
        
    }
    
    private func setupImage() {
        progressView.addSubview(imageView)
        imageView.frame.size = CGSize(width: Constants.Image.width, height: Constants.Image.height)
        imageView.frame.origin = CGPoint(x: progressView.bounds.origin.x -
                                         imageView.bounds.width / 2,
                                         y: progressView.bounds.origin.y - (imageView.frame.height - progressView.frame.height) / 2)
    }
    
    private func updateProgress() {
        UIView.animate(withDuration: 1) { [weak self] in
            guard let self else { return }
            self.progressView.frame.size.width = self.progressBackground.frame.width * CGFloat(self.progress)
            self.imageView.frame.origin.x = self.progressView.bounds.maxX - self.imageView.frame.width / 2
        }
    }
}

private extension ProgressViewWithImage {
    enum Constants {
        enum ProgressView {
            static let height: CGFloat = 12
        }
        enum Image {
            static let width: CGFloat = 50
            static let height: CGFloat = 50
        }
    }
}
