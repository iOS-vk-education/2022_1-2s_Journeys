//
//  ViewController.swift
//  YMKtry
//
//  Created by User on 06.12.2022.
//

import UIKit
import YandexMapsMobile
import PureLayout

class MainNavigationController: UINavigationController { }

class ViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.navigationBar.isTranslucent = true
        
        let settingsButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(logout))
        let settings = (UIImage(named: "gearshape.fill.png") ?? nil)! as UIImage
        settingsButton.setBackgroundImage(settings, for: .normal, barMetrics: .default)
        navigationItem.setLeftBarButton(settingsButton, animated: true)
        
        let savedButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(logout))
        let saved = (UIImage(named: "bookmark.fill.png") ?? nil)! as UIImage
        savedButton.setBackgroundImage(saved, for: .normal, barMetrics: .default)
        navigationItem.setRightBarButton(savedButton, animated: true)
        
        //let title = UILabel()
        title = "Мероприятия"
        navigationItem.setRightBarButton(savedButton, animated: true)
        
        self.view.backgroundColor = .white
        self.addSubviews ()
        self.setupConstraints()
        
        setupGestures()
    }
    
    lazy var avatar: UIButton = {
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
        let button = YMKMapView()
        button.mapWindow.map.move(
                            with: YMKCameraPosition.init(target: YMKPoint(latitude: 55.751574, longitude: 37.573856), zoom: 15, azimuth: 0, tilt: 0),
                            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 5),
                            cameraCallback: nil)
        //button.autoSetDimensions(to: .init(width: 200, height: 200))
        button.autoSetDimension(.height, toSize: 1000)
        return button
        
    }()
    
//    lazy var settings: UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(named: "gearshape.fill.png"), for: .normal)
//        button.tintColor = .gray
//        button.backgroundColor = .clear
//        button.autoSetDimension(.width, toSize: 19.54)
//        button.autoSetDimension(.height, toSize: 18.7)
//        return button
//    }()
    
    
//    lazy var saved: UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(named: "bookmark.fill.png"), for: .normal)
//        button.tintColor = .white
//        button.backgroundColor = .clear
//        button.autoSetDimension(.width, toSize: 12.83)
//        button.autoSetDimension(.height, toSize: 19.29)
//        return button
//    }()
//
//    lazy var pageName: UILabel = {
//        let label = UILabel()
//        label.textColor = .black
//        label.text = "Мероприятия"
//        label.font = UIFont(name: "SFPRODISPLAYMEDIUM", size: 17)
//        return label
//    }()
//
//    lazy var upperView: UIView = {
//        let view = UIView()
//        view.autoSetDimension(.height, toSize: 44)
//        view.backgroundColor = .white
//        return view
//    }()
    
    
    func addSubviews() {
        self.view.addSubview(map)
        //self.view.addSubview(upperView)
        self.view.addSubview(avatar)
        //self.view.addSubview(saved)
        //self.view.addSubview(settings)
        //self.view.addSubview(pageName)
        
    }
    
    func setupConstraints() {
        avatar.autoPinEdge(toSuperviewSafeArea: .right, withInset: 20.0)
        avatar.autoPinEdge(toSuperviewSafeArea: .top, withInset: 89.0)
        
//        saved.autoPinEdge(toSuperviewSafeArea: .right, withInset: 15.0)
//        saved.autoPinEdge(toSuperviewSafeArea: .top, withInset: 13.0)
//
//        settings.autoPinEdge(toSuperviewSafeArea: .left, withInset: 15.0)
//        settings.autoPinEdge(toSuperviewSafeArea: .top, withInset: 13.0)
        
//        pageName.autoAlignAxis(toSuperviewAxis: .vertical)
//        pageName.autoPinEdge(toSuperviewSafeArea: .top, withInset: 13.0)
//
//        upperView.autoPinEdge(toSuperviewSafeArea: .left)
//        upperView.autoPinEdge(toSuperviewSafeArea: .right)
//        upperView.autoPinEdge(toSuperviewSafeArea: .top, withInset: 0)
//        
        //map.autoAlignAxis(toSuperviewAxis: .vertical)
        map.autoPinEdge(toSuperviewSafeArea: .left)
        map.autoPinEdge(toSuperviewSafeArea: .right)
        
        map.autoPinEdge(toSuperviewSafeArea: .top, withInset: 0)
        
    }
    
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(logout))
        tapGesture.numberOfTapsRequired = 1
        avatar.addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func logout() {
        UserDefaults.standard.set(false, forKey: "LOGGED_IN")
        AppDelegate.shared.rootViewController.switchToAdding()
    }

}

