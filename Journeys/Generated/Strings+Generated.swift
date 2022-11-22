// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum L10n {
  /// Добавить
  public static let add = L10n.tr("Localizable", "Add")
  /// Добавить город
  public static let addTown = L10n.tr("Localizable", "AddTown")
  /// Город прибытия
  public static let arrivalTown = L10n.tr("Localizable", "ArrivalTown")
  /// Построить маршрут
  public static let buildRoute = L10n.tr("Localizable", "BuildRoute")
  /// Удалить
  public static let delete = L10n.tr("Localizable", "Delete")
  /// Город отправления
  public static let departureTown = L10n.tr("Localizable", "DepartureTown")
  /// Редактировать
  public static let edit = L10n.tr("Localizable", "Edit")
  /// Новый маршрут
  public static let newRoute = L10n.tr("Localizable", "NewRoute")
  /// Поездки
  public static let trips = L10n.tr("Localizable", "Trips")
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
