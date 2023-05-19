
import UIKit
import FirebaseFirestore

// MARK: - TripsViewController

final class AddingEventViewController: UIViewController {
    var address = ""
    var eventImage: UIImage?
    var coordinates: GeoPoint?
    var output: AddingViewOutput?
    
    // MARK: Private properties
    private var floatingChangeButton = FloatingButton2()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(asset: Asset.Colors.Background.brightColor)
        setupNavBar()
        setupCollectionView()
        setupFloatingAddButton()
        makeConstraints()
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.tintColor = UIColor(asset: Asset.Colors.Text.mainTextColor)
        
        let backButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(didTapBacksButton))
        backButtonItem.tintColor = UIColor(asset: Asset.Colors.BaseColors.contrastToThemeColor)
        
        navigationItem.leftBarButtonItem = backButtonItem
        title = L10n.createEvent
    }
    private func setupFloatingAddButton() {
        view.addSubview(floatingChangeButton)
        view.bringSubviewToFront(floatingChangeButton)
        floatingChangeButton.configure(title: L10n.done)
        floatingChangeButton.addTarget(self, action: #selector(didTapReadyButton), for: .touchUpInside)
    }
    
    func dateCheck(startDate: Date, endDate: Date) -> (Date, Date) {
        let calendar = Calendar.current
        let startDateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: startDate)
        let endDateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: endDate)
        if calendar.date(from: startDateComponents)! > calendar.date(from: endDateComponents)! {
            let alert = UIAlertController(title: L10n.error, message: L10n.theDateOrTimeIsIncorrect, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        return (startDate, endDate)
    }



    @objc
    func didTapReadyButton() {
        let flatCell = collectionView.cellForItem(at: IndexPath(row: 0, section: 1)) as? PlacemarkCell
        let ofice = flatCell?.returnText()

        let floorCell = collectionView.cellForItem(at: IndexPath(row: 0, section: 2)) as? PlacemarkCell
        let floor = floorCell?.returnText()

        let eventNameCell = collectionView.cellForItem(at: IndexPath(row: 0, section: 3)) as? PlacemarkCell
        let eventName = eventNameCell?.returnText()

        let eventTypeCell = collectionView.cellForItem(at: IndexPath(row: 0, section: 4)) as? PlacemarkCell
        let eventType = eventTypeCell?.returnText()

        guard let calendarCell = collectionView.cellForItem(at: IndexPath(row: 0, section: 5)) as? TimeCell else {
            assertionFailure("Error while getting time")
            return
        }
        var startDate = calendarCell.dateChanged()
        guard let calendarCell = collectionView.cellForItem(at: IndexPath(row: 0, section: 6)) as? TimeCell else {
            assertionFailure("Error while getting time")
            return
        }
        var endDate = calendarCell.dateChanged()
        (startDate, endDate) = dateCheck(startDate: startDate, endDate: endDate)

        let eventDescriptionCell1 = collectionView.cellForItem(at: IndexPath(row: 0, section: 7)) as? DescriptionCell
        let eventDescription = eventDescriptionCell1?.returnText()

        let eventUrlCell = collectionView.cellForItem(at: IndexPath(row: 0, section: 9)) as? PlacemarkCell
        let eventUrl = eventUrlCell?.returnText()

        let post: Event = Event.init(id: "1",
                                     adress: address,
                                     startDate: startDate,
                                     finishDate: endDate,
                                     type: eventType ?? "",
                                     name: eventName ?? "",
                                     link: eventUrl ?? "",
                                     floor: floor ?? "",
                                     room: ofice ?? "",
                                     photoURL: "",
                                     description: eventDescription ?? "",
                                     isLiked: false)
        let adressCoordinates: Adress = Adress.init(id: "3", coordinates: coordinates!)

        output?.saveData(post: post, coordinates: adressCoordinates, eventImage: eventImage ?? UIImage(asset: Asset.Assets.tripsPlaceholder)!)
        output?.openEventsVC()
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
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
        collectionView.register(ImageEventCell.self,
                                forCellWithReuseIdentifier: "ImageEventCell")
        collectionView.register(TimeCell.self, forCellWithReuseIdentifier: "TimeCell")
        collectionView.register(DescriptionCell.self, forCellWithReuseIdentifier: "DescriptionCell")
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
        output?.backToSuggestionVC()
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension AddingEventViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 7 || indexPath.section == 8{
            return PlacemarksConstants.photoCellSize
        } else {
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
        return 10
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
                withReuseIdentifier: "AddressCell",
                for: indexPath
            ) as? AddressCell else {
                return cell
            }

            placemarkCell.configure(data: AddressCellDisplayData(text: address), cornerRadius: 20)
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
                placeholder: L10n.apartmentOffice), delegate: self)
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
                placeholder: L10n.floor), delegate: self)
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
                placeholder: L10n.eventName), delegate: self)
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
                placeholder: L10n.typeOfEvent), delegate: self)
            cell = placemarkCell
        }
        if indexPath.section == 5 {
            guard let placemarkCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "TimeCell",
                for: indexPath
            ) as? TimeCell else {
                return cell
            }
            placemarkCell.configure(data: TimeCellDisplayData(text: L10n.begin), cornerRadius: 10)
            cell = placemarkCell
        }
        if indexPath.section == 6 {
            guard let placemarkCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "TimeCell",
                for: indexPath
            ) as? TimeCell else {
                return cell
            }
            placemarkCell.configure(data: TimeCellDisplayData(text: L10n.end), cornerRadius: 10)
            cell = placemarkCell
        }

        if indexPath.section == 8 {
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
                withReuseIdentifier: "DescriptionCell",
                for: indexPath
            ) as? DescriptionCell else {
                return cell
            }
            placemarkCell.configure(delegate: self, isEditable: true, cornerRadius: 10, text: "")
            cell = placemarkCell
        }
        if indexPath.section == 9 {
            guard let placemarkCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "PlacemarkCell",
                for: indexPath
            ) as? PlacemarkCell else {
                return cell
            }
            placemarkCell.configure(data: PlacemarkCellDisplayData(
                placeholder: L10n.linkToTheSource), delegate: self)
            cell = placemarkCell
        }
        return cell
    }

}

extension AddingEventViewController: PlacemarkCellDelegate {
    func editingBegan() {
        return
    }
    
}

extension AddingEventViewController: DescriptionCellDelegate & UINavigationControllerDelegate{
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
            let cell = collectionView.cellForItem(at: IndexPath(row: 0, section: 8)) as? ImageEventCell
            

            cell?.configureSetImage(image: editedImage)
            
            eventImage = editedImage
        }
        dismiss(animated: true)
    }
}

extension AddingEventViewController: UIImagePickerControllerDelegate {
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


extension AddingEventViewController: AddingViewInput {
    func showAlert1(title: String, message: String) {
            let alert = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
}

