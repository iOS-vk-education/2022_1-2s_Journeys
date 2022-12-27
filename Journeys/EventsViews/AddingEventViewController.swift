
import UIKit

// MARK: - TripsViewController

final class AddingEventViewController: UIViewController, PlacemarkCellDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func editingBegan() {
        return
    }
    
    
    var moduleOutput: EventsCoordinator? = nil
    var address = ""
    var lat = ""
    var lon = ""
    
    // MARK: Private properties
    private var floatingChangeButton = FloatingButton2()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    
    
    // MARK: Public properties
    var output: TripsViewOutput!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(asset: Asset.Colors.Background.brightColor)
        //setupNavBar()
        setupCollectionView()
        setupFloatingAddButton()
        makeConstraints()
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.tintColor = UIColor(asset: Asset.Colors.Text.mainTextColor)
        
        let backButtonItem = UIBarButtonItem(image: UIImage(systemName: "chewron.forward"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(didTapBacksButton))
        
        navigationItem.leftBarButtonItem = backButtonItem
    }
    
    private func setupFloatingAddButton() {
        view.addSubview(floatingChangeButton)
        view.bringSubviewToFront(floatingChangeButton)
        floatingChangeButton.configure(title: "ГОТОВО")
        floatingChangeButton.addTarget(self, action: #selector(didTapReadyButton), for: .touchUpInside)
    }
    
    @objc func didTapReadyButton() {
        let cell = collectionView.cellForItem(at: IndexPath(row: 0, section: 1)) as? PlacemarkCell
        let ofice = cell?.returnText()
        let cell2 = collectionView.cellForItem(at: IndexPath(row: 0, section: 2)) as? PlacemarkCell
        let floor = cell2?.returnText()
        let cell3 = collectionView.cellForItem(at: IndexPath(row: 0, section: 3)) as? PlacemarkCell
        let eventName = cell3?.returnText()
        let cell4 = collectionView.cellForItem(at: IndexPath(row: 0, section: 4)) as? PlacemarkCell
        let eventType = cell4?.returnText()
        let cell5 = collectionView.cellForItem(at: IndexPath(row: 0, section: 5)) as? DateCell
        let date = cell5?.getDateFromPicker()
        let cell6 = collectionView.cellForItem(at: IndexPath(row: 0, section: 5)) as? DateCell
        let link = cell6?.getDateFromPicker()
        print(floor,ofice,eventName,eventType, date)
        let post: [Event] = [
            .init(id: "1", adress: address, date: date!, type: eventType!, name: eventName!, link: link!,  floor: "rtr", room: ofice!, photoURL: floor!)
        ]
        
    }

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
        collectionView.register(DateCell.self,
                                forCellWithReuseIdentifier: "DateCell")
        collectionView.register(ImageEventCell.self,
                                forCellWithReuseIdentifier: "ImageEventCell")
    }

    private func makeConstraints() {
        floatingChangeButton.snp.makeConstraints { make in            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(PlacemarksConstants.FloationgChangeButton.bottomIndent)
            make.height.equalTo(PlacemarksConstants.FloationgChangeButton.height)

        }
        floatingChangeButton.autoAlignAxis(toSuperviewAxis: .vertical)
        floatingChangeButton.autoPinEdge(toSuperviewSafeArea: .right, withInset: PlacemarksConstants.FloationgChangeButton.indent)
        floatingChangeButton.autoPinEdge(toSuperviewSafeArea: .left, withInset: PlacemarksConstants.FloationgChangeButton.indent)

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }

    @objc
    private func didTapBacksButton() {
        print("Settings button was tapped")
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension AddingEventViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 5 {
            return PlacemarksConstants.addCellSize
        }
        else if indexPath.section == 6 {
            return PlacemarksConstants.photoCellSize
        }
        else {
            return PlacemarksConstants.tripCellSize
        }
    }
}

extension AddingEventViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {

            return UIEdgeInsets(top: 11, left: 0, bottom: 0, right: 0)
    }
}

extension AddingEventViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        // TODO: use output
        } else {
            return 1
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        if indexPath.section == 0 {
            guard let placemarkCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "AddressCell",
                for: indexPath
            ) as? AddressCell else {
                return cell
            }

            placemarkCell.configure(data: AddressCellDisplayData(text: address))
            cell = placemarkCell
        }
        if indexPath.section == 1 {
            guard let placemarkCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "PlacemarkCell",
                for: indexPath
            ) as? PlacemarkCell else {
                return cell
            }
            placemarkCell.configure(data: PlacemarkCellDisplayData(
                placeholder: "Кв/офис", text: "", isInFavourites: true), delegate: self)
            cell = placemarkCell
        }
        if indexPath.section == 2 {
            guard let placemarkCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "PlacemarkCell",
                for: indexPath
            ) as? PlacemarkCell else {
                return cell
            }
            placemarkCell.configure(data: PlacemarkCellDisplayData(
                placeholder: "Этаж", text: "", isInFavourites: true), delegate: self)
            cell = placemarkCell
        }
        if indexPath.section == 3 {
            guard let placemarkCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "PlacemarkCell",
                for: indexPath
            ) as? PlacemarkCell else {
                return cell
            }
            placemarkCell.configure(data: PlacemarkCellDisplayData(
                placeholder: "Название мероприятия", text: "", isInFavourites: true), delegate: self)
            cell = placemarkCell
        }
        if indexPath.section == 4 {
            guard let placemarkCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "PlacemarkCell",
                for: indexPath
            ) as? PlacemarkCell else {
                return cell
            }
            placemarkCell.configure(data: PlacemarkCellDisplayData(
                placeholder: "Тип мероприятия", text: "", isInFavourites: true), delegate: self)
            cell = placemarkCell
        }
        if indexPath.section == 5 {
            guard let placemarkCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "DateCell",
                for: indexPath
            ) as? DateCell else {
                return cell
            }
            cell = placemarkCell
        }
        if indexPath.section == 6 {
            guard let placemarkCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "ImageEventCell",
                for: indexPath
            ) as? ImageEventCell else {
                return cell
            }
            placemarkCell.configure(delegate: self)

            cell = placemarkCell
        }
        if indexPath.section == 7 {
            guard let placemarkCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "PlacemarkCell",
                for: indexPath
            ) as? PlacemarkCell else {
                return cell
            }
            placemarkCell.configure(data: PlacemarkCellDisplayData(
                placeholder: "Ссылка на источник", text: "", isInFavourites: true), delegate: self)
            cell = placemarkCell
        }
        return cell
    }


}

extension AddingEventViewController: ImageEventCellDelegate {
    func didTapAddPhotoButton() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            let cell = collectionView.cellForItem(at: IndexPath(row: 0, section: 6)) as? ImageEventCell
            
            cell?.configure2(image: editedImage)
        }
        dismiss(animated: true)
    }
}

// MARK: Constants
private extension AddingEventViewController {

    struct PlacemarksConstants {
        static let addCellSize = CGSize(width: 343, height: 66)
        static let photoCellSize = CGSize(width: 343, height: 257)
        static let tripCellSize = CGSize(width: 343, height: 55)
        static let miniCellSize = CGSize(width: 165, height: 50)

        static let collectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
        struct FloationgChangeButton {
            static let height: CGFloat = 40.0
            static let indent: CGFloat = 15.0
            static let borderRarius: CGFloat = 10.0
            static let bottomIndent: CGFloat = 15.0
        }
    }
}

