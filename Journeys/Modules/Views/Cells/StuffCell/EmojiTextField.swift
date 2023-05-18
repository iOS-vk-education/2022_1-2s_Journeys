//
//  EmojiTextField.swift
//  Journeys
//
//  Created by Сергей Адольевич on 19.12.2022.
//

import Foundation
import UIKit

class EmojiTextField: UITextField {
    override var textInputMode: UITextInputMode? {
        for mode in UITextInputMode.activeInputModes {
            if mode.primaryLanguage == "emoji" {
                return mode
            }
        }
        return nil
    }
}
