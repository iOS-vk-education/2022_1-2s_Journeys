//
//  StuffCell.swift
//  Journeys
//
//  Created by Сергей Адольевич on 19.12.2022.
//

import Foundation
import UIKit
import SnapKit


protocol StuffCellDelegate: AnyObject {
    func cellPackButtonWasTapped(at indexPath: IndexPath)
    func emojiTextFieldDidChange(_ text: String, at indexPath: IndexPath)
    func nameTextFieldDidChange(_ text: String, at indexPath: IndexPath)
    func didChangedKeyboardType(to type: StuffCell.KeyboardType)
    
    func didStartEditMode()
    func didFinishEditMode()
}

final class StuffCell: UITableViewCell {
    
    enum ChangeMode {
        case on
        case off
    }
    
    enum KeyboardType {
        case usual
        case emoji
    }
    
    struct DisplayData {
        let stuffData: StuffData
        let showPackedButton: Bool
        let backgroundColor: UIColor?
        let changeMode: ChangeMode
        
        internal init(stuffData: StuffCell.StuffData,
                      showPackedButton: Bool = true,
                      backgroundColor: UIColor? = nil,
                      changeMode: StuffCell.ChangeMode = .off) {
            self.stuffData = stuffData
            self.showPackedButton = showPackedButton
            self.backgroundColor = backgroundColor
            self.changeMode = changeMode
        }
    }
    
    struct StuffData {
        let emoji: String?
        let name: String
        let isPacked: Bool
    }

    private var nameTextField = UITextField()
    let emojiTextField = EmojiTextField()
    
    private let packButton: UIButton = {
        let button = UIButton()
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()
    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(asset: Asset.Colors.Stuff.cellSeparator)
        return view
    }()

    private var isPacked: Bool = false
    
    private var indexPath: IndexPath?
    private var delegate: StuffCellDelegate?

    required init?(coder: NSCoder) {
        super.init(coder: NSCoder())
        setupSubiews()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubiews()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        nameTextField.text = nil
        emojiTextField.text = nil
        setupSubiews()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0))
    }
    
    func resingFirstResponders() {
        emojiTextField.resignFirstResponder()
        nameTextField.resignFirstResponder()
    }
    
    func startEditMode() {
        nameTextField.isUserInteractionEnabled = true
        emojiTextField.isUserInteractionEnabled = true
        emojiTextField.becomeFirstResponder()
//        delegate?.didStartEditMode()
    }
    
    func finishEditMode() {
        resingFirstResponders()
        nameTextField.isUserInteractionEnabled = false
        emojiTextField.isUserInteractionEnabled = false
        delegate?.didFinishEditMode()
    }
    
    func getData() -> StuffData {
        StuffData(emoji: emojiTextField.text, name: nameTextField.text ?? "", isPacked: isPacked)
    }
    
    func changeIsPickedFlag() {
        isPacked.toggle()
        configureButton()
    }

    func configure(data: DisplayData, indexPath: IndexPath, delegate: StuffCellDelegate? = nil) {
        emojiTextField.text = data.stuffData.emoji
        nameTextField.text = data.stuffData.name
        isPacked = data.stuffData.isPacked
        packButton.isHidden = !data.showPackedButton
        backgroundColor = data.backgroundColor
        
        self.delegate = delegate
        self.indexPath = indexPath
        if data.changeMode == .on {
            startEditMode()
        }
        configureButton()
    }

    private func setupSubiews() {
        contentView.addSubview(nameTextField)
        contentView.addSubview(emojiTextField)
        contentView.addSubview(packButton)
        contentView.addSubview(separator)
        
        nameTextField.delegate = self
        emojiTextField.delegate = self
        nameTextField.isUserInteractionEnabled = false
        emojiTextField.isUserInteractionEnabled = false
        nameTextField.autocorrectionType = .no
        nameTextField.placeholder = "Название вещи"

        emojiTextField.addTarget(self, action: #selector(didTapEmojiTextField), for: .touchUpInside)
        emojiTextField.addTarget(self, action: #selector(emojiTextFieldDidChange), for: .editingDidEnd)
        emojiTextField.addTarget(self, action: #selector(emojiTextFieldValueChanged(_: )), for: .editingChanged)
        
        nameTextField.addTarget(self, action: #selector(didTapNameTextField), for: .touchUpInside)
        nameTextField.addTarget(self, action: #selector(nameTextFieldDidChange), for: .editingDidEnd)
        packButton.addTarget(self, action: #selector(didTapCellButton), for: .touchUpInside)
        
        packButton.isHidden = true
        makeConstraints()
    }

    private func makeConstraints() {
        emojiTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(10)
            make.height.equalTo(20)
            make.width.equalTo(24)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.bottom.equalTo(emojiTextField.snp.bottom)
            make.leading.equalTo(emojiTextField.snp.trailing).offset(12)
            make.trailing.equalTo(packButton.snp.leading).offset(-20)
        }
        
        packButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(8)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(6)
            make.width.equalTo(packButton.snp.height)
        }
        separator.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(2)
            make.bottom.equalToSuperview()
        }
    }
    
    private func configureButton() {
        if isPacked {
            packButton.setImage(UIImage(systemName: "bag.circle.fill"), for: .normal)
            packButton.tintColor = UIColor(asset: Asset.Colors.Stuff.StuffButton.stuffIsPacked)
        } else {
            packButton.setImage(UIImage(systemName: "bag.circle"), for: .normal)
            packButton.tintColor = UIColor(asset: Asset.Colors.Stuff.StuffButton.stuffIsUnpacked)
        }
    }
    
    private func switchBasedNextTextField(_ textField: UITextField) {
        switch textField {
        case emojiTextField:
            self.nameTextField.becomeFirstResponder()
        case self.nameTextField:
            finishEditMode()
            self.nameTextField.resignFirstResponder()
            break
        default:
            self.nameTextField.resignFirstResponder()
        }
    }
    
    @objc
    private func didTapEmojiTextField() {
        delegate?.didChangedKeyboardType(to: .emoji)
    }
    
    @objc
    private func didTapNameTextField() {
        delegate?.didChangedKeyboardType(to: .usual)
    }
    
    @objc
    private func emojiTextFieldDidChange() {
        guard let text = emojiTextField.text, let indexPath else { return }
        delegate?.emojiTextFieldDidChange(text, at: indexPath)
    }
    
    @objc
    private func emojiTextFieldValueChanged(_ textField: UITextField) {
        if emojiTextField.text?.count == 1 {
            switchBasedNextTextField(textField)
        }
    }
                                 
    @objc
    private func nameTextFieldDidChange() {
        guard let text = nameTextField.text, let indexPath else { return }
        delegate?.nameTextFieldDidChange(text, at: indexPath)
    }
                                 
    @objc
    private func didTapCellButton() {
        guard let indexPath else { return }
        delegate?.cellPackButtonWasTapped(at: indexPath)
    }
}

extension StuffCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textField = textField as? EmojiTextField else { return true }
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        return updatedText.count <= 1
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.switchBasedNextTextField(textField)
        return true
    }
}
