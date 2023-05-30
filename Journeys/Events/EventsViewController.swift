//
//  EventsViewController.swift
//  Journeys
//
//  Created by Сергей Адольевич on 02.11.2022.
//

import UIKit
import YandexMapsMobile
import PureLayout
import CoreLocation

class EventsViewController: UIViewController, YMKUserLocationObjectListener {
    
    var output: EventsViewOutput?
    let mapKit = YMKMapKit.sharedInstance()
    
    var showSaveButton: Bool?
    
    private var theme: Theme?

    lazy var addingButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = AddingButtonConstants.cornerRadius
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.borderWidth = AddingButtonConstants.borderWidth
        button.backgroundColor = .clear
        button.autoSetDimension(.width, toSize: AddingButtonConstants.width)
        button.autoSetDimension(.height, toSize: AddingButtonConstants.height)
        button.backgroundColor = UIColor(asset: Asset.Colors.eventButtons)
        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.tintColor = UIColor(asset: Asset.Colors.Stuff.StuffButton.stuffIsPacked)
        
        return button
    }()
    private lazy var map: YMKMapView = {
        
        let map1 = YMKMapView()
        map1.mapWindow.map.isRotateGesturesEnabled = false
        guard let (latitude, longitude, zoom) = output?.displayMap() else { return map1}
        map1.mapWindow.map.move(
            with: YMKCameraPosition.init(target: YMKPoint(latitude: latitude ?? AddingButtonConstants.Coordinates.latitude,
                                                          longitude: longitude ?? AddingButtonConstants.Coordinates.longitude),
                                                          zoom: zoom ?? AddingButtonConstants.Coordinates.zoom,
                                                          azimuth: 0,
                                                          tilt: 0),
            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 3),
            cameraCallback: nil)
        map1.autoSetDimension(.height, toSize: 1000)
        map1.alpha = 0
        return map1
    }()
    
    lazy var userLocationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        button.layer.cornerRadius = AddingButtonConstants.cornerRadius
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.borderWidth = AddingButtonConstants.borderWidth
        button.backgroundColor = .clear
        button.autoSetDimension(.width, toSize: AddingButtonConstants.width)
        button.autoSetDimension(.height, toSize: AddingButtonConstants.height)
        button.backgroundColor = UIColor(asset: Asset.Colors.eventButtons)
        return button
    }()
    
    lazy var userLocationLayer: YMKUserLocationLayer = {
        let scale = UIScreen.main.scale
        let userLocationLayer = mapKit.createUserLocationLayer(with: map.mapWindow)

        userLocationLayer.setVisibleWithOn(true)
        userLocationLayer.isHeadingEnabled = false
        userLocationLayer.setAnchorWithAnchorNormal(
            CGPoint(x: 0.5 * map.frame.size.width * scale, y: 0.5 * map.frame.size.height * scale),
            anchorCourse: CGPoint(x: 0.5 * map.frame.size.width * scale, y: 0.83 * map.frame.size.height * scale))
        userLocationLayer.setObjectListenerWith(self)
        return userLocationLayer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        view.backgroundColor = UIColor(asset: Asset.Colors.Background.brightColor)
        addSubviews()
        setupTapGestureRecognizer()
        
        setupConstraints()
        setupAddingButton()
        output?.didLoadView()
        setupAddingButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output?.didLoadView()

        var theme = Theme.current
        if theme == .system {
            switch UIScreen.main.traitCollection.userInterfaceStyle {
            case .light, .unspecified:
                self.theme = .light
                theme = .light
            case .dark:
                self.theme = .dark
                theme = .dark
            @unknown default: break
            }
        }
        var isNightModeEnabled: Bool = false
        
        switch theme {
        case .dark:
            map.mapWindow.map.isNightModeEnabled = true
            self.theme = theme
        case .light:
            map.mapWindow.map.isNightModeEnabled = false
            self.theme = theme
        default: break
        }
        
        UIView.animate(withDuration: 0.7) { [weak self] in
            self?.map.alpha = 1
        }
    }
    
    private func setupNavBar() {
        if showSaveButton == false {
            return
        }
        navigationController?.navigationBar.tintColor = UIColor(asset: Asset.Colors.Text.mainTextColor)
        let favouritesButtonItem = UIBarButtonItem(image: UIImage(systemName: "bookmark"),
                                                   style: .plain,
                                                   target: self,
                                                   action: #selector(didTapFavouritesButton))
        navigationItem.rightBarButtonItem = favouritesButtonItem
        title = L10n.events
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        map.alpha = 0
    }
    
    private func addSubviews() {
        self.view.addSubview(map)
        self.view.addSubview(addingButton)
        self.view.addSubview(userLocationButton)
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
        map.autoPinEdge(toSuperviewSafeArea: .bottom)
        userLocationButton.autoPinEdge(toSuperviewSafeArea: .right, withInset: AddingButtonConstants.Constraints.right)
        userLocationButton.autoPinEdge(.top, to: .bottom, of: addingButton, withOffset: AddingButtonConstants.offset)
    }

    private func setupAddingButton() {
        addingButton.addTarget(self, action: #selector(didTapAddingButton), for: .touchUpInside)
    }
    
    private func setupUserLocationButton() {
        userLocationButton.addTarget(self, action: #selector(didTapUserLocationButton), for: .touchUpInside)
    }
    
    func displayingPlacemarks(points: [Address]) {
        for place in points {
            let mapObjects = map.mapWindow.map.mapObjects
            let point = YMKPoint(latitude: place.coordinates.latitude, longitude: place.coordinates.longitude)
            let placemark = mapObjects.addPlacemark(with: point)
            placemark.opacity = 1
            placemark.direction = 10
            placemark.isDraggable = false
            
            if theme == .light, let placemarkImage = UIImage(asset: Asset.Assets.PlacemarkIcons.defaultPlacemarkLight) {
                placemark.setIconWith(placemarkImage)
            } else if theme == .dark, let placemarkImage = UIImage(asset: Asset.Assets.PlacemarkIcons.defaultPlacemarkDark) {
                placemark.setIconWith(placemarkImage)
            }
            placemark.addTapListener(with: self)
            placemark.userData = String(place.id)
            
        }
    }
    
    @objc
    private func didTapUserLocationButton() {
        map.mapWindow.map.move(with:
            YMKCameraPosition(target: YMKPoint(latitude: 0, longitude: 0), zoom: 14, azimuth: 0, tilt: 0))
        userLocationLayer.isHeadingEnabled = true
        userLocationLayer.isHeadingEnabled = false

    }

    @objc
    private func didTapAddingButton() {
        output?.didTapAddingButton()
    }

    @objc
    private func didTapFavouritesButton() {
        output?.didTapFavouritesButton()
    }
    //MARK: YMKUserLocationObjectListener protocol

    @objc(onObjectAddedWithView:) func onObjectAdded(with view: YMKUserLocationView) {
        if let userArrowImage = UIImage(asset: Asset.Assets.userArrow) {
            view.arrow.setIconWith(userArrowImage)
        }

        let pinPlacemark = view.pin.useCompositeIcon()
        if let searchResultImage = UIImage(asset: Asset.Assets.searchResult) {
            pinPlacemark.setIconWithName(
                "pin",
                image: searchResultImage,
                style: YMKIconStyle(
                    anchor: CGPoint(x: 0.5, y: 0.5) as NSValue,
                    rotationType: YMKRotationType.rotate.rawValue as NSNumber,
                    zIndex: 1,
                    flat: true,
                    visible: true,
                    scale: 1,
                    tappableArea: nil))
        }
    }

    func onObjectRemoved(with view: YMKUserLocationView) {
    }

    func onObjectUpdated(with view: YMKUserLocationView, event: YMKObjectEvent) {
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
        static let offset: CGFloat = 4
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
        map.mapWindow.map.move(with:
                                YMKCameraPosition(target: point, zoom: 5, azimuth: 0, tilt: 0))
        //map.mapWindow.map.move(with: <#YMKCameraPosition#>)
        output?.didTapOnPlacemark(id: id)
        return true
    }
}

