//
//  CertainStuffListBuilder.swift
//  Journeys
//
//  Created by Nastya Ischenko on 07/05/2023.
//

import UIKit

// MARK: - CertainStuffListModuleBuilder

final class CertainStuffListModuleBuilder {
    func build(stuffList: StuffList?,
               firebaseService: FirebaseServiceProtocol,
               moduleOutput: CertainStuffListModuleOutput) -> UIViewController {

        let viewController = CertainStuffListViewController()
        let model = CertainStuffListModel(firebaseService: firebaseService)
        let presenter = CertainStuffListPresenter(stuffList: stuffList,
                                                  model: model,
                                                  moduleOutput: moduleOutput)
        presenter.view = viewController
        viewController.output = presenter
        model.output = presenter

        return viewController
    }
}
