//
//  AccountInfoViewController.swift
//  Journeys
//
//  Created by Nastya Ischenko on 07/12/2022.
//

import UIKit

// MARK: - AccountViewController

final class AccountInfoViewController: AlertShowingViewController {
    
    // MARK: Private properties
    
    let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(asset: Asset.Colors.Background.dimColor)
        return view
    }()
    
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
    
    private let loadingView = LoadingView()
    
    // MARK: public properties
    
    var output: AccountInfoViewOutput?
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()
        title = L10n.accountInfo
        setupView()
    }
    
    // MARK: Public functions
    
    func reload() {
        output?.viewDidLoad()
    }
    
    // MARK: Private properties
    
    private func setupView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        view.backgroundColor = UIColor(asset: Asset.Colors.Background.brightColor)
        
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
        tableView.isScrollEnabled = false
        tableView.sectionFooterHeight = 0
        tableView.sectionHeaderHeight = Constants.TableView.sectionHeaderHeight
        
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableView.tableHeaderView = UIView(frame: frame)
        registerCell()
    }
    
    private func registerCell() {
        tableView.register(AccountInfoCell.self, forCellReuseIdentifier: "AccountInfoCell")
    }
    
    private func makeConstraints() {
        view.addSubview(backgroundView)
        view.addSubview(tableView)
        view.addSubview(saveFloatingButton)
        view.addSubview(exitButton)
        view.addSubview(deleteAccountButton)
        
        backgroundView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        var tableViewHeight: CGFloat = tableView.tableHeaderView?.frame.height ?? 0
        for section in 0..<tableView.numberOfSections {
            tableViewHeight += CGFloat(tableView.numberOfRows(inSection: section)) * Constants.Cells.height
            tableViewHeight += Constants.TableView.sectionHeaderHeight
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(Constants.TableView.topInset)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(tableViewHeight)
        }
        
        exitButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(tableView.snp.bottom).offset(Constants.ExitButton.topOffsetFromTableView)
            make.width.equalTo(Constants.ExitButton.width)
            make.height.equalTo(Constants.ExitButton.height)
        }
        
        deleteAccountButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(exitButton.snp.bottom).offset(Constants.DeleteAccountButton.topOffsetFromTableView)
            make.width.equalTo(Constants.DeleteAccountButton.width)
            make.height.equalTo(Constants.DeleteAccountButton.height)
        }
        
        saveFloatingButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(Constants.SaveFloatingaButton.bottonInset)
            make.width.equalToSuperview().inset(Constants.SaveFloatingaButton.horisontslInsets)
            make.height.equalTo(Constants.SaveFloatingaButton.height)
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
    
    func showPasswordAlert(title: String?,
                           message: String,
                           textFieldPlaceholder: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = textFieldPlaceholder
            textField.isSecureTextEntry = true
        }
        alert.addAction(UIAlertAction(title: L10n.cancel, style: .cancel))
        alert.addAction(UIAlertAction(title: L10n.delete, style: .destructive){ [weak self, weak alert] (_) in
            guard let textField = alert?.textFields?[0],
                  let self else { return }
            self.output?.deleteAccount(with: textField.text ?? "")
        })
        present(alert, animated: true)
    }
    
    func cellValue(for indexPath: IndexPath) -> String? {
        guard let cell = tableView.cellForRow(at: indexPath) as? AccountInfoCell
        else { return nil }
        return cell.getTextFieldValue()
    }
    
    func showLoadingView() {
        view.addSubview(loadingView)
        loadingView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        view.bringSubviewToFront(loadingView)
    }
    
    func hideLoadingView() {
        DispatchQueue.main.async { [weak self] in
            self?.loadingView.removeFromSuperview()
        }
    }
    
    func clearCellsTextFields(at indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if let cell = tableView.cellForRow(at: indexPath) as? AccountInfoCell {
                cell.clearTextField()
            }
        }
    }
}

private extension AccountInfoViewController {
    enum Constants {
        static let backgroundColor = UIColor(asset: Asset.Colors.Background.dimColor)
        enum TableView {
            static let horizontalInsets: CGFloat = 20
            static let sectionHeaderHeight: CGFloat = 50
            static let topInset: CGFloat = 10
        }
        enum Cells {
            static let cornerRadius: CGFloat = 15
            static let height: CGFloat = 52
        }
        
        enum ExitButton {
            static let topOffsetFromTableView: CGFloat = 20
            static let width: CGFloat = 120
            static let height: CGFloat = 30
        }
        enum DeleteAccountButton {
            static let topOffsetFromTableView: CGFloat = 30
            static let width: CGFloat = 200
            static let height: CGFloat = 30
        }
        enum SaveFloatingaButton {
            static let bottonInset: CGFloat = 20
            static let horisontslInsets: CGFloat = TableView.horizontalInsets * 2
            static let height: CGFloat = 40
        }
    }
}
