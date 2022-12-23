//
//  tapToAddButton.swift
//  YMKtry
//
//  Created by User on 19.12.2022.
//

import UIKit
import YandexMapsMobile
import PureLayout

class tapToAddButton: UIViewController, UIPopoverPresentationControllerDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.navigationBar.isTranslucent = false
        let activityButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(back))
        let image = (UIImage(named: "chevron.backward.png") ?? nil)! as UIImage
        activityButton.setBackgroundImage(image, for: .normal, barMetrics: .default)
        navigationItem.setLeftBarButton(activityButton, animated: true)
        title = "Добавление мероприятия"
        self.view.backgroundColor = .white
       // if let center = mapOnAdding.center {
        
        
        self.addSubviews ()
        self.setupConstraints()
        coordinats()
        setupGestures()
    }
    
    //var nextCameraPosition: YMKCameraPosition!
    
    lazy var mapOnAdding: YMKMapView = {
        let button = YMKMapView()
        button.mapWindow.map.move(
                            with: YMKCameraPosition.init(target: YMKPoint(latitude: 55.751574, longitude: 37.573856), zoom: 15, azimuth: 0, tilt: 0),
                            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 1),
                            cameraCallback: nil)
        //button.autoSetDimensions(to: .init(width: 200, height: 200))
        button.autoSetDimension(.height, toSize: 1000)
        return button
        
    }()
    
    lazy var placemarkOnAdding: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "placemark.png"))
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    lazy var specifyAdress: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 12.0
        button.tintColor = .black
        button.setTitle("Указаь адрес", for: .normal)
        button.titleLabel?.font = UIFont(name: "SFPRODISPLAY", size: 17)
        button.backgroundColor = UIColor(named: "specifyAdress")
        button.autoSetDimension(.width, toSize: 153.0)
        button.autoSetDimension(.height, toSize: 25.0)
        return button
        
    }()
    
    lazy var adressDone: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10.0
        button.tintColor = .gray
        button.setTitle("ГОТОВО", for: .normal)
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = UIFont(name: "SFPRODISPLAY", size: 17)
        button.backgroundColor = .black
        button.autoSetDimension(.height, toSize: 40.0)
        return button
    }()
    
    func addSubviews() {
        self.view.addSubview(mapOnAdding)
        self.view.addSubview(placemarkOnAdding)
        self.view.addSubview(specifyAdress)
        self.view.addSubview(adressDone)
    }
    
    func setupConstraints() {
        mapOnAdding.autoPinEdge(toSuperviewSafeArea: .left)
        mapOnAdding.autoPinEdge(toSuperviewSafeArea: .right)
        mapOnAdding.autoPinEdge(toSuperviewSafeArea: .top, withInset: 0)
        
        placemarkOnAdding.autoAlignAxis(toSuperviewAxis: .vertical)
        placemarkOnAdding.autoAlignAxis(toSuperviewAxis: .horizontal)
        
        specifyAdress.autoPinEdge(toSuperviewSafeArea: .top, withInset: 179)
        specifyAdress.autoAlignAxis(toSuperviewAxis: .vertical)
        
        adressDone.autoPinEdge(toSuperviewSafeArea: .bottom, withInset: 30)
        adressDone.autoAlignAxis(toSuperviewAxis: .vertical)
        adressDone.autoPinEdge(toSuperviewSafeArea: .left, withInset: 10)
        adressDone.autoPinEdge(toSuperviewSafeArea: .right, withInset: 10)
        
    }
    
    func coordinats() {
        //var center = nextCameraPosition.azimuth
       // if let center = mapOnAdding.center {
        print("Центр: В: \(mapOnAdding.centerXAnchor) L: \(mapOnAdding.centerYAnchor)")
    }
    
    @objc
    private func back() {
        UserDefaults.standard.set(false, forKey: "LOGGED_IN")
        AppDelegate.shared.rootViewController.switchToMainScreen()
    }
    
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(logout))
        tapGesture.numberOfTapsRequired = 1
        specifyAdress.addGestureRecognizer(tapGesture)
    }

    @objc
    private func logout() {
        let popVC = suggestion()
        popVC.modalPresentationStyle = .popover
        let popOverVC = popVC.popoverPresentationController
        popOverVC?.delegate = self
        popOverVC?.sourceView = self.specifyAdress
        self.present(popVC, animated: true)
    }
}
