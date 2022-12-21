//
//  PlacesIngoViewController.swift
//  Journeys
//
//  Created by Nastya Ischenko on 14/12/2022.
//

import UIKit
import Foundation
import SnapKit

enum SectionType {
    case route
    case weather(String)
    case events
}

// MARK: - PlacesIngoViewController

final class PlacesInfoViewController: UIViewController {

    var output: PlacesInfoViewOutput!
    
    private lazy var mainCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 18, left: 0, bottom: 35, right: 0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 18, left: 0, bottom: 0, right: 0)
        collectionView.contentInsetAdjustmentBehavior = .always
        return collectionView
   }()
    
    var linesCount = 1
    

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewDidLoad()
        setupView()
    }

    private func setupView() {
        view.addSubview(mainCollectionView)

        setupCollectionView()
        setupConstraints()
    }

    private func setupCollectionView() {
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        mainCollectionView.isPrefetchingEnabled = false

        mainCollectionView.register(RouteCell.self,
                                    forCellWithReuseIdentifier: "RouteCell")
        mainCollectionView.register(WeatherCollection.self,
                                    forCellWithReuseIdentifier: "WeatherCollection")
        mainCollectionView.register(MainCollectionHeader.self,
                                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                    withReuseIdentifier: "MainCollectionHeader")
    }
    
    
    private func setupConstraints() {
        mainCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
    
    private func size() -> CGSize {
        let cell = RouteCell()
        guard let data = output.getRoutelData() else {
            return CGSize(width: 0, height: 0)
        }
        return CGSize(width: mainCollectionView.frame.width, height: CGFloat(cell.getLabelLinesCount() * 15))
    }
}

extension PlacesInfoViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: mainCollectionView.frame.width, height: 25)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("taptap")
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: mainCollectionView.frame.width, height: CGFloat(linesCount * 15))
//            let sectionInset = (collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset
//            let referenceHeight: CGFloat = 100 // Approximate height of your cell
//            let referenceWidth = collectionView.safeAreaLayoutGuide.layoutFrame.width
//                - sectionInset?.left ?? 0
//                - sectionInset?.right ?? 0
//                - collectionView.contentInset.left
//                - collectionView.contentInset.right
//            return CGSize(width: referenceWidth, height: referenceHeight)
        case 1:
            return CGSize(width: mainCollectionView.frame.width, height: 85)
        default:
            return CGSize(width: 0, height: 0)
        }
    }
}

extension PlacesInfoViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let sectionHeader = mainCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MainCollectionHeader", for: indexPath) as? MainCollectionHeader {
            
            sectionHeader.configure(title: output.getHeaderText(for: indexPath))
            return sectionHeader
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        output.getMainCollectionCellsCount(for: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        switch indexPath.section {
        case 0:
            guard let routeCell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: "RouteCell",
                                                                     for: indexPath) as? RouteCell else {
                return cell
            }
            guard let data = output.getRoutelData() else {
                return UICollectionViewCell()
            }
            routeCell.configure(data: data)
            linesCount = routeCell.getLabelLinesCount()
            cell = routeCell
        case 1:
            guard let weatherCell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCollection",
                                                                       for: indexPath) as? WeatherCollection else {
                return cell
            }
            weatherCell.configure(data: output.getWeatherCollectionDisplayData(indexPath.row), delegate: self)
            cell = weatherCell
        default:
            return cell
        }
        return cell
    }
}

extension PlacesInfoViewController: PlacesInfoViewInput {
    func reloadData() {
        DispatchQueue.main.async { [weak self] in
            self?.mainCollectionView.reloadData()
        }
    }
}

private extension PlacesInfoViewController {
    enum Constants {
        static let contentBlocksSpacing: CGFloat = 30
        
        enum RouteView {
            static let horisontalSpacing: CGFloat = 20
        }
    }
}

extension PlacesInfoViewController: WeatherCollectionDelegate {
    func getNumberOfItemsInWeatherCollection(_ collectionCell: WeatherCollection) -> Int? {
        guard let row = mainCollectionView.indexPath(for: collectionCell)?.row else { return nil }
        return output.getWeatherCollectionCellsCount(for: row)
    }
    
    func getCellDisplayData(_ cell: WeatherCollection, for indexpath: IndexPath) -> WeatherCell.DisplayData? {
        guard let row = mainCollectionView.indexPath(for: cell)?.row else { return nil }
        return output.getWeatherCollectionCellDisplayData(collectionRow: row, cellRow: indexpath.row)
    }
}


final class CommentFlowLayout : UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
            let layoutAttributesObjects = super.layoutAttributesForElements(in: rect)?.map{ $0.copy() } as? [UICollectionViewLayoutAttributes]
            layoutAttributesObjects?.forEach({ layoutAttributes in
                if layoutAttributes.representedElementCategory == .cell {
                    if let newFrame = layoutAttributesForItem(at: layoutAttributes.indexPath)?.frame {
                        layoutAttributes.frame = newFrame
                    }
                }
            })
            return layoutAttributesObjects
        }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView else { fatalError() }
        guard let layoutAttributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes else {
            return nil
        }

        layoutAttributes.frame.origin.x = sectionInset.left
        layoutAttributes.frame.size.width = collectionView.safeAreaLayoutGuide.layoutFrame.width - sectionInset.left - sectionInset.right
        return layoutAttributes
    }
}

