// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum L10n {
  /// Добавить
  public static var add: String { return L10n.tr("Localizable", "Add") }
  /// Добавление маршрута
  public static var addingTown: String { return L10n.tr("Localizable", "AddingTown") }
  /// Добавить город
  public static var addTown: String { return L10n.tr("Localizable", "AddTown") }
  /// Город прибытия
  public static var arrivalTown: String { return L10n.tr("Localizable", "ArrivalTown") }
  /// Некоторые поля не заполнены
  public static var blanckFields: String { return L10n.tr("Localizable", "BlanckFields") }
  /// Построить маршрут
  public static var buildRoute: String { return L10n.tr("Localizable", "BuildRoute") }
  /// Страна
  public static var country: String { return L10n.tr("Localizable", "Country") }
  /// Валюта
  public static var currency: String { return L10n.tr("Localizable", "Currency") }
  /// Удалить
  public static var delete: String { return L10n.tr("Localizable", "Delete") }
  /// Город отправления
  public static var departureTown: String { return L10n.tr("Localizable", "DepartureTown") }
  /// Редактировать
  public static var edit: String { return L10n.tr("Localizable", "Edit") }
  /// Мероприятия
  public static var events: String { return L10n.tr("Localizable", "Events") }
  /// Заполните поля страны и города
  public static var fillTheCountryAndTownFields: String { return L10n.tr("Localizable", "FillTheCountryAndTownFields") }
  /// Поддержка
  public static var help: String { return L10n.tr("Localizable", "Help") }
  /// Информация
  public static var information: String { return L10n.tr("Localizable", "Information") }
  /// Путешествия
  public static var journeys: String { return L10n.tr("Localizable", "Journeys") }
  /// Язык
  public static var language: String { return L10n.tr("Localizable", "Language") }
  /// Почта
  public static var mail: String { return L10n.tr("Localizable", "Mail") }
  /// Новый маршрут
  public static var newRoute: String { return L10n.tr("Localizable", "NewRoute") }
  /// Нет метео данных для выбранных городов или дат
  public static var noMeteoDataForPlacesOrDates: String { return L10n.tr("Localizable", "NoMeteoDataForPlacesOrDates") }
  /// Не выбрано мест пребывания
  public static var noSelectedPlaces: String { return L10n.tr("Localizable", "NoSelectedPlaces") }
  /// Уведомления
  public static var notifications: String { return L10n.tr("Localizable", "Notifications") }
  /// Пока что маршрутов нет
  public static var noTrips: String { return L10n.tr("Localizable", "NoTrips") }
  /// Собрано
  public static var packed: String { return L10n.tr("Localizable", "Packed") }
  /// Общая информация
  public static var placeInfo: String { return L10n.tr("Localizable", "PlaceInfo") }
  /// Оценить приложение
  public static var rateApp: String { return L10n.tr("Localizable", "RateApp") }
  /// Маршрут
  public static var route: String { return L10n.tr("Localizable", "Route") }
  /// Выберите даты
  public static var selectDates: String { return L10n.tr("Localizable", "SelectDates") }
  /// Настройки
  public static var settings: String { return L10n.tr("Localizable", "Settings") }
  /// Вещи
  public static var stuff: String { return L10n.tr("Localizable", "Stuff") }
  /// Список вещей
  public static var stuffList: String { return L10n.tr("Localizable", "StuffList") }
  /// Оформление
  public static var style: String { return L10n.tr("Localizable", "Style") }
  /// Телеграм
  public static var telegram: String { return L10n.tr("Localizable", "Telegram") }
  /// Город
  public static var town: String { return L10n.tr("Localizable", "Town") }
  /// Поездки
  public static var trips: String { return L10n.tr("Localizable", "Trips") }
  /// Не собрано
  public static var unpacked: String { return L10n.tr("Localizable", "Unpacked") }
  /// Погода
  public static var weather: String { return L10n.tr("Localizable", "Weather") }
  /// Чтобы включить уведомления, разрешите их для приложения Journeys в настройках устройства (Настройки → Journeys → Уведомления → Допуск уведомлений)
  public static var youNeetToTurnTheApplicationNotificationOn: String { return L10n.tr("Localizable", "YouNeetToTurnTheApplicationNotificationOn") }

  public enum Style {
    /// Темная тема
    public static var dark: String { return L10n.tr("Localizable", "style.dark") }
    /// Светлая тема
    public static var light: String { return L10n.tr("Localizable", "style.light") }
    /// Как в системе
    public static var system: String { return L10n.tr("Localizable", "style.system") }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = LocalizationSystem.sharedInstance.localizedString(key, table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}
