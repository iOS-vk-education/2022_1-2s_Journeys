//
//  AddNewLocationPresenter.swift
//  Journeys
//
//  Created by Nastya Ischenko on 22/11/2022.
//

import Foundation

// MARK: - AddNewLocationPresenter

final class AddNewLocationPresenter {
    // MARK: - Public Properties

    weak var view: AddNewLocationViewInput!
    weak var moduleOutput: AddNewLocationModuleOutput!

}

extension AddNewLocationPresenter: AddNewLocationModuleInput {
}

extension AddNewLocationPresenter: AddNewLocationViewOutput {
    func didTapExitButton() {
        moduleOutput.addNewLoctionModuleWantsToClose()

    }
    
    func didTapDoneButton() {
        print("didTapDoneButton")
    }
    
    func getDisplayData(for indexpath: IndexPath) -> AddNewLocationCell.DisplayData {
        return AddNewLocationCell.DisplayData(location: "location")
    }
    
    func didSelectCell(at indexpath: IndexPath) {
        return
    }
    
}
