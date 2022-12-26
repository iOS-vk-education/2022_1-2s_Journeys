//
//  AccountViewController.swift
//  Journeys
//
//  Created by Nastya Ischenko on 07/12/2022.
//

import UIKit

// MARK: - AccountViewController

final class AccountViewController: UIViewController {
    
    var output: AccountViewOutput!
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        if let email: String = output.getUserEmail() {
            label.text = "Текущий Email: \(email)"
        }
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        return collection
    }()
    
    private lazy var saveFloatingButton: FloatingButton = {
        let button = FloatingButton()
        button.backgroundColor = UIColor(asset: Asset.Colors.BaseColors.contrastToThemeColor)
        button.configure(title: "Сохранить")
        button.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var exitButton: UIButton = {
        let button = UIButton()
        button.tintColor = .none
        button.setTitleColor(UIColor(asset: Asset.Colors.Placeholder.placeholderColor), for: .normal)
        button.setTitle("Выход", for: .normal)
        button.addTarget(self, action: #selector(didTapExitButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(asset: Asset.Colors.Background.dimColor)
        title = "Аккаунт"
        setupView()
    }
    
    private func setupView() {
        view.addSubview(emailLabel)
        view.addSubview(saveFloatingButton)
        view.addSubview(exitButton)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        navigationItem.setHidesBackButton(true, animated: false)
        
        setupCollectionView()
        makeConstraints()
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = UIColor(asset: Asset.Colors.Background.dimColor)

        collectionView.register(AccountCell.self,
                                forCellWithReuseIdentifier: "AccountCell")

    }

    private func makeConstraints() {
        let height = output.getCellsCount() * 60
        collectionView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(height)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        emailLabel.snp.makeConstraints { make in
//            make.top.equalToSuperview().inset(100)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(collectionView.snp.top).offset(-30)
        }
        
        exitButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(120)
            make.top.equalTo(collectionView.snp.bottom).offset(20)
            make.height.equalTo(30)
        }
        
        saveFloatingButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc
    private func didTapSaveButton() {
        output.didTapSaveButton()
    }
    
    @objc
    private func didTapExitButton() {
        output.didTapExitButton()
    }
}

extension AccountViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.layer.frame.width - 40, height: 50)
    }
}

extension AccountViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        output.getCellsCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AccountCell",
                                                               for: indexPath) as? AccountCell else {
            return UICollectionViewCell()
        }
        guard let data = output.getCellsDisplaydata(for: indexPath) else {
            return UICollectionViewCell()
        }
        cell.configure(data: data)
        return cell
    }
}

extension AccountViewController: AccountViewInput {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        present(alert, animated: true)
    }
    
    func getCellsValues() {
        guard let newEmailCell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? AccountCell
        else { return }
        guard let passwordCell = collectionView.cellForItem(at: IndexPath(item: 1, section: 0)) as? AccountCell
        else { return }
        guard let newPasswordCell = collectionView.cellForItem(at: IndexPath(item: 2, section: 0)) as? AccountCell
        else { return }
        output.setCellsValues(newEmail: newEmailCell.getTextFieldValue(),
                              password: passwordCell.getTextFieldValue(),
                              newPassword: newPasswordCell.getTextFieldValue())
    }
}
