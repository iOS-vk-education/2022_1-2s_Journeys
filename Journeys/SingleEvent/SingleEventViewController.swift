//
//  SingleEventViewController.swift
//  Journeys
//
//  Created by Ангелина Решетникова on 11.05.2023.
//

import UIKit
import SafariServices

class SingleEventViewController: UIViewController {
    var output: SingleEventViewOutput?
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .pageSheet
        self.isModalInPresentation = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        output?.didLoadView()
        super.viewDidLoad()
        view.backgroundColor = UIColor(asset: Asset.Colors.Background.brightColor)
        setupCollectionView()
        makeConstraints()
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    func obtainData() {
        collectionView.reloadData()
    }
    
    func obtainImage() {
        collectionView.reloadData()
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor(asset: Asset.Colors.Background.dimColor)
        collectionView.contentInset = PlacemarksConstants.collectionInset
        collectionView.register(TimeCell.self, forCellWithReuseIdentifier: "TimeCell")
        collectionView.register(DescriptionCell.self, forCellWithReuseIdentifier: "DescriptionCell")
        collectionView.register(NameEventCell.self, forCellWithReuseIdentifier: "NameEventCell")
        collectionView.register(EventPictureCell.self, forCellWithReuseIdentifier: "EventPictureCell")
        collectionView.register(PlaceCell.self, forCellWithReuseIdentifier: "PlaceCell")
        collectionView.register(DurationCell.self, forCellWithReuseIdentifier: "DurationCell")
        collectionView.register(LinkCell.self, forCellWithReuseIdentifier: "LinkCell")
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
            if indexPath.section == 4 {
                return PlacemarksConstants.photoCellSize
            } else if indexPath.section == 1 {
                return PlacemarksConstants.eventPictureSize
            }
            else if indexPath.section == 0 || indexPath.section == 2 || indexPath.section == 3 {
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
        return 6
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
        let data = output?.displayingData()
        let image = output?.displayImage()
        
        var cell = UICollectionViewCell()
        if indexPath.section == 0 {
            guard let placemarkCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "NameEventCell",
                for: indexPath
            ) as? NameEventCell else {
                return cell
            }
            
            placemarkCell.configure(data: NameEventCellDisplayData(name: data?.name ?? " ", type: data?.type ?? " "))
            cell = placemarkCell
        }
        if indexPath.section == 1 {
            guard let placemarkCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "EventPictureCell",
                for: indexPath
            ) as? EventPictureCell else {
                return cell
            }
            guard let image else {return placemarkCell}
            placemarkCell.configure(image: image)
            cell = placemarkCell
        }
        if indexPath.section == 2 {
            guard let placemarkCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "PlaceCell",
                for: indexPath
            ) as? PlaceCell else {
                return cell
            }
            placemarkCell.configure(data: PlaceCellDisplayData(address: data?.address ?? " ", flat: data?.room ?? " ", floor: data?.floor ?? " "))
            cell = placemarkCell
        }
        if indexPath.section == 3 {
            guard let placemarkCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "DurationCell",
                for: indexPath
            ) as? DurationCell else {
                return cell
            }
            placemarkCell.configure(data: DurationCellDisplayData(startTime: data?.startDate ?? " ", endTime: data?.finishDate ?? " "))
            cell = placemarkCell
        }
        
        if indexPath.section == 4 {
            guard let placemarkCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "DescriptionCell",
                for: indexPath
            ) as? DescriptionCell else {
                return cell
            }
            placemarkCell.configure(isEditable: false, cornerRadius: 20, text: data?.description ?? " ")
            cell = placemarkCell
        }
        if indexPath.section == 5 {
            guard let placemarkCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "LinkCell",
                for: indexPath
            ) as? LinkCell else {
                return cell
            }
            placemarkCell.configure(data: AddressCellDisplayData(text: data?.link ?? " "))
            cell = placemarkCell
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 5 {
            let data = output?.displayingData()
            guard let link = data?.link else { return }
            guard let url = URL(string: link) else { return }
            let svc = SFSafariViewController(url: url)
            present(svc, animated: false, completion: nil)
        }
    }
    
}

extension SingleEventViewController: DescriptionCellDelegate & UINavigationControllerDelegate{
    func editingBegan() {
    }
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


extension SingleEventViewController: SingleEventViewInput {
    func reload() {
        self.obtainData()
    }
    
    func reloadImage() {
        self.obtainImage()
    }

    func show(error: Error) {
        let alertViewController = UIAlertController(title: L10n.error, message: error.localizedDescription, preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alertViewController, animated: true)
    }
}
