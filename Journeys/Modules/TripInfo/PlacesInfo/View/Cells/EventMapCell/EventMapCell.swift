//
//  EventMapCell.swift
//  MapKav
//
//  Created by Ярослав Шерстюк on 17.03.2021.
//

import Foundation
import UIKit
import SnapKit
import PureLayout
import YandexMapsMobile

final class EventMapCell: UICollectionViewCell {
    
    struct DisplayData {
        let latitude: Double
        let longitude: Double
    }
    
    private let map: YMKMapView = {
        let mapView = YMKMapView()
//        mapView.mapWindow.map.move(
//            with: YMKCameraPosition.init(target: YMKPoint(latitude: 55.76, longitude: 37.573856),
//                                         zoom: 8, azimuth: 0, tilt: 0),
//            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 1),
//            cameraCallback: nil)
        mapView.layer.cornerRadius = 20
        return mapView
    }()
    
    private let transparentView = UIView()
    
    
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
        contentView.addSubview(map)
        contentView.addSubview(transparentView)
        
        setupColors()
        makeConstraints()
    }
    
    private func setupColors() {
        backgroundColor = UIColor(asset: Asset.Colors.Background.brightColor)
    }
    
    private func makeConstraints() {
        map.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-40)
            make.height.equalTo(map.snp.width)
        }
        transparentView.snp.makeConstraints { make in
            make.edges.equalTo(map.snp.edges)
        }
    }
    
    func configure(data: DisplayData) {
        map.mapWindow.map.move(
            with: YMKCameraPosition.init(target: YMKPoint(latitude: data.latitude, longitude: data.longitude), zoom: 8, azimuth: 0, tilt: 0),
            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 1),
            cameraCallback: nil)
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
