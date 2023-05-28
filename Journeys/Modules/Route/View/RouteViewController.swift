//
//  RouteViewController.swift
//  Journeys
//
//  Created by Nastya Ischenko on 17/11/2022.
//

import UIKit

// MARK: - RouteViewController

final class RouteViewController: AlertShowingViewController {

    // MARK: Private properties
    private var floatingRouteBuildButton = FloatingButton()

    private lazy var tableView: UITableView = {
        UITableView(frame: CGRect.zero, style: .plain)
   }()

    private let loadingView = LoadingView()
    
    // MARK: Public properties
    var output: RouteViewOutput!

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewDidLoad()
        view.backgroundColor = UIColor(asset: Asset.Colors.Background.brightColor)
        setupNavBar()
        setupTableView()
        setupFloatingAddButton()
        makeConstraints()
    }

    private func setupNavBar() {
        navigationController?.navigationBar.tintColor = UIColor(asset: Asset.Colors.Text.mainTextColor)

        let exitButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"),
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(didTapExitButton))

        navigationItem.leftBarButtonItem = exitButtonItem
        title = L10n.newRoute
    }

    private func setupFloatingAddButton() {
        view.addSubview(floatingRouteBuildButton)
        view.bringSubviewToFront(floatingRouteBuildButton)
        floatingRouteBuildButton.configure(title: L10n.buildRoute)
        floatingRouteBuildButton.addTarget(self, action: #selector(didTapFloatingSaveButton), for: .touchUpInside)
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(asset: Asset.Colors.Background.brightColor)
        tableView.contentInset = RouteConstants.tableInset

        tableView.register(RouteCell.self,
                           forCellReuseIdentifier: "RouteCell")
        tableView.register(ImageRouteCell.self,
                           forCellReuseIdentifier: "ImageRouteCell")
        
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }

    private func makeConstraints() {
        floatingRouteBuildButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
            make.width.equalTo(RouteConstants.FloatingRouteBuildButton.width)
            make.height.equalTo(RouteConstants.FloatingRouteBuildButton.height)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        view.bringSubviewToFront(loadingView)
    }

    @objc
    private func didTapFloatingSaveButton() {
        output.didTapFloatingSaveButton()
    }

    @objc
    private func didTapExitButton() {
        output.didTapExitButton()
    }
}

extension RouteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let closure = output.userWantsToDeleteCell(indexPath: indexPath)
        guard let closure = closure else {
            return nil
        }
        return closure(tableView, indexPath)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let closure = output.didSelectRow(at: indexPath) else {
            return
        }
        closure(self, tableView)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 140
        }
        return RouteConstants.cellsHeight
    }
}

extension RouteViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        output.numberOfSectins()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        output.numberOfRowsInSection(section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let imageCell = tableView.dequeueReusableCell(withIdentifier: "ImageRouteCell",
                                                                for: indexPath) as? ImageRouteCell
            else {
                assertionFailure("Error while creating cell")
                return UITableViewCell()
            }
            let displayData = output.getDisplayData(for: indexPath)
            imageCell.configure(image: output.getImageCellDisplayData())
            imageCell.selectionStyle = .none
            return imageCell
        }
        
        guard let routeCell = tableView.dequeueReusableCell(withIdentifier: "RouteCell",
                                                            for: indexPath) as? RouteCell
        else {
            assertionFailure("Error while creating cell")
            return UITableViewCell()
        }
        guard let displayData = output.getDisplayData(for: indexPath) else { return UITableViewCell()}
        routeCell.configure(displayData: displayData)
        return routeCell
    }
}

extension RouteViewController: RouteViewInput {
    func changeTabbarAvailibility(to value: Bool) {
        tabBarController?.tabBar.items?.forEach { $0.isEnabled = value }
    }
    
    func showImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        presentImagePicker(imagePicker: imagePicker)
    }
    
    func reloadData() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
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
}

extension RouteViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func presentImagePicker(imagePicker: UIImagePickerController) {
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ImageRouteCell
            cell?.configure(image: editedImage)
            output.setTripImage(editedImage)
        }
        dismiss(animated: true)
    }
}


// MARK: Constants
private extension RouteViewController {

    struct RouteConstants {
        static let tableInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        static let cellsHeight: CGFloat = 47
        struct FloatingRouteBuildButton {
            static let width: CGFloat = 257.0
            static let height: CGFloat = 40.0
        }
    }
}
