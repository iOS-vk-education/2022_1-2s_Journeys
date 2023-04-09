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
    var output: EventsViewOutput?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        self.view.backgroundColor = UIColor(asset: Asset.Colors.Background.brightColor)
        self.addSubviews()
        self.setupConstraints()
        setupAddingButton()
        output?.didLoadView()
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
        button.setImage(UIImage(asset: Asset.Assets.addIcon), for: .normal)
        button.layer.cornerRadius = AddingButtonConstants.cornerRadius
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.borderWidth = AddingButtonConstants.borderWidth
        button.tintColor = .gray
        button.backgroundColor = .clear
        button.autoSetDimension(.width, toSize: AddingButtonConstants.width)
        button.autoSetDimension(.height, toSize: AddingButtonConstants.height)
        return button
    }()
    lazy var map: YMKMapView = {
        let map1 = YMKMapView()
        map1.mapWindow.map.move(
            with: YMKCameraPosition.init(target: YMKPoint(latitude: 55.754066, longitude: 37.861582), zoom: 10, azimuth: 0, tilt: 0),
            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 5),
            cameraCallback: nil)
        map1.autoSetDimension(.height, toSize: 1000)
        return map1
    }()

    func displayingPlacemarks(points: [AddressViewObjects]) {
        for place in points {
            let mapObjects = map.mapWindow.map.mapObjects
            let point = YMKPoint(latitude: place.coordinates.latitude, longitude: place.coordinates.longitude)
            let placemark = mapObjects.addPlacemark(with: point)
            placemark.opacity = 1
            placemark.direction = 10
            placemark.isDraggable = false
            let image1 = UIImage(asset: Asset.Assets.PlacemarkIcons.defaultPlacemark)
            placemark.setIconWith(image1!)
        }
    }
    private func addSubviews() {
        self.view.addSubview(map)
        self.view.addSubview(addingButton)
    }
    private func setupConstraints() {
        addingButton.autoPinEdge(toSuperviewSafeArea: .right, withInset: AddingButtonConstants.Constraints.right)
        addingButton.autoPinEdge(toSuperviewSafeArea: .top, withInset: AddingButtonConstants.Constraints.top)
        map.autoPinEdge(toSuperviewSafeArea: .left)
        map.autoPinEdge(toSuperviewSafeArea: .right)
        map.autoPinEdge(toSuperviewSafeArea: .top)
    }
    private func setupAddingButton() {
        addingButton.addTarget(self, action: #selector(didTapAddingButton), for: .touchUpInside)
    }
    @objc
    private func didTapAddingButton() {
        output?.didTapAddingButton()
    }
    @objc
    private func didTapSettingsButton() {
       // output.didTapSettingsButton()
    }
    @objc
    private func didTapFavouritesButton() {
       // output.didTapFavouritesButton()
    }
}
private extension EventsViewController {

    struct AddingButtonConstants {
        static let height = 40.0
        static let width = 40.0
        static let cornerRadius = 10.0
        static let borderWidth = 1.0
        struct Constraints {
            static let right = 20.0
            static let top = 89.0
        }
    }
}
extension EventsViewController: EventsViewInput {
    func reload(points: [AddressViewObjects]) {
        DispatchQueue.main.async { [weak self] in
            self?.displayingPlacemarks(points: points)
        }
    }
    
    func show(error: Error) {
        
        let alertViewController = UIAlertController(title: "Ошибка", message: error.localizedDescription, preferredStyle: .alert)
        
        alertViewController.addAction(UIAlertAction(title: "OK", style: .cancel))
        
        present(alertViewController, animated: true)
    }
}

