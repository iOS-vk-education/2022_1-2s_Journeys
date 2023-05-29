//
//  AccountModelIO.swift
//  Journeys
//
//  Created by Сергей Адольевич on 20.05.2023.
//

import Foundation
import UIKit

protocol AccountModelInput: AnyObject {
    func getUserData()
    func obtainAvatar(completion: @escaping (UIImage?) -> Void)
    func storeAvatar(_ avatar: UIImage, completion: @escaping (UIImage) -> Void)
    func deleteAvatar()
}

protocol AccountModelOutput: AnyObject {
    func didObtainUserData(data: User)
    func didRecieveError(error: Errors)
    func didDeleteImage()
}
