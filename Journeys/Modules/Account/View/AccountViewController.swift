//
//  AccountViewController.swift
//  Journeys
//
//  Created by Nastya Ischenko on 18/03/2023.
//

import UIKit
import SnapKit

// MARK: - AccountViewController

final class AccountViewController: ViewControllerWithDimBackground {

    // MARK: Private properties

    private lazy var tableView: UITableView = .init(frame: CGRect.zero, style: .insetGrouped)
    
    private let avatarImageView = UIImageView()
    private let avatarPlaceholderView = AvatarPlaceholderView()
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.text = output?.username()
        label.font = .systemFont(ofSize: 17)
        label.textColor = UIColor(asset: Asset.Colors.Text.mainTextColor)
        label.textAlignment = .center
        return label
    }()

    var output: AccountViewOutput?

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output?.viewWillAppear()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.height / 2
        avatarPlaceholderView.layer.cornerRadius = avatarPlaceholderView.bounds.height / 2
//        avatarImageView.image?.size = CGSize(width: 24, height: 24)
    }
    
    // MARK: Public methods
    
    func showImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        presentImagePicker(imagePicker: imagePicker)
    }

    // MARK: Private methods

    private func setupView() {
        view.backgroundColor = UIColor(asset: Asset.Colors.Background.brightColor)
        title = L10n.account
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapScreen))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)

        setupSubviews()
    }
    
    private func setupSubviews() {
        let tapRecognizer = UITapGestureRecognizer(target: self,
                                                   action: #selector(didTapAvatarImageView))
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(tapRecognizer)
        avatarImageView.layer.masksToBounds = true
        
        avatarPlaceholderView.showSkeleton()
        
        setupTableView()
        setupConstrains()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        tableView.backgroundColor = backgroundView.backgroundColor
        tableView.separatorColor = tableView.backgroundColor
        
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableView.tableHeaderView = UIView(frame: frame)
        tableView.isScrollEnabled = false
        
        registerCell()
    }

    private func setupConstrains() {
        view.addSubview(tableView)
        view.addSubview(avatarPlaceholderView)
        view.addSubview(avatarImageView)
        view.addSubview(userNameLabel)
        
        var tableViewHeight: CGFloat = tableView.tableHeaderView?.frame.height ?? 0
        for section in 0..<tableView.numberOfSections {
            tableViewHeight += CGFloat(tableView.numberOfRows(inSection: section)) * Constants.Cells.height
        }
        
        tableView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(tableViewHeight)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        avatarImageView.snp.makeConstraints { make in
            make.bottom.equalTo(userNameLabel.snp.top).offset(-10)
            make.centerX.equalToSuperview()
            make.height.equalTo(100)
            make.width.equalTo(100)
        }
        avatarPlaceholderView.snp.makeConstraints { make in
            make.bottom.equalTo(avatarImageView.snp.bottom)
            make.centerX.equalTo(avatarImageView.snp.centerX)
            make.height.equalTo(avatarImageView.snp.height)
            make.width.equalTo(avatarImageView.snp.width)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.bottom.equalTo(tableView.snp.top).offset(-15)
            make.centerX.equalToSuperview()
            make.width.lessThanOrEqualToSuperview().inset(40)
        }
    }

    private func registerCell() {
        tableView.register(SettingsCell.self, forCellReuseIdentifier: SettingsCell.reuseIdentifier)
    }
    
    private func setImageView(image: UIImage?) {
        avatarImageView.image = image
        if let image {
            self.avatarPlaceholderView.isHidden = true
        } else {
            self.avatarPlaceholderView.isHidden = false
        }
    }
    
    @objc
    private func didTapAvatarImageView() {
        showAvatarActionSheet()
    }
    
    @objc
    private func didTapScreen() {
        dismiss(animated: true)
    }
}

// MARK: UITableViewDelegate

extension AccountViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        output?.didSelectCell(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: UITableViewDataSource

extension AccountViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.Cells.height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        output?.numberOfRows(in: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        Constants.tableViewSectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.reuseIdentifier,
                                                       for: indexPath) as? SettingsCell else {
            return UITableViewCell()
        }
        let displayData = output?.displayData(for: indexPath)
        if let displayData {
            cell.configure(displayData: displayData)
        }
        cell.separatorInset = UIEdgeInsets.zero
        if indexPath.section == 0 {
            cell.selectionStyle = .none
        }
        return cell
    }
}

extension AccountViewController: AccountViewInput {
    func reloadView() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
            self?.userNameLabel.text = self?.output?.username()
        }
    }
    
    func setImageView(image: UIImage?, didFinishLoading: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            if !didFinishLoading {
                self.avatarPlaceholderView.showSkeleton()
            }
            if image == nil {
                self.avatarPlaceholderView.hideSkeleton()
            }
            self.setImageView(image: image)
        }
    }
    
    func deselectCell(_ indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func showAvatarActionSheet() {
        let alert = UIAlertController(title: nil, message: nil,
                                      preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Обновить", style: .default) { [weak self] _ in
            self?.showImagePicker()
        })
        alert.addAction(UIAlertAction(title: "Удалить аватарку", style: .destructive) { [weak self] _ in
            self?.output?.deleteAvatar()
        })
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel) { [weak self] _ in
            self?.dismiss(animated: true)
        })
        present(alert, animated: true)
    }
}

extension AccountViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func presentImagePicker(imagePicker: UIImagePickerController) {
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ImageRouteCell
            cell?.configure(image: editedImage)
            setImageView(image: editedImage)
            output?.setAvatar(editedImage)
        }
        dismiss(animated: true)
    }
}

private extension AccountViewController {
    enum Constants {
        static let backgroundColor = UIColor(asset: Asset.Colors.Background.dimColor)
        static let tableViewHorizontalInsets: CGFloat = 20
        static let tableViewSectionHeaderHeight: CGFloat = 80
        enum Cells {
            static let cornerRadius: CGFloat = 15
            static let height: CGFloat = 52
        }
    }
}
