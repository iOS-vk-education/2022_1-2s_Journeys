//
//  RouteViewIO.swift
//  Journeys
//
//  Created by Nastya Ischenko on 17/11/2022.
//

import Foundation
import UIKit


// MARK: - Route ViewInput

protocol RouteViewInput: AnyObject {
    func showAlert(title: String, message: String)
    func reloadData()
    func showImagePicker()
}

// MARK: - Route ViewOutput

protocol RouteViewOutput: AnyObject {
    func viewDidLoad()
    
    func numberOfSectins() -> Int
    func numberOfRowsInSection (section: Int) -> Int
    func getImageCellDisplayData() -> UIImage
    func getDisplayData(for indexpath: IndexPath) -> RouteCell.DisplayData?
    
    func didTapExitButton()
    func didTapFloatingSaveButton()
    func didSelectRow(at indexpath: IndexPath) -> ((RouteViewController, UITableView)->())?
    func userWantsToDeleteCell(indexPath: IndexPath) -> ((UITableView, IndexPath) -> [UITableViewRowAction]?)?
    
    func setTripImage(_ image: UIImage)
}
