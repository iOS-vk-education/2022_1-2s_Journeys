//
//  AccountViewController.swift
//  Journeys
//
//  Created by Nastya Ischenko on 07/12/2022.
//

import UIKit

// MARK: - AccountViewController

final class AccountViewController: UIViewController {

    var output: AccountViewOutput!

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension AccountViewController: AccountViewInput {
}