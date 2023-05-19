//
//  SingleEventViewController.swift
//  Journeys
//
//  Created by Ангелина Решетникова on 11.05.2023.
//

import UIKit

class SingleEventViewController: UIViewController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        
        // 1
        self.modalPresentationStyle = .pageSheet
        
        // 2
        self.isModalInPresentation = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(asset: Asset.Colors.Background.brightColor)
        setupCollectionView()
        makeConstraints()
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor(asset: Asset.Colors.Background.dimColor)
        collectionView.contentInset = PlacemarksConstants.collectionInset
        collectionView.register(PlacemarkCell.self,
                                forCellWithReuseIdentifier: "PlacemarkCell")
        collectionView.register(AddressCell.self,
                                forCellWithReuseIdentifier: "AddressCell")
        collectionView.register(ImageEventCell.self,
                                forCellWithReuseIdentifier: "ImageEventCell")
        collectionView.register(TimeCell.self, forCellWithReuseIdentifier: "TimeCell")
        collectionView.register(DescriptionCell.self, forCellWithReuseIdentifier: "DescriptionCell")
        collectionView.register(NameEventCell.self, forCellWithReuseIdentifier: "NameEventCell")
        collectionView.register(EventPictureCell.self, forCellWithReuseIdentifier: "EventPictureCell")
        collectionView.register(PlaceCell.self, forCellWithReuseIdentifier: "PlaceCell")
    }
    
    private func makeConstraints() {
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
}
    
    extension SingleEventViewController: UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            sizeForItemAt indexPath: IndexPath) -> CGSize {
            if indexPath.section == 5 {
                return PlacemarksConstants.photoCellSize
            } else if indexPath.section == 1 {
                return PlacemarksConstants.eventPictureSize
            }
            else if indexPath.section == 0 || indexPath.section == 2 {
                return PlacemarksConstants.nameEventCellSize
            }
            else {
                return PlacemarksConstants.tripCellSize
            }
        }
    }

extension SingleEventViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 24, left: 15, bottom: 0, right: 15)
        } else {
            return UIEdgeInsets(top: 11, left: 15, bottom: 0, right: 15)
        }
    }
}

extension SingleEventViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
            // TODO: use output
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        if indexPath.section == 0 {
            guard let placemarkCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "NameEventCell",
                for: indexPath
            ) as? NameEventCell else {
                return cell
            }
            
            placemarkCell.configure(data: NameEventCellDisplayData(name: "Читательский клуб", type: "Семинар"))
            cell = placemarkCell
        }
        if indexPath.section == 1 {
            guard let placemarkCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "EventPictureCell",
                for: indexPath
            ) as? EventPictureCell else {
                return cell
            }
            placemarkCell.configure(image: UIImage(asset: Asset.Assets.TripCell.tripCellImage1)!)
            cell = placemarkCell
        }
        if indexPath.section == 2 {
            guard let placemarkCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "PlaceCell",
                for: indexPath
            ) as? PlaceCell else {
                return cell
            }
            placemarkCell.configure(data: PlaceCellDisplayData(address: "2-я Бауманская ул., д.5, стр.1", flat: "10", floor: "3"))
            cell = placemarkCell
        }
        if indexPath.section == 3 {
            guard let placemarkCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "TimeCell",
                for: indexPath
            ) as? TimeCell else {
                return cell
            }
            placemarkCell.configure(data: TimeCellDisplayData(text: L10n.begin), cornerRadius: 20)
            cell = placemarkCell
        }
        if indexPath.section == 4 {
            guard let placemarkCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "TimeCell",
                for: indexPath
            ) as? TimeCell else {
                return cell
            }
            placemarkCell.configure(data: TimeCellDisplayData(text: L10n.end), cornerRadius: 20)
            cell = placemarkCell
        }
        
        if indexPath.section == 5 {
            guard let placemarkCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "DescriptionCell",
                for: indexPath
            ) as? DescriptionCell else {
                return cell
            }
            let text = "Книжный клуб предназначен для тех, кто хочет научиться читать книги и стремиться к саморазвитию. Цел"
            let text2 = text + text + text + text + text
            placemarkCell.configure(delegate: self, isEditable: false, cornerRadius: 20, text: text2)
            cell = placemarkCell
        }
        if indexPath.section == 6 {
            guard let placemarkCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "AddressCell",
                for: indexPath
            ) as? AddressCell else {
                return cell
            }
            placemarkCell.configure(data: AddressCellDisplayData(text: "https://console.firebase.google.com/project/journeys-rolls/authentication/users"), cornerRadius: 20)
            cell = placemarkCell
        }
        return cell
    }
    
}

extension SingleEventViewController: PlacemarkCellDelegate {
    func editingBegan() {
        return
    }
    
}

extension SingleEventViewController: DescriptionCellDelegate & UINavigationControllerDelegate{
}

private extension SingleEventViewController {

    struct PlacemarksConstants {
        static let addCellSize = CGSize(width: 359, height: 66)
        static let photoCellSize = CGSize(width: 359, height: 257)
        static let tripCellSize = CGSize(width: 359, height: 55)
        static let miniCellSize = CGSize(width: 165, height: 50)
        static let nameEventCellSize = CGSize(width: 359, height: 70)
        static let eventPictureSize = CGSize(width: 359, height: 200)
        

        static let collectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
        struct FloationgChangeButton {
            static let height: CGFloat = 40.0
            static let indent: CGFloat = 15.0
            static let borderRarius: CGFloat = 10.0
            static let bottomIndent: CGFloat = 15.0
        }
    }
}
