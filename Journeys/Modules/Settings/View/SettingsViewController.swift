//
//  SettingsViewController.swift
//  DrPillman
//
//  Created by puzzzik on 17/05/2022.
//

import UIKit
import SnapKit

// MARK: - SettingsViewController

final class SettingsViewController: UIViewController {
    enum Section: Int, CaseIterable {
        case notifications
        case other
    }

    // MARK: Private properties

    private enum Constants {
        static let backgroundColor = UIColor(asset: Asset.Colors.Background.dimColor)
        static let tableViewHorizontalInsets: CGFloat = 16
        enum Cells {
            static let cornerRadius: CGFloat = 15
            static let height: CGFloat = 52
        }

        enum Section {
            static let numberOfSections = 2
            static let numberOfRowsInNotificationSection = 1
            static let numberOfRowsInOtherSection = 4
        }
    }

    private lazy var tableView: UITableView = .init(frame: CGRect.zero, style: .insetGrouped)

    // MARK: Public properties

    var output: SettingsViewOutput?

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        output?.viewDidAppear()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: animated)
        }
    }

    // MARK: Private methods

    private func setupView() {
        view.addSubview(tableView)
        view.backgroundColor = UIColor(asset: Asset.Colors.Background.dimColor)
        title = L10n.settings

        setupTableView()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        tableView.backgroundColor = view.backgroundColor
        tableView.separatorColor = tableView.backgroundColor
        setupTableViewConstrains()
        registerCell()
    }

    private func setupTableViewConstrains() {
        tableView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
    }

    private func registerCell() {
        tableView.register(SettingsCell.self, forCellReuseIdentifier: "SettingsCell")
    }
}

// MARK: UITableViewDelegate

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section != 0 else { return }
        output?.didSelectCell(at: indexPath)
    }
}

// MARK: UITableViewDataSource

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return output?.getFooterText(for: section)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.Cells.height
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        Constants.Section.numberOfSections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = Section.allCases[section]

        switch section {
        case .notifications: return Constants.Section.numberOfRowsInNotificationSection
        case .other: return Constants.Section.numberOfRowsInOtherSection
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell",
                                                       for: indexPath) as? SettingsCell else {
            return UITableViewCell()
        }
        let displayData = output?.getDisplayData(for: indexPath)
        if let displayData,
           let cellDelegate = output as? SettingsCellDelegate {
            cell.configure(displayData: displayData, delegate: cellDelegate)
        }
        cell.separatorInset = UIEdgeInsets.zero
        if indexPath.section == 0 {
            cell.selectionStyle = .none
        }
        return cell
    }
}

// MARK: SettingsViewInput

extension SettingsViewController: SettingsViewInput {
    func reloadView() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func deselectCell(_ indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
