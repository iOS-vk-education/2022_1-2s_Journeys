//
//  EventsView.swift
//  Journeys
//
//  Created by Сергей Адольевич on 14.12.2022.
//

import Foundation
import UIKit
import SnapKit

final class EventsView: UIView {
    
    private lazy var collectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
       return UICollectionView(frame: .zero, collectionViewLayout: layout)
   }()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    private func setupView() {
        addSubview(collectionView)

        setupCollectionView()
        setupConstraints()
    }

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.register(EventCell.self,
                                forCellWithReuseIdentifier: "EventCell")
        collectionView.register(MainCollectionHeader.self,
                                forSupplementaryViewOfKind: "MainCollectionHeader",
                                withReuseIdentifier: "MainCollectionHeader")
    }

    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(Constants.CollectionView.height * 3)
        }
    }
}

extension EventsView: UICollectionViewDelegate {

}

extension EventsView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                               withReuseIdentifier: "MainCollectionHeader",
                                                                               for: indexPath) as? MainCollectionHeader {
            sectionHeader.configure(title: "Курск")
            return sectionHeader
        }
        return UICollectionReusableView()
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventCell", for: indexPath) as? EventCell else {
            return UICollectionViewCell()
        }
        cell.configure(mapView: UIView())
        return cell
    }
}

private extension EventsView {
    enum Constants {
        enum SectionHeader {
            static let height: CGFloat = 27
            static let horisontalSpacing: CGFloat = 30
        }
        
        enum CollectionView {
            static let verticalSpacingFromHeader: CGFloat = 17
            static let height: CGFloat = 70
        }
    }
}

protocol EventsViewDelegate: AnyObject {
    
}
