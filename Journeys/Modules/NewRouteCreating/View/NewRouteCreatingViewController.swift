//
//  NewRouteCreatingViewController.swift
//  Journeys
//
//  Created by Nastya Ischenko on 17/11/2022.
//

import UIKit

// MARK: - NewRouteCreatingViewController

final class NewRouteCreatingViewController: UIViewController {

    // MARK: Private properties
    private var floatingRouteBuildButton = FloatingButton()

    private lazy var tableView: UITableView = {
        UITableView(frame: CGRect.zero, style: .plain)
   }()

    // MARK: Public properties
    var output: NewRouteCreatingViewOutput!

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(asset: Asset.Colors.Background.brightColor)
        setupNavBar()
        setupCollectionView()
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
    }

    private func setupCollectionView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(asset: Asset.Colors.Background.brightColor)
        tableView.contentInset = NewRouteConstants.tableInset

        tableView.register(NewRouteCell.self,
                           forCellReuseIdentifier: "NewRouteCell")
    }

    private func makeConstraints() {
        floatingRouteBuildButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.width.equalTo(NewRouteConstants.FloatingRouteBuildButton.width)
            make.height.equalTo(NewRouteConstants.FloatingRouteBuildButton.height)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }

    @objc
    private func didTapExitButton() {
        output.didTapExitButton()
    }

    @objc
    private func didTapFavouritesButton() {
        print("Favourites button was tapped")
    }
}

extension NewRouteCreatingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let closure = output.userWantsToDeleteCell(indexPath: indexPath)
        guard let closure = closure else {
            return nil
        }
        return closure(tableView, indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let closure = output.didSelectRow(at: indexPath) else {
            return
        }
        closure(self, tableView)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        NewRouteConstants.cellsHeight
    }
}

extension NewRouteCreatingViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        output.numberOfSectins()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        output.numberOfRowsInSection(section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewRouteCell", for: indexPath) as? NewRouteCell
        else {
            assertionFailure("Error while creating cell")
            return UITableViewCell()
        }
        let displayData = output.getDisplayData(for: indexPath)
        cell.configure(displayData: displayData)
        return cell
    }
}

extension NewRouteCreatingViewController: NewRouteCreatingViewInput {
    func showAlert(title: String, message: String, actionTitle: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: nil))
    }
}


// MARK: Constants
private extension NewRouteCreatingViewController {

    struct NewRouteConstants {
        static let tableInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        static let cellsHeight: CGFloat = 47
        struct FloatingRouteBuildButton {
            static let width: CGFloat = 257.0
            static let height: CGFloat = 40.0
        }
    }
}
