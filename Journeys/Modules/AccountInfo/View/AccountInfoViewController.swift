//
//  AccountInfoViewController.swift
//  Journeys
//
//  Created by Nastya Ischenko on 07/12/2022.
//

import UIKit

// MARK: - AccountViewController

final class AccountInfoViewController: ViewControllerWithDimBackground {
    
    // MARK: Private properties
    private lazy var tableView: UITableView = .init(frame: CGRect.zero, style: .insetGrouped)
    
    private lazy var saveFloatingButton: FloatingButton = {
        let button = FloatingButton()
        button.backgroundColor = UIColor(asset: Asset.Colors.BaseColors.contrastToThemeColor)
        button.configure(title: L10n.save)
        button.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var exitButton: UIButton = {
        let button = UIButton()
        button.tintColor = .none
        button.setTitleColor(UIColor(asset: Asset.Colors.Placeholder.placeholderColor), for: .normal)
        button.setTitle(L10n.exit, for: .normal)
        button.addTarget(self, action: #selector(didTapExitButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var deleteAccountButton: UIButton = {
        let button = UIButton()
        button.tintColor = .none
        button.setTitleColor(.red, for: .normal)
        button.setTitle(L10n.deleteAccount, for: .normal)
        button.addTarget(self, action: #selector(didTapDeleteAccountButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: public properties
    
    var output: AccountInfoViewOutput?
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()
        title = L10n.accountInfo
        setupView()
    }
    
    private func setupView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)

        
        setupNavBar()
        setupTableView()
        makeConstraints()
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.tintColor = UIColor(asset: Asset.Colors.Text.mainTextColor)
        navigationItem.setHidesBackButton(true, animated: false)
        
        let buttonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(didTapBackButton))
        
        navigationItem.leftBarButtonItem = buttonItem
    }
    
    private func setupTableView() {
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
        view.addSubview(tableView)
        view.addSubview(saveFloatingButton)
        view.addSubview(exitButton)
        view.addSubview(deleteAccountButton)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(380)
        }
        
        exitButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(120)
            make.top.equalTo(tableView.snp.bottom).offset(30)
            make.height.equalTo(30)
        }
        
        deleteAccountButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.top.equalTo(exitButton.snp.bottom).offset(20)
            make.height.equalTo(30)
        }
        
        saveFloatingButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(Constants.tableViewHorizontalInsets)
            make.bottom.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc
    private func didTapBackButton() {
        output?.didTapBackBarButton()
    }
    
    @objc
    private func didTapSaveButton() {
        output?.didTapSaveButton()
    }
    
    @objc
    private func didTapExitButton() {
        output?.didTapExitButton()
    }
    
    @objc
    private func didTapDeleteAccountButton() {
        output?.didTapDeleteAccountButton()
    }
}

extension AccountInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return
    }
}

extension AccountInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        output?.header(for: section)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.Cells.height
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        output?.numberOfSections() ?? 0
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

extension AccountInfoViewController: AccountInfoViewInput {
    func reloadData() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        present(alert, animated: true)
    }
    
    func cellsValues(from section: Int) {
        guard let newEmailCell = tableView.cellForRow(at: IndexPath(item: 0, section: section)) as? AccountInfoCell
        else { return }
        guard let passwordCell = tableView.cellForRow(at: IndexPath(item: 1, section: section)) as? AccountInfoCell
        else { return }
        guard let newPasswordCell = tableView.cellForRow(at: IndexPath(item: 2, section: section)) as? AccountInfoCell
        else { return }
        output?.setCellsValues(newEmail: newEmailCell.getTextFieldValue(),
                               password: passwordCell.getTextFieldValue(),
                               newPassword: newPasswordCell.getTextFieldValue())
    }
}

private extension AccountInfoViewController {
    enum Constants {
        static let backgroundColor = UIColor(asset: Asset.Colors.Background.dimColor)
        static let tableViewHorizontalInsets: CGFloat = 20
        enum Cells {
            static let cornerRadius: CGFloat = 15
            static let height: CGFloat = 52
        }
    }
}
