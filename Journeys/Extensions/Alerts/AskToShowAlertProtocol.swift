//
//  AlertShowProtocols.swift
//  Journeys
//
//  Created by Сергей Адольевич on 28.05.2023.
//

import Foundation
import UIKit

protocol AskToShowAlertProtocol: AnyObject {
}

extension AskToShowAlertProtocol {
    func askToShowErrorAlert(_ error: Errors, alertShowingVC: AlertShowingViewController) {
        switch error {
        case .obtainDataError:
            alertShowingVC.showDisappearingAlert(title: L10n.error, message: L10n.Alerts.Messages.errorWhileObtainingData)
        case .saveDataError:
            alertShowingVC.showDisappearingAlert(title: L10n.error,
                                                 message: L10n.Alerts.Messages.errorWhileSavingData)
        case .deleteDataError:
            alertShowingVC.showDisappearingAlert(title: L10n.error,
                                                 message: L10n.Alerts.Messages.errorWhileDeletingData)
        case let .custom(title: title, message: message):
            alertShowingVC.showDisappearingAlert(title: title,
                                                 message: message)
        default:
            break
        }
    }
    
    func askToShowAlertWithOKAction(_ error: Errors,
                                    alertShowingVC: AlertShowingViewController,
                                    handler: ((UIAlertAction) -> Void)?) {
        var actions: [UIAlertAction] = []
        if let handler {
            actions.append(UIAlertAction(title: "Ok", style: .default, handler: handler))
        }
        switch error {
        case .obtainDataError:
            alertShowingVC.showAlertWithActions(title: L10n.error,
                                                message: L10n.Alerts.Messages.errorWhileObtainingData,
                                                actions: actions)
        case .saveDataError:
            alertShowingVC.showAlertWithActions(title: L10n.error,
                                                 message: L10n.Alerts.Messages.errorWhileSavingData,
                                                actions: actions)
        case .deleteDataError:
            alertShowingVC.showAlertWithActions(title: L10n.error,
                                                 message: L10n.Alerts.Messages.errorWhileDeletingData,
                                                actions: actions)
        case let .custom(title: title, message: message):
            alertShowingVC.showAlertWithActions(title: title,
                                                 message: message,
                                                actions: actions)
        default:
            break
        }
    }
    
}
