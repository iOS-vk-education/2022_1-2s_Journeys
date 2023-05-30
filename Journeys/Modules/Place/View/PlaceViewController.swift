//
//  PlaceViewController.swift
//  Journeys
//
//  Created by Nastya Ischenko on 22/11/2022.
//

import UIKit

// MARK: - PlaceViewController

final class PlaceViewController: AlertShowingViewController {
    
    // MARK: Public properties

    var output: PlaceViewOutput!
    
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
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
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
        tableView.register(LocationCell.self, forCellReuseIdentifier: "LocationCell")
        tableView.register(CalendarCell.self, forCellReuseIdentifier: "CalendarCell")
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
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

extension PlaceViewController: UITableViewDelegate {
}

// MARK: UITableViewDataSource

extension PlaceViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        300
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 53
        } else if indexPath.section == 1 {
            return 300
        }
        return 0
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
        2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else if section == 1 {
            return 1
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if indexPath.section == 0 {
            guard let usualCell = tableView.dequeueReusableCell(withIdentifier: "LocationCell",
                                                                for: indexPath) as? LocationCell else {
                return UITableViewCell()
            }
            let displayData = output.getPlaceCellData(for: indexPath)
            usualCell.configure(data: displayData)
            cell = usualCell
        } else if indexPath.section == 1{
            guard let calendarCell = tableView.dequeueReusableCell(withIdentifier: "CalendarCell",
                                                                for: indexPath) as? CalendarCell else {
                return UITableViewCell()
            }
            let displayData = output.getCalendarCellData()
            calendarCell.counfigure(displayData: displayData, delegate: self)
            cell = calendarCell
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension PlaceViewController: PlaceViewInput {
    func getCell(at indexPath: IndexPath) -> UITableViewCell? {
        return tableView.cellForRow(at: indexPath)
    }
}

extension PlaceViewController: CalendarCellDeledate {
    func selectedDateRange(range: [Date]) {
        
    }
}

private extension PlaceViewController {
    enum Constants {
        static let tableViewHorizontalInsets: CGFloat = 16
        enum Cells {
            static let cornerRadius: CGFloat = 15
            static let height: CGFloat = 52
        }
    }

}
