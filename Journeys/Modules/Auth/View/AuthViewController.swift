//
//  AuthViewController.swift
//  Journeys
//
//  Created by Nastya Ischenko on 25/12/2022.
//

import UIKit

// MARK: - AuthViewController

final class AuthViewController: UIViewController {
    

    var output: AuthViewOutput!
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        return collection
    }()
    
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
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(asset: Asset.Colors.Background.dimColor)
        return view
    }()

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.items?.forEach { $0.isEnabled = false }
        view.backgroundColor = UIColor(asset: Asset.Colors.Background.brightColor)
        title = output.getTitle()
        setupView()
    }
    
    private func setupView() {
        view.addSubview(backgroundView)
        view.addSubview(continueButton)
        view.addSubview(changeScreenTypeButton)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        navigationItem.setHidesBackButton(true, animated: false)
        changeScreenTypeButton.setTitle(output.getButtonName(), for: .normal)
        
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
        backgroundView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        let height = output.getCellsCount() * 60
        collectionView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(height)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        continueButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(20)
            make.top.equalTo(collectionView.snp.bottom).offset(10)
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
        output.didTapContinueButton()
    }
    
    @objc
    private func didTapChangeScreenTypeButton() {
        output.didTapChangeScreenTypeButton()
    }
}

extension AuthViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.layer.frame.width - 40, height: 50)
    }
}

extension AuthViewController: UICollectionViewDataSource {
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
        guard let emailCell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? AccountCell
        else { return }
        guard let passwordCell = collectionView.cellForItem(at: IndexPath(item: 1, section: 0)) as? AccountCell
        else { return }
        output.setCellsValues(email: emailCell.getTextFieldValue(), password: passwordCell.getTextFieldValue())
    }
}

