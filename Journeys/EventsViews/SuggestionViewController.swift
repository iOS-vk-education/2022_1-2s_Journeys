import UIKit
import YandexMapsMobile
import PureLayout
import CoreLocation



class SuggestionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let profileInfoCellReuseIdentifier = "profileInfoCellReuseIdentifier"
    var moduleOutput: EventsCoordinator? = nil
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SuggestCell.self, forCellReuseIdentifier: profileInfoCellReuseIdentifier)
        tableView.autoSetDimension(.height, toSize: CGFloat(SuggestionViewControllerConstants.TableView.height))
        tableView.backgroundColor = UIColor(asset: Asset.Colors.Background.dimColor)
        tableView.rowHeight = CGFloat(SuggestionViewControllerConstants.TableView.rowheight)
        return tableView
    }()
    lazy var searchBar: UITextField = {
        let searchBar = UITextField()
        searchBar.layer.cornerRadius = CGFloat(SuggestionViewControllerConstants.SearchBar.cornerRadius)
        searchBar.autoSetDimension(.height, toSize: CGFloat(SuggestionViewControllerConstants.SearchBar.height))
        searchBar.placeholder = "Введите адрес"
        searchBar.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: searchBar.frame.height))
        searchBar.leftViewMode = .always
        searchBar.backgroundColor = UIColor(asset: Asset.Colors.searchBar)
        return searchBar
    }()
    lazy var magnifier: UIImageView = {
        let magnifier = UIImageView(image: UIImage(systemName: "magnifyingglass")?
                                    .withTintColor(UIColor(asset: Asset.Colors.BaseColors.contrastToThemeColor) ?? .black,
                                    renderingMode: .alwaysOriginal))
        magnifier.autoSetDimension(.width, toSize: SuggestionViewControllerConstants.Magnifier.width)
        magnifier.autoSetDimension(.height, toSize: SuggestionViewControllerConstants.Magnifier.height)
        return magnifier
    }()
    var suggestResults: [YMKSuggestItem] = []
    let searchManager = YMKSearch.sharedInstance().createSearchManager(with: .combined)
    var suggestSession: YMKSearchSuggestSession!
    let boundingBox = YMKBoundingBox( // Москва
        southWest: YMKPoint(latitude: 55.55, longitude: 37.42),
        northEast: YMKPoint(latitude: 55.95, longitude: 37.82))
    let suggestOptions = YMKSuggestOptions(suggestTypes: .geo, userPosition: nil, suggestWords: true)
 
    override func viewDidLoad() {
        super.viewDidLoad()
        suggestSession = searchManager.createSuggestSession()
        tableView.dataSource = self
        tableView.delegate = self
        self.addSubviews()
        self.setupConstraints()
        self.view.backgroundColor = UIColor(asset: Asset.Colors.Background.dimColor)
        searchBar.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
    }
    func addSubviews() {
        self.view.addSubview(tableView)
        self.view.addSubview(searchBar)
        self.view.addSubview(magnifier)
    }
    func setupConstraints() {
        searchBar.autoPinEdge(toSuperviewSafeArea: .top,
                              withInset: CGFloat(SuggestionViewControllerConstants.SearchBar.topConstrint))
        searchBar.autoAlignAxis(toSuperviewAxis: .vertical)
        searchBar.autoPinEdge(toSuperviewSafeArea: .left,
                              withInset: CGFloat(SuggestionViewControllerConstants.universalConstant))
        searchBar.autoPinEdge(toSuperviewSafeArea: .right,
                              withInset: CGFloat(SuggestionViewControllerConstants.universalConstant))
        tableView.autoPinEdge(.top, to: .bottom, of: searchBar)
        tableView.autoAlignAxis(toSuperviewAxis: .vertical)
        tableView.autoPinEdge(toSuperviewSafeArea: .left,
                              withInset: CGFloat(SuggestionViewControllerConstants.universalConstant))
        tableView.autoPinEdge(toSuperviewSafeArea: .right,
                              withInset: CGFloat(SuggestionViewControllerConstants.universalConstant))
        magnifier.autoPinEdge(toSuperviewSafeArea: .left,
                              withInset: CGFloat(SuggestionViewControllerConstants.Magnifier.leftConstant))
        magnifier.autoPinEdge(.top, to: .top, of: searchBar,
                              withOffset: CGFloat(SuggestionViewControllerConstants.Magnifier.ofSearchBarConstant))
    }
    func onSuggestResponse(_ items: [YMKSuggestItem]) {
        suggestResults = items
        tableView.reloadData()
    }

    func onSuggestError(_ error: Error) {
        guard let suggestError = (error as NSError).userInfo[YRTUnderlyingErrorKey] as? YRTError else {return}
        var errorMessage = "Unknown error"
        if suggestError.isKind(of: YRTNetworkError.self) {
            errorMessage = "Network error"
        } else if suggestError.isKind(of: YRTRemoteError.self) {
            errorMessage = "Remote server error"
        }
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    @objc func editingChanged(_ searchBar: UITextField) {
        let suggestHandler = {(response: [YMKSuggestItem]?, error: Error?) -> Void in
            if let items = response {
                self.onSuggestResponse(items)
            } else {
                self.onSuggestError(error!)
            }
        }
        suggestSession.suggest(
            withText: searchBar.text!,
            window: boundingBox,
            suggestOptions: suggestOptions,
            responseHandler: suggestHandler)
    }
    func tableView(_ tableView: UITableView, cellForRowAt path: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "profileInfoCellReuseIdentifier", for: path) as? SuggestCell else {return UITableViewCell()}
        var adress : String
        var area : String
        (adress, area) = splitAdress(suggestResult: suggestResults[path.row].displayText ?? " ")
        cell.address.text = adress
        cell.area.text = area
        cell.backgroundColor = UIColor(asset: Asset.Colors.Background.dimColor)
        return cell
    }
    
    func splitAdress(suggestResult: String) -> (String, String) {
        let adress: String
        let area: String
        if #available(iOS 16.0, *) {
            if suggestResult.split(separator: ", ").count >= 5 {
                let suggestResultArray = suggestResult.split(separator: ", ")
                adress = (suggestResultArray[(suggestResultArray.count - 3)...(suggestResultArray.count - 1)]).joined(separator: ", ")
                area = suggestResultArray[0...(suggestResultArray.count - 4)].joined(separator: ", ")
            } else if suggestResult.split(separator: ", ").count >= 3 {
                let suggestResultArray = suggestResult.split(separator: ", ")
                adress = (suggestResultArray[(suggestResultArray.count - 2)...(suggestResultArray.count - 1)]).joined(separator: ", ")
                area = suggestResultArray[0...(suggestResultArray.count - 3)].joined(separator: ", ")
            } else {
                adress = suggestResult
                area = ""
            }
        } else {
                adress = suggestResult
                area = ""
            }
        return (adress, area)
    }
   
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "profileInfoCellReuseIdentifier", for: indexPath) as? SuggestCell else {return}
        var adress : String
        var area : String
        (adress, area) = splitAdress(suggestResult: suggestResults[indexPath.row].displayText ?? " ")
        cell.address.text = adress
        cell.area.text = area

        let viewController = AddingEventViewController()
        navigationController?.pushViewController(viewController, animated: true)
        viewController.address = cell.address.text!
        var geocoder = CLGeocoder()
        geocoder.geocodeAddressString(suggestResults[indexPath.row].displayText!) {
            placemarks, error in
            let placemark = placemarks?.first
            let lat = placemark?.location?.coordinate.latitude
            let lon = placemark?.location?.coordinate.longitude
            print(type(of: lat))
            if lat != nil && lon != nil {
                viewController.lat = String(lat!)
                viewController.lon = String(lon!)
            }
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return suggestResults.count
    }
}

private extension SuggestionViewController {

    struct SuggestionViewControllerConstants {
        static let universalConstant = 20
        struct TableView {
            static let height = 560
            static let rowheight = 70
        }
        struct SearchBar {
            static let cornerRadius = 16
            static let height = 50
            static let topConstrint = 25
            
        }
        struct Magnifier {
            static let width = 14.32
            static let height = 14.37
            static let leftConstant = 35
            static let ofSearchBarConstant = 18
        }
        
    }
}


