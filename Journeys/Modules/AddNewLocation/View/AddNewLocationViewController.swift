//
//  AddNewLocationViewController.swift
//  Journeys
//
//  Created by Nastya Ischenko on 22/11/2022.
//

import UIKit

// MARK: - AddNewLocationViewController

final class AddNewLocationViewController: UIViewController {
    
    // MARK: Public properties

    var output: AddNewLocationViewOutput!
    
    // MARK: Private properties

    private lazy var tableView: UITableView = .init(frame: CGRect.zero, style: .grouped)


    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
        setupNavBar()
    }

    // MARK: Private methods

    private func setupNavBar() {
        navigationController?.navigationBar.tintColor = UIColor(asset: Asset.Colors.Text.mainTextColor)
        navigationController?.navigationBar.backgroundColor = UIColor(asset: Asset.Colors.Background.brightColor)
        navigationController?.setStatusBar(backgroundColor: UIColor(asset: Asset.Colors.Background.brightColor) ?? .white)

        let exitButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"),
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(didTapExitButton))

        let doneButtonItem = UIBarButtonItem(image: UIImage(systemName: "checkmark"),
                                                   style: .plain,
                                                   target: self,
                                                   action: #selector(didTapDoneButton))

        navigationItem.leftBarButtonItem = exitButtonItem
        navigationItem.rightBarButtonItem = doneButtonItem
        title = L10n.trips
    }
    
    private func setupView() {
        view.addSubview(tableView)
        view.backgroundColor = UIColor(asset: Asset.Colors.Background.dimColor)
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        tableView.backgroundColor = UIColor(asset: Asset.Colors.Background.dimColor)
        tableView.separatorColor = tableView.backgroundColor
        setupTableViewConstrains()
        registerCell()
    }

    private func setupTableViewConstrains() {
        tableView.snp.makeConstraints { maker in
            maker.left.equalToSuperview().inset(Constants.tableViewHorizontalInsets)
            maker.right.equalToSuperview().inset(Constants.tableViewHorizontalInsets)
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            maker.bottom.equalToSuperview()
        }
    }

    private func registerCell() {
        tableView.register(AddNewLocationCell.self, forCellReuseIdentifier: "AddNewLocationCell")
        tableView.register(CalendarCell.self, forCellReuseIdentifier: "CalendarCell")
    }
    
    @objc
    private func didTapExitButton() {
        output.didTapExitButton()
    }
    
    @objc
    private func didTapDoneButton() {
        output.didTapDoneButton()
    }
}

// MARK: UITableViewDelegate

extension AddNewLocationViewController: UITableViewDelegate {
}

// MARK: UITableViewDataSource

extension AddNewLocationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        0
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        300
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 53
        } else {
            return 300
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        var corners: UIRectCorner = []

        if indexPath.row == 0 {
            corners.update(with: .topLeft)
            corners.update(with: .topRight)
        }

        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            corners.update(with: .bottomLeft)
            corners.update(with: .bottomRight)
        }

        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: cell.bounds,
                                      byRoundingCorners: corners,
                                      cornerRadii: CGSize(width: Constants.Cells.cornerRadius, height: Constants.Cells.cornerRadius)).cgPath
        cell.layer.mask = maskLayer
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if indexPath.row == 0 {
            guard let usualCell = tableView.dequeueReusableCell(withIdentifier: "AddNewLocationCell",
                                                                for: indexPath) as? AddNewLocationCell else {
                return UITableViewCell()
            }
            let displayData = output.getLocationCellData()
            usualCell.configure(displayData: displayData)
            cell = usualCell
        } else {
            guard let calendarCell = tableView.dequeueReusableCell(withIdentifier: "CalendarCell",
                                                                for: indexPath) as? CalendarCell else {
                return UITableViewCell()
            }
            let displayData = output.getCalendarCellData()
            calendarCell.counfigure(displayData: displayData)
            cell = calendarCell
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        output.didSelectCell(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension AddNewLocationViewController: AddNewLocationViewInput {
}

private extension AddNewLocationViewController {
    enum Constants {
        static let tableViewHorizontalInsets: CGFloat = 16
        enum Cells {
            static let cornerRadius: CGFloat = 15
            static let height: CGFloat = 52
        }
    }

}
