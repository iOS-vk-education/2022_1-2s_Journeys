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
    
    var output: PlaceViewOutput?
    
    // MARK: Private properties
    
    private lazy var tableView: UITableView = .init(frame: CGRect.zero, style: .grouped)
    
    private let addNotificationLabel: UILabel = {
        let label = UILabel()
        label.text = "Включить напоминание"
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.numberOfLines = 0
        label.textColor = UIColor(asset: Asset.Colors.Text.mainTextColor)
        return label
    }()
    private lazy var addNotificationSwitch: UISwitch = {
        let newSwitch = UISwitch()
        newSwitch.addTarget(self, action: #selector(switchValueHasChanged), for: .valueChanged)
        return newSwitch
    }()
    
    private let notificationsDateLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.reming
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.isHidden = true
        return label
    }()
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        if let localeID = Locale.preferredLanguages.first {
            datePicker.locale = Locale(identifier: localeID)
        }
        datePicker.isHidden = true
        return datePicker
    }()
    
    private let enableNotificationsLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.youNeetToTurnTheApplicationNotificationOn
        label.textColor = UIColor(asset: Asset.Colors.Text.secondaryTextColor)
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()
        setupView()
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
        view.backgroundColor = UIColor(asset: Asset.Colors.Background.dimColor)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        setupSubViews()
    }
    
    private func setupSubViews() {
        if let value = output?.areNotificationDateViewsVisible() {
            output?.setupDateViews(switchValue: value)
        }
        setupTableView()
        setupNavBar()
        setupConstrains()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundColor = UIColor(asset: Asset.Colors.Background.dimColor)
        tableView.separatorColor = tableView.backgroundColor
        
        tableView.allowsSelection = false
        
        registerCell()
    }
    
    private func setupConstrains() {
        view.addSubview(tableView)
        
        view.addSubview(addNotificationLabel)
        view.addSubview(addNotificationSwitch)
        
        view.addSubview(enableNotificationsLabel)
        
        view.addSubview(notificationsDateLabel)
        view.addSubview(datePicker)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview().inset(Constants.tableViewHorizontalInsets)
            make.right.equalToSuperview().inset(Constants.tableViewHorizontalInsets)
            make.height.equalTo(500)
        }
        
        addNotificationLabel.snp.makeConstraints { make in
            make.centerY.equalTo(addNotificationSwitch.snp.centerY)
            make.leading.equalTo(tableView.snp.leading)
        }
        addNotificationSwitch.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom)
            make.trailing.equalTo(tableView.snp.trailing)
            make.width.equalTo(60)
            make.height.equalTo(34)
        }
        
        enableNotificationsLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(addNotificationSwitch.snp.bottom).offset(10)
            make.width.equalToSuperview().inset(40)
        }
        
        notificationsDateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(datePicker.snp.centerY)
            make.leading.equalTo(tableView.snp.leading)
        }
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(addNotificationSwitch.snp.bottom).offset(20)
            make.trailing.equalTo(tableView.snp.trailing)
            make.width.equalTo(200)
            make.height.equalTo(60)
        }
    }
    
    private func registerCell() {
        tableView.register(LocationCell.self, forCellReuseIdentifier: "LocationCell")
        tableView.register(CalendarCell.self, forCellReuseIdentifier: "CalendarCell")
    }
    
    private func setSwitchValue() {
        if let switchValue = output?.switchValue() {
            addNotificationSwitch.isOn = switchValue
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc
    private func switchValueHasChanged() {
        output?.setupDateViews(switchValue: addNotificationSwitch.isOn)
    }
    
    @objc
    private func didTapExitButton() {
        output?.didTapExitButton()
    }
    
    @objc
    private func didTapDoneButton() {
        output?.didTapDoneButton()
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
            if let displayData = output?.getPlaceCellData(for: indexPath) {
                usualCell.configure(data: displayData)
            }
            cell = usualCell
        } else if indexPath.section == 1{
            guard let calendarCell = tableView.dequeueReusableCell(withIdentifier: "CalendarCell",
                                                                   for: indexPath) as? CalendarCell else {
                return UITableViewCell()
            }
            if let displayData = output?.getCalendarCellData() {
                calendarCell.counfigure(displayData: displayData, delegate: self)
            }
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
    
    func setNotificationDateViewsVisibility(to value: Bool) {
        notificationsDateLabel.isHidden = !value
        datePicker.isHidden = !value
    }
    
    func setDatePickerDefaultValue(_ date: Date) {
        DispatchQueue.main.async { [weak self] in
            self?.datePicker.date = date
        }
    }
    
    func datePickerValue() -> Date {
        datePicker.date
    }
    func addNotificationSwitchValue() -> Bool {
        addNotificationSwitch.isOn
    }
    
    func setNotificationsSwitchIsEnabled(_ value: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.addNotificationSwitch.isEnabled = value
            if value, let switchValue = self?.output?.switchValue() {
                self?.addNotificationSwitch.isOn = switchValue
            } else {
                self?.addNotificationSwitch.isOn = false
            }
        }
    }
    
    func reloadData() {
        DispatchQueue.main.async { [weak self] in
            if self?.output?.isNotificationsSwitchEnabled() == false {
                self?.disableNotificationsSwitch()
                return
            }
            self?.enableNotificationsLabel.isHidden = true
            self?.addNotificationSwitch.isEnabled = true
            guard let switchValue = self?.output?.switchValue() else { return }
            self?.addNotificationSwitch.isOn = switchValue
            self?.output?.setupDateViews(switchValue: switchValue)
        }
    }
    
    func disableNotificationsSwitch() {
        addNotificationSwitch.isOn = false
        addNotificationSwitch.isEnabled = false
        setNotificationDateViewsVisibility(to: false)
        enableNotificationsLabel.isHidden = false
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
