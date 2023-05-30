//
//  StuffListsViewController.swift
//  Journeys
//
//  Created by Nastya Ischenko on 07/05/2023.
//

import UIKit

// MARK: - StuffListsViewController

final class StuffListsViewController: AlertShowingViewController {
    
    // MARK: Private properties
    private lazy var collectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
       return UICollectionView(frame: .zero, collectionViewLayout: layout)
   }()
    private var placeholderView = UIView()
    
    private lazy var newStuffListFloatingButton: FloatingButton = {
        let button = FloatingButton()
        button.backgroundColor = UIColor(asset: Asset.Colors.BaseColors.contrastToThemeColor)
        button.configure(title: L10n.newStuffList)
        button.addTarget(self, action: #selector(didTapNewStuffListButton), for: .touchUpInside)
        view.addSubview(button)
        return button
    }()

    // MARK: Public properties
    var output: StuffListsViewOutput?

    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(asset: Asset.Colors.Background.brightColor)
        placeholderView.isHidden = true
        setupNavBar()
        setupCollectionView()
        makeConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        newStuffListFloatingButton.isHidden = true
        output?.viewWillAppear()
    }

    private func setupNavBar() {
        navigationController?.navigationBar.tintColor = UIColor(asset: Asset.Colors.Text.mainTextColor)
        navigationItem.setHidesBackButton(true, animated: false)
        let buttonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(didTapBackButton))
        
        navigationItem.leftBarButtonItem = buttonItem
        title = L10n.stuffLists
    }

    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor(asset: Asset.Colors.Background.dimColor)
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 60, right: 0)

        collectionView.register(StuffListCell.self,
                                forCellWithReuseIdentifier: "StuffListCell")
    }

    private func makeConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        newStuffListFloatingButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(Constants.NewStuffListFloatingaButton.bottonInset)
            make.width.equalToSuperview().inset(Constants.NewStuffListFloatingaButton.horisontslInsets)
            make.height.equalTo(Constants.NewStuffListFloatingaButton.height)
        }
    }
    
    @objc
    private func didTapBackButton() {
        output?.didTapBackBarButton()
    }
    
    @objc
    func didTapNewStuffListButton() {
        output?.didTapNewStuffListButton()
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension StuffListsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width - 30 * 2, height: 42)
    }
}

// MARK: UICollectionViewDelegate
extension StuffListsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        output?.didSelectCell(at: indexPath)
    }
}

extension StuffListsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        output?.cellsCount(for: section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        guard let stuffListCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "StuffListCell",
            for: indexPath
        ) as? StuffListCell else {
            return cell
        }
        
        if let data = output?.cellData(for: indexPath) {
            stuffListCell.configure(data: data)
        }
        return stuffListCell
    }
}

extension StuffListsViewController: StuffListsViewInput {
    func reloadData() {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    func setCollectionViewAllowsSelection(to value: Bool) {
        collectionView.allowsSelection = value
    }
    
    func showNewStuffListButton() {
        newStuffListFloatingButton.isHidden = false
    }
    
    func setCheckmarkVisibility(to value: Bool, at indexPath: IndexPath) {
        guard let stuffListCell = collectionView.cellForItem(at: indexPath) as? StuffListCell else { return }
        stuffListCell.setCheckmarkVisibility(to: value)
    }
}


extension StuffListsViewController {
    func embedPlaceholder() {
        let placeholderViewController = PlaceholderViewController()

        guard placeholderView.isHidden == true else {
            return
        }
        placeholderViewController
            .configure(with: PlaceholderViewController.DisplayData(title: L10n.noStuffLists,
                                                                   imageName: "StuffListsPlaceholder"))
        addChild(placeholderViewController)
        placeholderViewController.didMove(toParent: self)
        placeholderView = placeholderViewController.view
        collectionView.addSubview(placeholderView)
        placeholderView.isHidden = false
        placeholderView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
        }
    }
    
    func hidePlaceholder() {
        placeholderView.isHidden = true
    }
}

private extension StuffListsViewController {
    enum Constants {
        enum NewStuffListFloatingaButton {
            static let bottonInset: CGFloat = 20
            static let horisontslInsets: CGFloat = 30
            static let height: CGFloat = 40
        }
    }
}
