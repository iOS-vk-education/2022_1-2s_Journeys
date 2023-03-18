//
//  SettingsViewController.swift
//  DrPillman
//
//  Created by puzzzik on 17/05/2022.
//

import UIKit
import SnapKit
import MessageUI

// MARK: - SettingsViewController

final class SettingsViewController: UIViewController {
    enum Section: Int, CaseIterable {
        case notifications
        case other
    }

    // MARK: Private properties

    private enum Constants {
        static let backgroundColor = UIColor(asset: Asset.Colors.Background.dimColor)
        static let tableViewHorizontalInsets: CGFloat = 20
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output?.viewWillAppear()
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
    
    private func setupNavBar() {
        navigationController?.navigationBar.tintColor = UIColor(asset: Asset.Colors.Text.mainTextColor)
        navigationItem.setHidesBackButton(true, animated: false)
        
        let buttonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(didTapBackButton))
        
        navigationItem.leftBarButtonItem = buttonItem
        title = L10n.saved
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
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func registerCell() {
        tableView.register(SettingsCell.self, forCellReuseIdentifier: "SettingsCell")
    }
    
    @objc
    private func didTapBackButton() {
        output?.didTapBackBarButton()
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
    
    func openMailView() {
        let recipientEmail = "nastyaisc@gmail.com"
        let subject = L10n.Message.theme
        let body = L10n.Message.text
        
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([recipientEmail])
            mail.setSubject(subject)
            mail.setMessageBody(body, isHTML: false)
            
            present(mail, animated: true)
        
        } else if let emailUrl = createEmailUrl(to: recipientEmail, subject: subject, body: body) {
            UIApplication.shared.open(emailUrl)
        }
    }
    private func createEmailUrl(to: String, subject: String, body: String) -> URL? {
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let yahooMail = URL(string: "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let sparkUrl = URL(string: "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let defaultUrl = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")
        
        if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
            return gmailUrl
        } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
            return outlookUrl
        } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
            return yahooMail
        } else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
            return sparkUrl
        }
        
        return defaultUrl
    }
}

extension SettingsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
