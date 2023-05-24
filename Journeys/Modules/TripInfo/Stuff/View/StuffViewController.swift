//
//  StuffViewController.swift
//  Journeys
//
//  Created by Nastya Ischenko on 18/12/2022.
//
import Foundation
import UIKit
import SnapKit

// MARK: - StuffViewController

final class StuffViewController: UIViewController {

    var output: StuffViewOutput?
    
    private let tableViewController = StuffTableViewController(style: .grouped)
    private var tableView = UITableView()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    
    private lazy var addStuffListFloatingButton: FloatingButton = {
        let button = FloatingButton()
        button.backgroundColor = UIColor(asset: Asset.Colors.BaseColors.contrastToThemeColor)
        button.configure(title: "Add stuff list")
        button.addTarget(self, action: #selector(didTapAddStuffListButton), for: .touchUpInside)
        view.addSubview(button)
        return button
    }()
    
    private var placeholderView = UIView()

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()
        setupView()
    }

    private func setupView() {
        view.backgroundColor = UIColor(asset: Asset.Colors.Background.brightColor)
        setupSubViews()
    }
    
    private func setupSubViews() {
        placeholderView.isHidden = true
        setupTableView()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapScreen))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        setupTableView()
        
        view.addSubview(addStuffListFloatingButton)
        addStuffListFloatingButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(Constants.AddStuffListFloatingaButton.bottonInset)
            make.width.equalToSuperview().inset(Constants.AddStuffListFloatingaButton.horisontslInsets)
            make.height.equalTo(Constants.AddStuffListFloatingaButton.height)
        }
    }
    
    private func setupTableView() {
        tableView = tableViewController.tableView
        view.addSubview(tableView)
        tableView.addSubview(refreshControl)
        tableView.backgroundColor = UIColor(asset: Asset.Colors.Background.brightColor)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().inset(30)
            make.trailing.equalToSuperview().inset(30)
        }
        
        guard let tableViewControllerOutput = output as? StuffTableViewControllerOutput else { return }
        tableViewController.output = tableViewControllerOutput
    }
    
    @objc
    private func didTapAddStuffListButton() {
        output?.didTapAddStuffListButton()
    }
    
    @objc
    private func refresh() {
        output?.viewDidLoad()
    }

    @objc func didTapScreen() {
        output?.didTapScreen(tableView: tableView)
//        view.endEditing(true)
    }
}

extension StuffViewController: StuffViewInput {
    func getCell(for indexpath: IndexPath) -> UITableViewCell? {
        tableView.cellForRow(at: indexpath)
    }
    
    func deleteRow(at indexPath: IndexPath) {
        tableView.deleteRows(at: [indexPath], with: .left)
    }
    
    func endRefresh() {
        refreshControl.endRefreshing()
    }
    
    func changeIsPickedCellFlag(at indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? StuffCell else { return }
        cell.changeIsPickedFlag()
    }
    
    func getCellsData(from indexPath: IndexPath) -> StuffCell.StuffData? {
        guard let cell = tableView.cellForRow(at: indexPath) as? StuffCell else {
            return nil
        }
        return cell.getData()
    }
    
    func moveTableViewRow(at fromIndexPath: IndexPath, to toIndexPath: IndexPath) {
        tableView.moveRow(at: fromIndexPath, to: toIndexPath)
    }
    
    func deleteCell(at indexPath: IndexPath) {
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
    
    func setCellIndexPath(_ indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? StuffCell else { return }
        cell.setCellIndexPath(indexPath)
    }
    
    func refreshAllCellsIndexPaths() {
        tableView.visibleCells.forEach { [weak self] cell in
            guard let indexPath = self?.tableView.indexPath(for: cell),
            let stuffCell = cell as? StuffCell else { return }
            stuffCell.setCellIndexPath(indexPath)
        }
    }
    
    func reloadData() {
        tableViewController.reloadData()
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                          preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension StuffViewController {
    func didChangeBaggage() {
        output?.didChangeBaggage()
    }
}

private extension StuffViewController {
    enum Constants {
        enum AddStuffListFloatingaButton {
            static let bottonInset: CGFloat = 20
            static let horisontslInsets: CGFloat = 30
            static let height: CGFloat = 40
        }
    }
}
