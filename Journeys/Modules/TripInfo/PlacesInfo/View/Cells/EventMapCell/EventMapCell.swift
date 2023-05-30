//
//  EventMapCell.swift
//  MapKav
//
//  Created by Ярослав Шерстюк on 17.03.2021.
//

import Foundation
import UIKit
import SnapKit
import MapKit

final class EventMapCell: UICollectionViewCell {
    
    struct DisplayData {
        let title: String
        let latitude: Double
        let longitude: Double
    }
    
    private let titleBackgroundView = UIView()
    private let title: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17, weight: .medium)
        return label
    }()
    
    private let mapView = MKMapView()
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
        title.text = nil
    }
    
    // MARK: Private functions
    
    private func setupCell() {
        layer.cornerRadius = 20
        layer.masksToBounds = false
    }
    
    private func setupSubviews() {
        contentView.addSubview(titleBackgroundView)
        contentView.addSubview(mapView)
        contentView.addSubview(transparentView)
        
        titleBackgroundView.addSubview(title)
        
        mapView.layer.cornerRadius = 20
        
        makeConstraints()
    }
    
    private func makeConstraints() {
        titleBackgroundView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        title.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        mapView.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(20)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        transparentView.snp.makeConstraints { make in
            make.edges.equalTo(mapView.snp.edges)
        }
    }
    
    func configure(data: DisplayData) {
        title.text = data.title
        let location = CLLocationCoordinate2DMake(data.latitude, data.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        let region = MKCoordinateRegion.init(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
}
