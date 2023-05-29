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
    
    private func setupNavBar() {
        navigationController?.navigationBar.tintColor = UIColor(asset: Asset.Colors.Text.mainTextColor)
        let favouritesButtonItem = UIBarButtonItem(image: UIImage(systemName: "bookmark.fill"),
                                                   style: .plain,
                                                   target: self,
                                                   action: #selector(didTapFavouritesButton))
        navigationItem.rightBarButtonItem = favouritesButtonItem
        title = L10n.events
    }
    private lazy var addingButton: UIButton = {
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
    private lazy var map: YMKMapView = {
        
        let map1 = YMKMapView()
        guard let (latitude, longitude, zoom) = output?.displayMap() else { return map1 }
        map1.mapWindow.map.move(
            with: YMKCameraPosition.init(target: YMKPoint(latitude: latitude ?? AddingButtonConstants.Coordinates.latitude,
                                                          longitude: longitude ?? AddingButtonConstants.Coordinates.longitude),
                                                          zoom: zoom ?? AddingButtonConstants.Coordinates.zoom,
                                                          azimuth: 0,
                                                          tilt: 0),
            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 5),
            cameraCallback: nil)
        map1.autoSetDimension(.height, toSize: 1000)
        return map1
    }()

    func displayingPlacemarks(points: [Address]) {
        for place in points {
            let mapObjects = map.mapWindow.map.mapObjects
            let point = YMKPoint(latitude: place.coordinates.latitude, longitude: place.coordinates.longitude)
            let placemark = mapObjects.addPlacemark(with: point)
            placemark.opacity = 1
            placemark.direction = 10
            placemark.isDraggable = false
            if let placemarkImage = UIImage(asset: Asset.Assets.PlacemarkIcons.defaultPlacemark) {
                placemark.setIconWith(placemarkImage)
            }
            placemark.addTapListener(with: self)
            placemark.userData = String(place.id)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        view.backgroundColor = UIColor(asset: Asset.Colors.Background.brightColor)
        addSubviews()
        setupTapGestureRecognizer()
        
        setupConstraints()
        setupAddingButton()
        output?.didLoadView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var theme = Theme.current
        if theme == .system {
            switch UIScreen.main.traitCollection.userInterfaceStyle {
            case .light, .unspecified: theme = .light
            case .dark: theme = .dark
            @unknown default: break
            }
        }
        var isNightModeEnabled: Bool = false
        switch theme {
        case .dark:
            map.mapWindow.map.isNightModeEnabled = true
        case .light:
            map.mapWindow.map.isNightModeEnabled = false
        default: break
        }
        
        UIView.animate(withDuration: 0.7) { [weak self] in
            self?.map.alpha = 1
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        map.alpha = 0
    }
    
    private func addSubviews() {
        self.view.addSubview(map)
        self.view.addSubview(addingButton)
    }
    
    private func setupTapGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapScreen))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
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
    private func didTapFavouritesButton() {
    }
    
    @objc
    private func didTapScreen() {
        output?.didTapScreen()
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
        struct Coordinates {
            static let latitude = 55.754066
            static let longitude = 37.861582
            static let zoom : Float = 1
        }
    }
}
extension EventsViewController: EventsViewInput {
    func reload(points: [Address]) {
        DispatchQueue.main.async { [weak self] in
            self?.displayingPlacemarks(points: points)
        }
    }
    
    func show(error: Error) {
        
        let alertViewController = UIAlertController(title: L10n.error, message: error.localizedDescription, preferredStyle: .alert)
        
        alertViewController.addAction(UIAlertAction(title: "OK", style: .cancel))
        
        present(alertViewController, animated: true)
    }
}

extension EventsViewController {
    func setCoordinates(_ coordinates: Coordinates) {
        DispatchQueue.main.async { [weak self] in
            self?.map.mapWindow.map.move(
                with: YMKCameraPosition.init(target: YMKPoint(latitude: coordinates.latitude,
                                                              longitude: coordinates.longitude),
                                             zoom: 14,
                                             azimuth: 0,
                                             tilt: 0),
                animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 3),
                cameraCallback: nil)
        }
    }
}


extension EventsViewController: YMKMapObjectTapListener {
    func onMapObjectTap(with mapObject: YMKMapObject, point: YMKPoint) -> Bool {
        guard let placemark = mapObject as? YMKPlacemarkMapObject else { return false }
        let data = placemark.userData
        guard let id = data as? String else { return false}
        output?.didTapOnPlacemark(id: id)
        return true
    }
}

