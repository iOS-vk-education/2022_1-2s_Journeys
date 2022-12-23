//
//  suggestion.swift
//  YMKtry
//
//  Created by User on 20.12.2022.
//

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



class suggestion: UIViewController, UITableViewDataSource, UITableViewDelegate {
   // @IBOutlet weak var tableView: UITableView!
   // @IBOutlet weak var searchBar: UITextField!
    
    let profileInfoCellReuseIdentifier = "profileInfoCellReuseIdentifier"
    
    lazy var tableView: UITableView = {
        let button = UITableView()
        button.delegate = self
        button.dataSource = self
        button.layer.cornerRadius = 16.0
        button.register(SuggestCell.self, forCellReuseIdentifier: profileInfoCellReuseIdentifier)
        button.autoSetDimension(.height, toSize: 700)
        button.backgroundColor = UIColor(named: "background")
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
        let button = UIImageView(image: UIImage(named: "magnifyingglass.png"))
        button.autoSetDimension(.width, toSize: 14.32)
        button.autoSetDimension(.height, toSize: 14.37)
        return button
        
    }()
    
    
    var suggestResults: [YMKSuggestItem] = []
    let searchManager = YMKSearch.sharedInstance().createSearchManager(with: .combined)
    var suggestSession: YMKSearchSuggestSession!
    
    let BOUNDING_BOX = YMKBoundingBox(
        southWest: YMKPoint(latitude: 55.55, longitude: 37.42),
        northEast: YMKPoint(latitude: 55.95, longitude: 37.82))
    let SUGGEST_OPTIONS = YMKSuggestOptions()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        suggestSession = searchManager.createSuggestSession()
        tableView.dataSource = self
        tableView.delegate = self
        self.addSubviews()
        self.setupConstraints()
        self.view.backgroundColor = UIColor(named: "background")
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
        let suggestError = (error as NSError).userInfo[YRTUnderlyingErrorKey] as! YRTError
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
            window: BOUNDING_BOX,
            suggestOptions: SUGGEST_OPTIONS,
            responseHandler: suggestHandler)
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt path: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileInfoCellReuseIdentifier", for: path) as! SuggestCell
        cell.itemName.text = suggestResults[path.row].displayText
        cell.backgroundColor = .white
        //AppDelegate.shared.rootViewController.switchToAddingEvent()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let cell = tableView.dequeueReusableCell(withIdentifier: "profileInfoCellReuseIdentifier", for: indexPath) as! SuggestCell
        cell.itemName.text = suggestResults[indexPath.row].displayText
        AddingEvent().address = cell.itemName.text!
        print(cell.itemName.text!)
        AppDelegate.shared.rootViewController.switchToAddingEvent()
        
        }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestResults.count
    }
}

