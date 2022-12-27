import UIKit
import YandexMapsMobile
import PureLayout

class SuggestCell: UITableViewCell {
    
    
    lazy var itemName: UILabel = {
        let button = UILabel()
        button.font = UIFont(name: "SFPRODISPLAY", size: 17)
        button.textColor = .black
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        updateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        self.addSubview(itemName)
    }
    
    func setupConstraints() {
        itemName.autoAlignAxis(toSuperviewAxis: .vertical)
        itemName.autoPinEdge(toSuperviewSafeArea: .left, withInset: 20)
        itemName.autoPinEdge(toSuperviewSafeArea: .right, withInset: 20)
    }
    
    override func updateConstraints() {
        let titleInsets = UIEdgeInsets(top: 13, left: 16, bottom: 0, right: 8)
        itemName.autoPinEdgesToSuperviewEdges(with: titleInsets, excludingEdge: .bottom)
        super.updateConstraints()
    }
}


class SuggestionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   // @IBOutlet weak var tableView: UITableView!
   // @IBOutlet weak var searchBar: UITextField!
    
    let profileInfoCellReuseIdentifier = "profileInfoCellReuseIdentifier"
    var moduleOutput: EventsCoordinator? = nil
    
    lazy var tableView: UITableView = {
        let button = UITableView()
        button.delegate = self
        button.dataSource = self
        button.layer.cornerRadius = 16.0
        button.register(SuggestCell.self, forCellReuseIdentifier: profileInfoCellReuseIdentifier)
        var countSections = suggestResults.count
        button.autoSetDimension(.height, toSize: 1000)
        button.backgroundColor = UIColor(named: "backgrouncountSectionsd")
        return button
        
    }()
    
    lazy var searchBar: UITextField = {
        let button = UITextField()
        button.layer.cornerRadius = 16.0
        button.autoSetDimension(.height, toSize: 45.0)
        button.placeholder = "Введите адрес"
        button.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: button.frame.height))
        button.leftViewMode = .always
        button.backgroundColor = .white
        return button
        
    }()
    
    lazy var magnifier: UIImageView = {
        let button = UIImageView(image: UIImage(systemName: "magnifyingglass")?.withTintColor(.black, renderingMode: .alwaysOriginal))
        button.autoSetDimension(.width, toSize: 14.32)
        button.autoSetDimension(.height, toSize: 14.37)
        return button
        
    }()
    
    
    var suggestResults: [YMKSuggestItem] = []
    let searchManager = YMKSearch.sharedInstance().createSearchManager(with: .combined)
    var suggestSession: YMKSearchSuggestSession!
    
    let boundingBox = YMKBoundingBox(
        southWest: YMKPoint(latitude: 55.55, longitude: 37.42),
        northEast: YMKPoint(latitude: 55.95, longitude: 37.82))
    let suggestOptions = YMKSuggestOptions()
    
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
        
        searchBar.autoPinEdge(toSuperviewSafeArea: .top, withInset: 50)
        searchBar.autoAlignAxis(toSuperviewAxis: .vertical)
        searchBar.autoPinEdge(toSuperviewSafeArea: .left, withInset: 20)
        searchBar.autoPinEdge(toSuperviewSafeArea: .right, withInset: 20)
        
        tableView.autoPinEdge(toSuperviewSafeArea: .top, withInset: 96)
        tableView.autoAlignAxis(toSuperviewAxis: .vertical)
        tableView.autoPinEdge(toSuperviewSafeArea: .left, withInset: 20)
        tableView.autoPinEdge(toSuperviewSafeArea: .right, withInset: 20)
        
        magnifier.autoPinEdge(toSuperviewSafeArea: .top, withInset: 65)
        magnifier.autoPinEdge(toSuperviewSafeArea: .left, withInset: 35)
        
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
        cell.itemName.text = suggestResults[path.row].displayText
        cell.backgroundColor = .white
        //AppDelegate.shared.rootViewController.switchToAddingEvent()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "profileInfoCellReuseIdentifier", for: indexPath) as? SuggestCell else {return}
        cell.itemName.text = suggestResults[indexPath.row].displayText
        let viewController = AddingEventViewController()
        navigationController?.pushViewController(viewController, animated: true)
        viewController.address = cell.itemName.text!
        print(cell.itemName.text!)
        
    
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(suggestResults.count)
        return suggestResults.count
    }
}

