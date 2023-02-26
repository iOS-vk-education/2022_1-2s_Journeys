//
//  EventsViewController.swift
//  Journeys
//
//  Created by Сергей Адольевич on 02.11.2022.
//

import UIKit
import YandexMapsMobile
import PureLayout

class EventsViewController: UIViewController {
    
    var moduleOutput: EventsCoordinator? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        self.view.backgroundColor = UIColor(asset: Asset.Colors.Background.brightColor)
        self.addSubviews()
        self.setupConstraints()
        setupAddingButton()
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.tintColor = UIColor(asset: Asset.Colors.Text.mainTextColor)
        
        let settingsButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape.fill"),
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(didTapSettingsButton))
        
        let favouritesButtonItem = UIBarButtonItem(image: UIImage(systemName: "bookmark.fill"),
                                                   style: .plain,
                                                   target: self,
                                                   action: #selector(didTapFavouritesButton))
        
        navigationItem.leftBarButtonItem = settingsButtonItem
        navigationItem.rightBarButtonItem = favouritesButtonItem
        title = L10n.events
    }
    
    
    lazy var addingButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Add icon.png"), for: .normal)
        button.layer.cornerRadius = 10.0
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.borderWidth = 1.0
        button.tintColor = .gray
        button.backgroundColor = .clear
        button.autoSetDimension(.width, toSize: 40.0)
        button.autoSetDimension(.height, toSize: 40.0)
        return button
        
    }()
    
    lazy var map: YMKMapView = {
        let map1 = YMKMapView()
        map1.mapWindow.map.move(
            with: YMKCameraPosition.init(target: YMKPoint(latitude: 55.751574, longitude: 37.573856), zoom: 1, azimuth: 0, tilt: 0),
            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 5),
            cameraCallback: nil)
        map1.autoSetDimension(.height, toSize: 1000)
        return map1
        
    }()
    
    
    func addSubviews() {
        self.view.addSubview(map)
        self.view.addSubview(addingButton)
        
    }
    
    func setupConstraints() {
        addingButton.autoPinEdge(toSuperviewSafeArea: .right, withInset: 20.0)
        addingButton.autoPinEdge(toSuperviewSafeArea: .top, withInset: 89.0)
        
        map.autoPinEdge(toSuperviewSafeArea: .left)
        map.autoPinEdge(toSuperviewSafeArea: .right)
        
        map.autoPinEdge(toSuperviewSafeArea: .top, withInset: 0)
        
    }
    
    private func setupAddingButton() {
        addingButton.addTarget(self, action: #selector(didTapAddingButton), for: .touchUpInside)
    }
    
    
    @objc
    private func didTapAddingButton() {
        moduleOutput?.openTapToAddButtonViewController()
        print("Add button was tapped")
    }
    
    @objc
    private func didTapSettingsButton() {
        print("Settings button was tapped")
    }
    
    @objc
    private func didTapFavouritesButton() {
        print("Favourites button was tapped")
    }
    
}
