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
    
    private lazy var viewTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    private lazy var tableView: UITableView = .init(frame: CGRect.zero, style: .insetGrouped)
    
    private lazy var continueButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(asset: Asset.Colors.Auth.continueButton)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = false
        button.setTitle("Продолжить", for: .normal)
        button.addTarget(self, action: #selector(didTapContinueButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var changeScreenTypeButton: UIButton = {
        let button = UIButton()
        button.tintColor = .none
        button.setTitleColor(UIColor(asset: Asset.Colors.Placeholder.placeholderColor), for: .normal)
        button.addTarget(self, action: #selector(didTapChangeScreenTypeButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var resetPasswordButton: UIButton = {
        let button = UIButton()
        button.tintColor = .none
        button.setTitleColor(.red, for: .normal)
        button.setTitle(L10n.resetPassword, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.addTarget(self, action: #selector(didTapResetPasswordButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: Public properties
    
    var output: AuthViewOutput?
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()
        tabBarController?.tabBar.items?.forEach { $0.isEnabled = false }
        view.backgroundColor = UIColor(asset: Asset.Colors.Background.brightColor)
        addSubViews()
        setupView()
    }
    
    // MARK: Private properties
    private func addSubViews() {
        view.addSubview(viewTitle)
        view.addSubview(tableView)
        view.addSubview(continueButton)
        view.addSubview(changeScreenTypeButton)
        view.addSubview(resetPasswordButton)
    }
    
    private func setupView() {
        viewTitle.text = output?.title()
        viewTitle.textAlignment = .center
        viewTitle.textColor = UIColor(asset: Asset.Colors.Text.mainTextColor)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        changeScreenTypeButton.setTitle(output?.buttonName(), for: .normal)
        
        setupTableView()
        makeConstraints()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        tableView.isScrollEnabled = false
        tableView.allowsSelection = false
        tableView.backgroundColor = backgroundView.backgroundColor
        tableView.separatorColor = tableView.backgroundColor
        tableView.sectionFooterHeight = 0
        tableView.sectionHeaderHeight = 0
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableView.tableHeaderView = UIView(frame: frame)
        registerCell()
    }
    
    private func registerCell() {
        tableView.register(AccountInfoCell.self, forCellReuseIdentifier: "AccountInfoCell")
    }

    private func makeConstraints() {
        
        viewTitle.snp.makeConstraints { make in
            make.bottom.equalTo(tableView.snp.top).offset(-Constants.Title.bottomIndent)
            make.centerX.equalToSuperview()
            make.height.equalTo(Constants.Title.height)
            make.width.equalToSuperview()
        }
        
        var tableViewHeight: CGFloat = tableView.tableHeaderView?.frame.height ?? 0
        for section in 0..<tableView.numberOfSections {
            tableViewHeight += CGFloat(tableView.numberOfRows(inSection: section)) * Constants.Cells.height
        }
        tableView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(Constants.TableView.verticalIndent)
            make.height.equalTo(tableViewHeight)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        resetPasswordButton.snp.makeConstraints { make in
            make.trailing.equalTo(tableView.snp.trailing)
            make.width.equalTo(Constants.ResetPasswordButton.width)
            make.top.equalTo(tableView.snp.bottom).offset(Constants.ResetPasswordButton.topIndent)
            make.height.equalTo(Constants.ResetPasswordButton.height)
        }
        
        continueButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(Constants.ContinueButton.horisontalIndent)
            make.trailing.equalToSuperview().inset(Constants.ContinueButton.horisontalIndent)
            make.top.equalTo(tableView.snp.bottom).offset(Constants.ContinueButton.topIndent)
            make.height.equalTo(Constants.ContinueButton.height)
        }
        
        changeScreenTypeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(Constants.ChangeModuleTypeButton.width)
            make.top.equalTo(continueButton.snp.bottom).offset(Constants.ChangeModuleTypeButton.topIndent)
            make.height.equalTo(Constants.ChangeModuleTypeButton.height)
        }
    }
    
    
    private func prepareForReload() {
        viewTitle.snp.removeConstraints()
        tableView.snp.removeConstraints()
        continueButton.snp.removeConstraints()
        changeScreenTypeButton.snp.removeConstraints()
        resetPasswordButton.snp.removeConstraints()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc
    private func didTapContinueButton() {
        output?.didTapContinueButton()
    }
    
    @objc
    private func didTapChangeScreenTypeButton() {
        output?.didTapChangeScreenTypeButton()
    }
    
    @objc
    private func didTapResetPasswordButton() {
        output?.didTapResetPasswordButton()
    }
}

extension AuthViewController: UITableViewDelegate {
}

extension AuthViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.Cells.height
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
    func reload() {
        DispatchQueue.main.async { [weak self] in
            self?.prepareForReload()
            self?.output?.viewDidLoad()
            self?.tableView.reloadData()
            self?.setupView()
        }
    }
    
    func hideResetPasswordButton() {
        resetPasswordButton.isHidden = true
    }
    
    func showResetPasswordButton() {
        resetPasswordButton.isHidden = false
    }
    
    func showTabbar() {
        tabBarController?.tabBar.items?.forEach { $0.isEnabled = true }
    }
    
    func showAlert(title: String,
                   message: String,
                   textFieldPlaceholder: String? = nil) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        if let textFieldPlaceholder {
            alert.addTextField { (textField) in
                textField.placeholder = textFieldPlaceholder
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alert.addAction(UIAlertAction(title: "Next", style: .default){ [weak self, weak alert] (_) in
                guard let textField = alert?.textFields?[0],
                      let self else { return }
                self.output?.emailForReset(textField.text)
            })
        } else {
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
        }
        present(alert, animated: true)
    }
    
    func cellsValues() {
        guard let newEmailCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? AccountInfoCell
        else { return }
        guard let passwordCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? AccountInfoCell
        else { return }
        let confirmPasswordCell = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? AccountInfoCell
        output?.authData(email: newEmailCell.getTextFieldValue(),
                         password: passwordCell.getTextFieldValue(),
                         confirmPassword: confirmPasswordCell?.getTextFieldValue())
    }
}
private extension AuthViewController {
    enum Constants {
        enum Title {
            static let bottomIndent: CGFloat = 30
            static let height: CGFloat = 30
        }
        
        enum TableView {
            static let horizontalInsets: CGFloat = 20
            static let verticalIndent: CGFloat = -50
            static let height: CGFloat = 225
        }
        enum Cells {
            static let cornerRadius: CGFloat = 15
            static let height: CGFloat = 52
        }
        
        enum ContinueButton {
            static let horisontalIndent: CGFloat = TableView.horizontalInsets
            static let topIndent: CGFloat = 30
            static let height: CGFloat = 50
        }
        enum ChangeModuleTypeButton {
            static let topIndent: CGFloat = 30
            static let width: CGFloat = 180
            static let height: CGFloat = 30
        }
        enum ResetPasswordButton {
            static let topIndent: CGFloat = 5
            static let width: CGFloat = 180
            static let height: CGFloat = 20
        }
    }
}

