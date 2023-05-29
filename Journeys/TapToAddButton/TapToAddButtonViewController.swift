//
//  tapToAddButton.swift
//  YMKtry
//
//  Created by User on 19.12.2022.
//

//import UIKit
//import YandexMapsMobile
//import PureLayout
//
//class TapToAddButtonViewController: UIViewController, UIPopoverPresentationControllerDelegate {
//
//    var moduleOutput: EventsCoordinator? = nil
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.view.backgroundColor = .white
//       // if let center = mapOnAdding.center {
//
//
//        self.addSubviews()
//        self.setupConstraints()
//        setupSpecifyButton()
//        coordinats()
//        print(mapOnAdding)
//        //setupGestures()
//    }
//
//    private func setupNavBar() {
//        navigationController?.navigationBar.tintColor = UIColor(asset: Asset.Colors.Text.mainTextColor)
//
//        let backButtonItem = UIBarButtonItem(image: UIImage(systemName: "chewron.forward"),
//                                                 style: .plain,
//                                                 target: self,
//                                                 action: #selector(didTapBackButton))
//
//        navigationItem.leftBarButtonItem = backButtonItem
//    }
//
//    lazy var mapOnAdding: YMKMapView = {
//        let button = YMKMapView()
//        button.mapWindow.map.move(
//                            with: YMKCameraPosition.init(target: YMKPoint(latitude: 55.751574, longitude: 37.573856), zoom: 15, azimuth: 0, tilt: 0),
//                            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 1),
//                            cameraCallback: nil)
//        //button.autoSetDimensions(to: .init(width: 200, height: 200))
//        button.autoSetDimension(.height, toSize: 1000)
//        let cameraPosition = button.mapWindow.map.cameraPosition
//        print(button.mapWindow.map.cameraPosition.target.latitude)
//        print(button.mapWindow.map.cameraPosition.target.longitude)
//        print("========")
//        return button
//
//    }()
//
//    lazy var placemarkOnAdding: UIImageView = {
//        let imageView = UIImageView(image: UIImage(named: "Group 3.png"))
//        imageView.clipsToBounds = true
//        return imageView
//    }()
//
//
//    lazy var specifyAdress: UIButton = {
//        let specifyAdressButton = UIButton()
//        specifyAdressButton.layer.cornerRadius = 12.0
//        specifyAdressButton.tintColor = .black
//        specifyAdressButton.setTitle("Указаь адрес", for: .normal)
//        specifyAdressButton.titleLabel?.font = UIFont(name: "SFPRODISPLAY", size: 17)
//        specifyAdressButton.backgroundColor = UIColor(asset: Asset.Colors.SpecifyAdress.buttonSpecifyAdress)
//        specifyAdressButton.autoSetDimension(.width, toSize: 153.0)
//        specifyAdressButton.autoSetDimension(.height, toSize: 25.0)
//        return specifyAdressButton
//
//    }()
//
//    lazy var adressDone: UIButton = {
//        let button = UIButton()
//        button.layer.cornerRadius = 10.0
//        button.tintColor = .gray
//        button.setTitle("ГОТОВО", for: .normal)
//        button.titleLabel?.textColor = .white
//        button.titleLabel?.font = UIFont(name: "SFPRODISPLAY", size: 17)
//        button.backgroundColor = .black
//        button.autoSetDimension(.height, toSize: 40.0)
//        return button
//    }()
//
//    func addSubviews() {
//        self.view.addSubview(mapOnAdding)
//        self.view.addSubview(placemarkOnAdding)
//        self.view.addSubview(specifyAdress)
//        self.view.addSubview(adressDone)
//    }
//
//    func setupConstraints() {
//        mapOnAdding.autoPinEdge(toSuperviewSafeArea: .left)
//        mapOnAdding.autoPinEdge(toSuperviewSafeArea: .right)
//        mapOnAdding.autoPinEdge(toSuperviewSafeArea: .top, withInset: 0)
//
//        placemarkOnAdding.autoAlignAxis(toSuperviewAxis: .vertical)
//        placemarkOnAdding.autoAlignAxis(toSuperviewAxis: .horizontal)
//
//        specifyAdress.autoPinEdge(toSuperviewSafeArea: .top, withInset: 179)
//        specifyAdress.autoAlignAxis(toSuperviewAxis: .vertical)
//
//        adressDone.autoPinEdge(toSuperviewSafeArea: .bottom, withInset: 15)
//        adressDone.autoAlignAxis(toSuperviewAxis: .vertical)
//        adressDone.autoPinEdge(toSuperviewSafeArea: .left, withInset: 10)
//        adressDone.autoPinEdge(toSuperviewSafeArea: .right, withInset: 10)
//
//    }
//
//    func coordinats() {
//        let lat = mapOnAdding.mapWindow.map.visibleRegion
//        let lon = mapOnAdding.mapWindow.map.cameraPosition.target.longitude
//        print("Центр: В: \(mapOnAdding.mapWindow.map.cameraPosition.target.latitude) L: \(mapOnAdding.centerYAnchor)")
//    }
//
//    private func setupSpecifyButton() {
//        specifyAdress.addTarget(self, action: #selector(didTapSpecifyAdressButton), for: .touchUpInside)
//    }
//
//    @objc
//    private func didTapSpecifyAdressButton() {
//        moduleOutput?.openSuggestionViewController()
//        print("Add button was tapped")
//    }
//
//    @objc
//    private func didTapBackButton() {
//        print("Back button was tapped")
//    }
//}
//
//private extension TapToAddButtonViewController {
//
//    struct SpecifyAdressConstants {
//        static let height = 40.0
//        static let width = 40.0
//        static let cornerRadius = 10.0
//        static let borderWidth = 1.0
//
//        struct Constraints {
//            static let right = 20.0
//            static let top = 89.0
//        }
//    }
//}
