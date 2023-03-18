//
//  AuthViewController.swift
//  Journeys
//
//  Created by Nastya Ischenko on 25/12/2022.
//

import UIKit

// MARK: - AuthViewController

final class AuthViewController: ViewControllerWithDimBackground {
    
    // MARK: Private properties
    
    private lazy var tableView: UITableView = .init(frame: CGRect.zero, style: .insetGrouped)
    
    private lazy var continueButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(asset: Asset.Colors.Auth.continueButton)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = false
        button.setTitle("Продолжить", for: .normal)
        button.addTarget(self, action: #selector(didTapContimueButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var changeScreenTypeButton: UIButton = {
        let button = UIButton()
        button.tintColor = .none
        button.setTitleColor(UIColor(asset: Asset.Colors.Placeholder.placeholderColor), for: .normal)
        button.addTarget(self, action: #selector(didTapChangeScreenTypeButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: Public properties
    
    var output: AuthViewOutput?
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.items?.forEach { $0.isEnabled = false }
        view.backgroundColor = UIColor(asset: Asset.Colors.Background.brightColor)
        title = output?.title()
        setupView()
    }
    
    private func setupView() {
        view.addSubview(continueButton)
        view.addSubview(changeScreenTypeButton)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        navigationItem.setHidesBackButton(true, animated: false)
        changeScreenTypeButton.setTitle(output?.buttonName(), for: .normal)
        
        setupTableView()
        makeConstraints()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self

        tableView.allowsSelection = false
        tableView.backgroundColor = backgroundView.backgroundColor
        tableView.separatorColor = tableView.backgroundColor
        registerCell()
    }
    
    private func registerCell() {
        tableView.register(AccountInfoCell.self, forCellReuseIdentifier: "AccountInfoCell")
    }

    private func makeConstraints() {
        tableView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(150)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        continueButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(20)
            make.top.equalTo(tableView.snp.bottom).offset(10)
            make.height.equalTo(50)
        }
        
        changeScreenTypeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(120)
            make.top.equalTo(continueButton.snp.bottom).offset(30)
            make.height.equalTo(30)
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc
    private func didTapContimueButton() {
        output?.didTapContinueButton()
    }
    
    @objc
    private func didTapChangeScreenTypeButton() {
        output?.didTapChangeScreenTypeButton()
    }
}

extension AuthViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return
    }
}

extension AuthViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.Cells.height
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        output?.numberOfRows(in: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AccountInfoCell",
                                                       for: indexPath) as? AccountInfoCell else {
            return UITableViewCell()
        }
        let displayData = output?.displayData(for: indexPath)
        if let displayData {
            cell.configure(data: displayData)
        }
        cell.separatorInset = UIEdgeInsets.zero
        if indexPath.section == 0 {
            cell.selectionStyle = .none
        }
        return cell
    }
}

extension AuthViewController: AuthViewInput {
    func showTabbar() {
        tabBarController?.tabBar.items?.forEach { $0.isEnabled = true }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        present(alert, animated: true)
    }
    
    func getCellsValues() {
        guard let emailCell = tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? AccountInfoCell
        else { return }
        guard let passwordCell = tableView.cellForRow(at: IndexPath(item: 1, section: 0)) as? AccountInfoCell
        else { return }
        output?.setCellsValues(email: emailCell.getTextFieldValue(), password: passwordCell.getTextFieldValue())
    }
}
private extension AuthViewController {
    enum Constants {
        static let backgroundColor = UIColor(asset: Asset.Colors.Background.dimColor)
        static let tableViewHorizontalInsets: CGFloat = 20
        enum Cells {
            static let cornerRadius: CGFloat = 15
            static let height: CGFloat = 52
        }
    }
}

