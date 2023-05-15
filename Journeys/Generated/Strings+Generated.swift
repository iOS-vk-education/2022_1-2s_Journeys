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
  /// Добавление маршрута
  public static let addingTown = L10n.tr("Localizable", "AddingTown")
  /// Поиск адреса
  public static let addressSearch = L10n.tr("Localizable", "AddressSearch")
  /// Добавить город
  public static let addTown = L10n.tr("Localizable", "AddTown")
  /// Кв/офис
  public static let apartmentOffice = L10n.tr("Localizable", "Apartment/office")
  /// Город прибытия
  public static let arrivalTown = L10n.tr("Localizable", "ArrivalTown")
  /// Начало
  public static let begin = L10n.tr("Localizable", "Begin")
  /// Построить маршрут
  public static let buildRoute = L10n.tr("Localizable", "BuildRoute")
  /// Изменить
  public static let change = L10n.tr("Localizable", "Change")
  /// Создание мероприятия
  public static let createEvent = L10n.tr("Localizable", "CreateEvent")
  /// Удалить
  public static let delete = L10n.tr("Localizable", "Delete")
  /// Город отправления
  public static let departureTown = L10n.tr("Localizable", "DepartureTown")
  /// Описание мероприятия
  public static let descriptionOfTheEvent = L10n.tr("Localizable", "Description of the event")
  /// ГОТОВО
  public static let done = L10n.tr("Localizable", "DONE")
  /// Редактировать
  public static let edit = L10n.tr("Localizable", "Edit")
  /// Конец
  public static let end = L10n.tr("Localizable", "End")
  /// Введите адрес
  public static let enterTheAdress = L10n.tr("Localizable", "Enter the adress")
  /// Ошибка
  public static let error = L10n.tr("Localizable", "Error")
  /// Название мероприятия
  public static let eventName = L10n.tr("Localizable", "Event Name")
  /// Мероприятия
  public static let events = L10n.tr("Localizable", "Events")
  /// Этаж
  public static let floor = L10n.tr("Localizable", "Floor")
  /// Путешествия
  public static let journeys = L10n.tr("Localizable", "Journeys")
  /// Ссылка на источник
  public static let linkToTheSource = L10n.tr("Localizable", "Link to the source")
  /// Новый маршрут
  public static let newRoute = L10n.tr("Localizable", "NewRoute")
  /// Собрано
  public static let packed = L10n.tr("Localizable", "Packed")
  /// Фотография
  public static let photo = L10n.tr("Localizable", "Photo")
  /// Общая информация
  public static let placeInfo = L10n.tr("Localizable", "PlaceInfo")
  /// Список вещей
  public static let stuffList = L10n.tr("Localizable", "StuffList")
  /// Неверно указана дата или время
  public static let theDateOrTimeIsIncorrect = L10n.tr("Localizable", "The date or time is incorrect")
  /// Для создания мероприятия нужно указать более точный адрес
  public static let toCreateAnEventYouNeedToSpecifyAMorePreciseAddress = L10n.tr("Localizable", "To create an event you need to specify a more precise address")
  /// Уточните адрес
  public static let trippleTheAdress = L10n.tr("Localizable", "Tripple the adress")
  /// Поездки
  public static let trips = L10n.tr("Localizable", "Trips")
  /// Тип мероприятия
  public static let typeOfEvent = L10n.tr("Localizable", "Type of event")
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
