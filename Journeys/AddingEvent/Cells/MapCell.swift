//
//  MapView.swift
//  MapKav
//
//  Created by Ярослав Шерстюк on 17.03.2021.
//

import Foundation
import UIKit
import SnapKit
import PureLayout
import YandexMapsMobile

struct MapCellDisplayData {
    let latitude: Double
    let longitude: Double
}

final class MapCell: UICollectionViewCell {
    
    
    var editImage : UIImage!
    private var delegate: MapCellDelegate!
    
    private let mapEvent: YMKMapView = {
        let mapView = YMKMapView()
        mapView.mapWindow.map.move(
            with: YMKCameraPosition.init(target: YMKPoint(latitude: 55.76, longitude: 37.573856), zoom: 8, azimuth: 0, tilt: 0),
            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 1),
            cameraCallback: nil)
        mapView.layer.cornerRadius = 20
        return mapView
    }()
    
    private let transparentView = UIButton()
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
        setupSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        setupSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setupSubviews()
    }
    
    // MARK: Private functions
    
    private func setupCell() {
        layer.cornerRadius = 10
        layer.masksToBounds = false
        
        layer.shadowRadius = 3.0
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    private func setupSubviews() {
        contentView.addSubview(mapEvent)
        contentView.addSubview(transparentView)
        
        setupColors()
        makeConstraints()
        transparentView.addTarget(self, action: #selector(didTouchMap), for: .touchUpInside)
        
    }
    
    @objc func didTouchMap() {
        delegate.didTouchMap()
        print("map touched")
    }
    
    private func setupColors() {
        backgroundColor = UIColor(asset: Asset.Colors.Background.brightColor)
    }
    
    private func makeConstraints() {
        mapEvent.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(MapCellConstants.InputField.horisontalIndent)
            make.trailing.equalToSuperview().inset(MapCellConstants.InputField.horisontalIndent)
            make.top.equalToSuperview().inset(MapCellConstants.InputField.verticalIndent)
            make.bottom.equalToSuperview().inset(MapCellConstants.InputField.verticalIndent)
            
        }
        transparentView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(MapCellConstants.InputField.horisontalIndent)
            make.trailing.equalToSuperview().inset(MapCellConstants.InputField.horisontalIndent)
            make.top.equalToSuperview().inset(MapCellConstants.InputField.verticalIndent)
            make.bottom.equalToSuperview().inset(MapCellConstants.InputField.verticalIndent)
            
        }
    }
    
    func configure(data: MapCellDisplayData) {
        mapEvent.mapWindow.map.move(
            with: YMKCameraPosition.init(target: YMKPoint(latitude: data.latitude, longitude: data.longitude), zoom: 8, azimuth: 0, tilt: 0),
            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 1),
            cameraCallback: nil)
    }
    func configureDelegate(delegate: MapCellDelegate) {
        self.delegate = delegate
    }
}
    
    
    
private extension MapCell {
    
    struct MapCellConstants {
        static let horisontalIndentForAllSubviews: CGFloat = 0
        struct InputField {
            static let horisontalIndent: CGFloat = horisontalIndentForAllSubviews
            static let verticalIndent: CGFloat = horisontalIndentForAllSubviews
            
            static let cornerRadius: CGFloat = 0
        }
        struct Cell {
            static let borderRadius: CGFloat = 0
        }
    }
}

protocol MapCellDelegate: AnyObject {
    func didTouchMap() 
}
