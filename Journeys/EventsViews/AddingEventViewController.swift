
import UIKit

// MARK: - TripsViewController

final class AddingEventViewController: UIViewController, PlacemarkCellDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func editingBegan() {
        return
    }
    
    private var event: Event?
    
    var moduleOutput: EventsCoordinator? = nil
    var address = ""
    var lat = ""
    var lon = ""
    var time = ""
    
    // MARK: Private properties
    private var floatingChangeButton = FloatingButton2()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
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
    
    func dateCheck() {
        guard let calendarCell = collectionView.cellForItem(at: IndexPath(row: 0, section: 5)) as? TimeCell else {
            assertionFailure("Error while getting time")
            return
        }
        let startDate = calendarCell.dateChanged()
        guard let calendarCell = collectionView.cellForItem(at: IndexPath(row: 0, section: 6)) as? TimeCell else {
            assertionFailure("Error while getting time")
            return
        }
        let endDate = calendarCell.dateChanged()
        let calendar = Calendar.current
        let startDateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: startDate)
        let endDateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: endDate)
        if calendar.date(from: startDateComponents)! > calendar.date(from: endDateComponents)! {
            let alert = UIAlertController(title: "Error", message: "Неверно указаны даты или время", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        print(type(of: endDate))
    }
    

    
    @objc func didTapReadyButton() {
        let flatCell = collectionView.cellForItem(at: IndexPath(row: 0, section: 1)) as? PlacemarkCell
        let ofice = flatCell?.returnText()
        let floorCell = collectionView.cellForItem(at: IndexPath(row: 0, section: 2)) as? PlacemarkCell
        let floor = floorCell?.returnText()
        let eventNameCell = collectionView.cellForItem(at: IndexPath(row: 0, section: 3)) as? PlacemarkCell
        let eventName = eventNameCell?.returnText()
        let eventTypeCell = collectionView.cellForItem(at: IndexPath(row: 0, section: 4)) as? PlacemarkCell
        let eventType = eventTypeCell?.returnText()
        dateCheck()
        let eventTypeCell1 = collectionView.cellForItem(at: IndexPath(row: 0, section: 7)) as? ImageEventCell
        let jj = eventTypeCell1?.returnPhoto()
//        let post: [Event] = [
//            .init(id: "1", adress: address, date: date!, type: eventType!, name: eventName!, link: link!,  floor: "rtr", room: ofice!, photoURL: floor!)
//        ]
        
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
        //collectionView.register(MapCell.self, forCellWithReuseIdentifier: "MapCell")
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
                placeholder: "Кв/офис"), delegate: self)
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
                placeholder: "Этаж"), delegate: self)
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
                placeholder: "Название мероприятия"), delegate: self)
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
                placeholder: "Тип мероприятия"), delegate: self)
            cell = placemarkCell
        }
        if indexPath.section == 5 {
            guard let placemarkCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "TimeCell",
                for: indexPath
            ) as? TimeCell else {
                return cell
            }
            placemarkCell.configure(data: TimeCellDisplayData(text: "Начало"))
            cell = placemarkCell
        }
        if indexPath.section == 6 {
            guard let placemarkCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "TimeCell",
                for: indexPath
            ) as? TimeCell else {
                return cell
            }
            placemarkCell.configure(data: TimeCellDisplayData(text: "Конец"))
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
            placemarkCell.configure(delegate: self)
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
                placeholder: "Ссылка на источник"), delegate: self)
            cell = placemarkCell
        }
        return cell
    }


}

extension AddingEventViewController: DescriptionCellDelegate {
    
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
        }
        dismiss(animated: true)
    }
}


    
extension AddingEventViewController: MapCellDelegate {
    func didTouchMap() {
        let viewController = EventsViewController()
        moduleOutput?.openEventViewController()
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

