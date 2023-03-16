//
//  SettingsUsualCell.swift
//  DrPillman
//
//  Created by Сергей Адольевич on 26.09.2022.
//

import Foundation
import UIKit

// MARK: - SettingsTableViewCellDelegate

protocol SettingsCellDelegate: AnyObject {
    func switchValueWasTapped(_ value: Bool, completion: @escaping (Bool) -> Void)
    func isAlertSwitchEnabled(completion: @escaping (Bool) -> Void)
}

// MARK: - SettingsTableViewCell

final class SettingsCell: UITableViewCell {
    enum CellType: CaseIterable {
        case notifications
        case style
        case language
        case help
        case rate
    }

    struct DisplayData {
        let title: String
        let subtitle: String?
        let type: ImageType

        enum ImageType {
            case switchType(Bool)
            case chevronType
        }
        
        internal init(title: String,
                      subtitle: String? = nil,
                      type: DisplayData.ImageType) {
            self.title = title
            self.subtitle = subtitle
            self.type = type
        }
    }

    // MARK: - Private Properties

    private let title = UILabel()
    private let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.forward")
        imageView.tintColor = UIColor(asset: Asset.Colors.BaseColors.contrastToThemeColor)
        return imageView
    }()
    private let settingSwitch = UISwitch()
    private let subtitle = UILabel()
    weak var delegate: SettingsCellDelegate?

    private enum Constants {
        enum Title {
            static let leadingIndent: CGFloat = 20
        }

        enum Chevron {
            static let height: CGFloat = 18
            static let width: CGFloat = 9
            static let trailingIndent: CGFloat = 16
            static let image: UIImage? = UIImage(systemName: "chevron.forward")?
                .withTintColor(UIColor(asset: Asset.Colors.BaseColors.contrastToThemeColor)!)
        }

        enum Subtitle {
            static let trailingIndentFromChevron: CGFloat = 8
            static let fontSize: CGFloat = 15
        }

        enum Switch {
            static let height: CGFloat = 31
            static let width: CGFloat = 51
            static let trailingIndent: CGFloat = 16
        }
    }

    // MARK: Lifecycle

    required init?(coder: NSCoder) {
        super.init(coder: NSCoder())
        setupViews()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        title.text = nil
        subtitle.text = nil
        settingSwitch.isOn = false
    }

    // MARK: Private methods

    private func setupViews() {
        contentView.addSubview(title)
        contentView.addSubview(chevronImageView)
        contentView.addSubview(subtitle)
        contentView.addSubview(settingSwitch)
        settingSwitch.isHidden = true

        title.textColor = UIColor(asset: Asset.Colors.Text.mainTextColor)
        subtitle.textColor = UIColor(asset: Asset.Colors.Text.secondaryTextColor)
        subtitle.font.withSize(Constants.Subtitle.fontSize)
        settingSwitch.addTarget(self, action: #selector(switchValueWasTapped), for: .valueChanged)
        settingSwitch.preferredStyle = .automatic
        
        
        setupConstraints()
        backgroundColor = UIColor(asset: Asset.Colors.Background.brightColor)
    }
    
    private func setupSwitch() {
        delegate?.isAlertSwitchEnabled { [weak self] result in
            DispatchQueue.main.async {
                self?.settingSwitch.isEnabled = result
            }
        }
    }

    @objc
    private func switchValueWasTapped() {
        delegate?.switchValueWasTapped(settingSwitch.isOn) { [weak self] result in
            DispatchQueue.main.async {
                self?.settingSwitch.setOn(result, animated: true)
            }
        }
    }

    private func setupConstraints() {
        title.snp.makeConstraints { maker in
            maker.leading.equalToSuperview()
                .inset(Constants.Title.leadingIndent)
            maker.centerY.equalToSuperview()
        }

        chevronImageView.snp.makeConstraints { maker in
            maker.trailing.equalToSuperview()
                .inset(Constants.Chevron.trailingIndent)
            maker.centerY.equalToSuperview()
            maker.height.equalTo(Constants.Chevron.height)
            maker.width.equalTo(Constants.Chevron.width)
        }

        subtitle.snp.makeConstraints { maker in
            maker.trailing.equalTo(chevronImageView.snp.leading)
                .offset(-Constants.Subtitle.trailingIndentFromChevron)
            maker.centerY.equalToSuperview()
        }

        settingSwitch.snp.makeConstraints { maker in
            maker.trailing.equalToSuperview().inset(Constants.Switch.trailingIndent)
            maker.centerY.equalToSuperview()
            maker.height.equalTo(Constants.Switch.height)
        }
    }

    // MARK: Public methods

    func configure(displayData: DisplayData, delegate: SettingsCellDelegate) {
        title.text = displayData.title
        subtitle.text = nil
        self.delegate = delegate
        switch displayData.type {
        case .chevronType:
            settingSwitch.isHidden = true
            chevronImageView.isHidden = false
            subtitle.text = displayData.subtitle
        case .switchType(let switchValue):
            settingSwitch.isHidden = false
            chevronImageView.isHidden = true
            settingSwitch.isOn = switchValue
        }
    }
}
