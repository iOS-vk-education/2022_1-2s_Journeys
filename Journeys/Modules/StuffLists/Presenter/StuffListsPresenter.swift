//
//  StuffListsPresenter.swift
//  Journeys
//
//  Created by Nastya Ischenko on 07/05/2023.
//

import Foundation
import UIKit

// MARK: - StuffListsPresenter

final class StuffListsPresenter {
    // MARK: - Public Properties

    weak var view: StuffListsViewInput?
    weak var moduleOutput: StuffListsModuleOutput?
    private let model: StuffListsModelInput
    
    private var stuffLists: [StuffList] = []
    
    private var isDataLoaded: Bool = false

    init(model: StuffListsModelInput) {
        self.model = model
    }
}

extension StuffListsPresenter: StuffListsModuleInput {
}

extension StuffListsPresenter: StuffListsViewOutput {
    func viewDidAppear() {
        model.obtainStuffLists()
        view?.reloadData()
    }
    
    func didTapBackBarButton() {
        moduleOutput?.closeStuffListsModule()
    }
    
    func didSelectCell(at indexPath: IndexPath) {
        guard stuffLists.count > indexPath.row else { return }
        moduleOutput?.openCertainStuffListModule(for: stuffLists[indexPath.row])
    }
    
    func cellsCount(for section: Int) -> Int {
        if isDataLoaded {
            return stuffLists.count
        }
        return stuffLists.count == 0 ? 5 : stuffLists.count
    }
    
    func cellData(for indexPath: IndexPath) -> StuffListCell.Displaydata? {
        guard stuffLists.count > indexPath.row else { return nil }
        return StuffListCell.Displaydata(stuffListData: StuffListCell.StuffListData(title: stuffLists[indexPath.row].name,
                                         roundColor: stuffLists[indexPath.row].color.toUIColor()),
                                         cellType: .usual)
    }
    
    func didTapNewStuffListButton() {
        moduleOutput?.openCertainStuffListModule(for: nil)
    }
}

extension StuffListsPresenter: StuffListsModelOutput {
    func didReceiveStuffLists(_ stuffLists: [StuffList]) {
        self.stuffLists = stuffLists
        isDataLoaded = true
        view?.reloadData()
    }
    
    func didReceiveError(_ error: Error) {
        
    }
}
