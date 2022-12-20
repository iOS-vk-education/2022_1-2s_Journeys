// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum L10n {
  /// Аккаунт
  public static let account = L10n.tr("Localizable", "Account")
  /// Добавить
  public static let add = L10n.tr("Localizable", "Add")
  /// Изменить
  public static let change = L10n.tr("Localizable", "Change")
  /// Удалить
  public static let delete = L10n.tr("Localizable", "Delete")
  /// Редактировать
  public static let edit = L10n.tr("Localizable", "Edit")
  /// Мероприятия
  public static let events = L10n.tr("Localizable", "Events")
  /// Путешествия
  public static let journeys = L10n.tr("Localizable", "Journeys")
  /// Собрано
  public static let packed = L10n.tr("Localizable", "Packed")
  /// Общая информация
  public static let placeInfo = L10n.tr("Localizable", "PlaceInfo")
  /// Список вещей
  public static let stuffList = L10n.tr("Localizable", "StuffList")
  /// Поездки
  public static let trips = L10n.tr("Localizable", "Trips")
  /// Не собрано
  public static let unpacked = L10n.tr("Localizable", "Unpacked")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
