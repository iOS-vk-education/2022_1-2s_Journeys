//
//  AccountViewController.swift
//  Journeys
//
//  Created by Nastya Ischenko on 18/03/2023.
//

import UIKit

// MARK: - AccountViewController

final class AccountViewController: ViewControllerWithDimBackground {

    // MARK: Private properties

    private lazy var tableView: UITableView = .init(frame: CGRect.zero, style: .insetGrouped)

    var output: AccountViewOutput?

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output?.viewWillAppear()
    }

    // MARK: Private methods

    private func setupView() {
        view.addSubview(tableView)
        view.backgroundColor = UIColor(asset: Asset.Colors.Background.brightColor)
        
        title = L10n.account

        setupTableView()
        setupConstrains()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        tableView.backgroundColor = backgroundView.backgroundColor
        tableView.separatorColor = tableView.backgroundColor
        
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableView.tableHeaderView = UIView(frame: frame)
        tableView.isScrollEnabled = false
        
        registerCell()
    }

    private func setupConstrains() {
        var tableViewHeight: CGFloat = tableView.tableHeaderView?.frame.height ?? 0
        for section in 0..<tableView.numberOfSections {
            tableViewHeight += CGFloat(tableView.numberOfRows(inSection: section)) * Constants.Cells.height
            tableViewHeight += Constants.tableViewSectionHeaderHeight
        }
        tableView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(tableViewHeight)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }

    private func registerCell() {
        tableView.register(SettingsCell.self, forCellReuseIdentifier: SettingsCell.reuseIdentifier)
    }
}

// MARK: UITableViewDelegate

extension AccountViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        output?.didSelectCell(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: UITableViewDataSource

extension AccountViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.Cells.height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        output?.numberOfRows(in: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        Constants.tableViewSectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0,
                                                        y: 0,
                                                        width: tableView.bounds.width - Constants.tableViewHorizontalInsets * 2,
                                                        height: 80))
        
        let label = UILabel()
        label.frame = CGRect.init(x: 0, y: 0, width: headerView.frame.width, height: headerView.frame.height)
        label.text = output?.username()
        label.font = .systemFont(ofSize: 17)
        label.textColor = UIColor(asset: Asset.Colors.Text.mainTextColor)
        label.textAlignment = .center
        
        headerView.addSubview(label)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.reuseIdentifier,
                                                       for: indexPath) as? SettingsCell else {
            return UITableViewCell()
        }
        let displayData = output?.displayData(for: indexPath)
        if let displayData {
            cell.configure(displayData: displayData)
        }
        cell.separatorInset = UIEdgeInsets.zero
        if indexPath.section == 0 {
            cell.selectionStyle = .none
        }
        return cell
    }
}

extension AccountViewController: AccountViewInput {
    func reloadView() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func deselectCell(_ indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

private extension AccountViewController {
    enum Constants {
        static let backgroundColor = UIColor(asset: Asset.Colors.Background.dimColor)
        static let tableViewHorizontalInsets: CGFloat = 20
        static let tableViewSectionHeaderHeight: CGFloat = 80
        enum Cells {
            static let cornerRadius: CGFloat = 15
            static let height: CGFloat = 52
        }
    }
}
