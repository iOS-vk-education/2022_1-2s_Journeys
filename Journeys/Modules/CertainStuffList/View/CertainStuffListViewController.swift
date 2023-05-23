//
//  CertainStuffListViewController.swift
//  Journeys
//
//  Created by Nastya Ischenko on 07/05/2023.
//

import UIKit

// MARK: - CertainStuffListViewController

final class CertainStuffListViewController: UIViewController {

    // MARK: Private properties
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    private let stuffTableViewController = StuffTableViewController(style: .grouped)
    private lazy var stuffTableView = UITableView()
    
    private lazy var saveFloatingButton: FloatingButton = {
        let button = FloatingButton()
        button.backgroundColor = UIColor(asset: Asset.Colors.BaseColors.contrastToThemeColor)
        button.configure(title: L10n.save)
        button.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        view.addSubview(button)
        return button
    }()
    
    private let colorPicker = UIColorPickerViewController()
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(asset: Asset.Colors.Background.dimColor)
        return view
    }()

    // MARK: Public properties
    var output: CertainStuffListViewOutput?

    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()
        view.backgroundColor = UIColor(asset: Asset.Colors.Background.brightColor)
        
        setupNavBar()
        setupSubViews()
    }

    // MARK: Private methods
    private func setupNavBar() {
        navigationController?.navigationBar.tintColor = UIColor(asset: Asset.Colors.Text.mainTextColor)
        navigationItem.setHidesBackButton(true, animated: false)
        let leftButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(didTapBackButton))
        navigationItem.leftBarButtonItem = leftButtonItem
        
        let rightButtonItem = UIBarButtonItem(image: UIImage(systemName: "trash"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(didTapTrashButton))
        navigationItem.rightBarButtonItem = rightButtonItem
        title = L10n.stuffList
    }
    
    private func setupSubViews() {
        setupCollectionView()
        setupTableView()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapScreen))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        colorPicker.delegate = self
        makeConstraints()
    }

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = backgroundView.backgroundColor
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)

        collectionView.register(StuffListCell.self,
                                forCellWithReuseIdentifier: "StuffListCell")
    }
    
    private func setupTableView() {
        stuffTableView = stuffTableViewController.tableView

        stuffTableView.backgroundColor = backgroundView.backgroundColor
        stuffTableView.contentInset = UIEdgeInsets(top: .zero,
                                                   left: .zero,
                                                   bottom: 60,
                                                   right: .zero)
        
        guard let stuffTableViewControllerOutput = output as? StuffTableViewControllerOutput else { return }
        stuffTableViewController.output = stuffTableViewControllerOutput
    }
    
    private func makeConstraints() {
        view.addSubview(backgroundView)
        view.addSubview(collectionView)
        view.addSubview(stuffTableView)
        view.addSubview(saveFloatingButton)
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(70)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        stuffTableView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().inset(30)
            make.trailing.equalToSuperview().inset(30)
        }
        saveFloatingButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(Constants.SaveFloatingaButton.bottonInset)
            make.width.equalToSuperview().inset(Constants.SaveFloatingaButton.horisontslInsets)
            make.height.equalTo(Constants.SaveFloatingaButton.height)
        }
    }
    
    @objc
    private func didTapBackButton() {
        output?.didTapBackBarButton()
    }
    
    @objc
    private func didTapTrashButton() {
        output?.didTapTrashButton()
    }
    
    @objc
    private func didTapSaveButton() {
        output?.didTapSaveButton()
    }
    
    @objc
    private func didTapScreen() {
        output?.didTapScreen(tableView: stuffTableView)
//        view.endEditing(true)
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension CertainStuffListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width - 30 * 2, height: 42)
    }
}

// MARK: UICollectionViewDelegate
extension CertainStuffListViewController: UICollectionViewDelegate {
}

extension CertainStuffListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
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
        
        guard let data = output?.cellData(for: indexPath) else {
            return cell
        }
        stuffListCell.configure(data: data)
        return stuffListCell
    }
}

extension CertainStuffListViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        output?.didPickColor(color: viewController.selectedColor)
    }
}

extension CertainStuffListViewController: CertainStuffListViewInput {
    func reloadData() {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
            self?.stuffTableView.reloadData()
        }
    }
    func reloadTableView() {
        stuffTableView.reloadData()
    }
    
    func showColorPicker(selectedColor: UIColor) {
        colorPicker.selectedColor = selectedColor
        present(colorPicker, animated: true)
    }
    
    func changeStuffListCellColoredViewColor(to color: UIColor, at indexPath: IndexPath) {
        guard let stuffListCell = collectionView.cellForItem(at: indexPath) as? StuffListCell else { return }
        stuffListCell.changeColoredViewColor(to: color)
    }
    
    func tableViewBackgroundColor() -> UIColor? {
        stuffTableView.backgroundColor
    }
    
    func getCollectionCellData(for indexPath: IndexPath) -> StuffListCell.StuffListData? {
        guard let cell = collectionView.cellForItem(at: indexPath) as? StuffListCell else {
            return nil
        }
        return cell.getCellData()
    }
    
    func getTableCell(for indexpath: IndexPath) -> UITableViewCell? {
        stuffTableView.cellForRow(at: indexpath)
    }
    
    func getTableCellsData(from indexPath: IndexPath) -> StuffCell.StuffData? {
        guard let cell = stuffTableView.cellForRow(at: indexPath) as? StuffCell else {
            return nil
        }
        return cell.getData()
    }
    
    func moveTableViewRow(at fromIndexPath: IndexPath, to toIndexPath: IndexPath) {
        stuffTableView.moveRow(at: fromIndexPath, to: toIndexPath)
    }
    
    func deleteCell(at indexPath: IndexPath) {
        stuffTableView.beginUpdates()
        stuffTableView.deleteRows(at: [indexPath], with: .automatic)
        stuffTableView.endUpdates()
    }
    
    func showAlert(title: String, message: String) {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
            self?.present(alert, animated: true, completion: nil)
        }
    }
}

private extension CertainStuffListViewController {
    enum Constants {
        enum SaveFloatingaButton {
            static let bottonInset: CGFloat = 20
            static let horisontslInsets: CGFloat = 30
            static let height: CGFloat = 40
        }
    }
}
