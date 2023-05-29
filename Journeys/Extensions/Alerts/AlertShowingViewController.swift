//
//  AlertShowingViewController.swift
//  Journeys
//
//  Created by Сергей Адольевич on 28.05.2023.
//

import Foundation
import UIKit

protocol AlertShowProtocol: AnyObject {
    func showDisappearingAlert(title: String?, message: String)
    func showAlertWithActions(title: String?, message: String, actions: [UIAlertAction])
}

class AlertShowingViewController: UIViewController {
}

extension AlertShowingViewController: AlertShowProtocol {
    func showDisappearingAlert(title: String?, message: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let alert = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: .alert)
            // Кол-во секунд необходимое для прочтения текста
            let words = "\(title ?? "") \(message)".components(separatedBy: " ").filter { !$0.isEmpty }
            var timeToShow: Double = Double(words.count) * 0.35
            if timeToShow < 1.0 {
                timeToShow = 1.0
            }
            
            self.present(alert, animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + timeToShow) { [weak self] in
                UIView.animate(withDuration: 0.5) {
                    self?.dismiss(animated: true)
                }
            }
        }
    }
    
    func showAlertWithActions(title: String?, message: String, actions: [UIAlertAction]) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let alert = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: .alert)
            if actions.isEmpty {
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
            } else {
                for action in actions {
                    alert.addAction(action)
                }
            }
            self.present(alert, animated: true)
        }
    }
}
