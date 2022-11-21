//
//  JourneysColors.swift
//  Journeys
//
//  Created by Анастасия Ищенко on 07.11.2022.
//

import UIKit

// MARK: - JourneysColors

// Палитра цветов
struct JourneysColors {}

extension JourneysColors {
    func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
        UIColor(dynamicProvider: {
            $0.userInterfaceStyle == .dark ? dark : light
        })
    }
    
}

// Все палитры
extension JourneysColors {
    enum Dynamic {
        
        /** Базовые цвета (n1/n2) */
        public enum BaseColors {
            /** Белый на всетлой теме, черный на темной(n2/n1) */
            public static var similarToTheme: UIColor {
                UIColor.journeys.dynamicColor(light: UIColor.journeys.n2, dark: UIColor.journeys.n1)
            }
            /** Черный на всетлой теме, белый на темной(n1/n2)  */
            public static var contrsstToTheme: UIColor {
                UIColor.journeys.dynamicColor(light: UIColor.journeys.n1, dark: UIColor.journeys.n2)
            }
        }
        
        /** Текст */
        public enum Text {
            /** Основной текст(n1/n2) */
            public static var mainTextColor: UIColor {
                UIColor.journeys.dynamicColor(light: UIColor.journeys.n1, dark: UIColor.journeys.n2)
            }
        }
        
        /** Иконки (n1/n2) */
        public enum Icons {
            /** Иконки(n1/n2) */
            public static var iconsColor: UIColor {
                UIColor.journeys.dynamicColor(light: UIColor.journeys.n1, dark: UIColor.journeys.n2)
            }
            /** Нажатые иконки(????) */
            public static var tappedIconsColor: UIColor {
                UIColor.journeys.dynamicColor(light: UIColor.journeys.n12, dark: UIColor.journeys.n11)
            }
        }
        
        /** Фон  */
        public enum Background {
            /** Белый/черный фон (n2/n1)>  */
            public static var lightColor: UIColor {
                UIColor.journeys.dynamicColor(light: UIColor.journeys.n2, dark: UIColor.journeys.n1)
            }
            /** Светло серый/темно серый фон (n3/n4)>  */
            public static var grayColor: UIColor {
                UIColor.journeys.dynamicColor(light: UIColor.journeys.n3, dark: UIColor.journeys.n4)
            }
        }
        /** Цвет выделения текста  (n3/n4) */
        public static var highliteColor: UIColor {
            UIColor.journeys.dynamicColor(light: .journeys.n3, dark: .journeys.n4)
        }

        /** Цвет кнопок(n1/n1) */
        public static var buttons: UIColor {
            UIColor.journeys.dynamicColor(light: UIColor.journeys.n1, dark: UIColor.journeys.n1)
        }


        public enum PlaceholderCell {
            /** PlaceholderCell  / placeholder(n10/n10) */
            public static var placeholder: UIColor {
                UIColor.journeys.dynamicColor(light: UIColor.journeys.n10, dark: UIColor.journeys.n10)
            }

            /** PlaceholderCell/ cellBorder(n11/n12) */
            public static var cellBorder: UIColor {
                UIColor.journeys.dynamicColor(light: UIColor.journeys.n11, dark: UIColor.journeys.n12)
            }
        }
       
        public enum Weather {
            /** Weatherl / sunny(n9/n10) */
            public static var sunny = UIColor.journeys.n6

            /** Weather/ cloudy(n7/n7) */
            public static var cloudy = UIColor.journeys.n7
            
            /** Weather/ rainy(n8/n8) */
            public static var rainy = UIColor.journeys.n8
            
            /** Weather / thunderstorm(n9/n9) */
            public static var thunderstorm = UIColor.journeys.n9
        }
    }
}

extension JourneysColors {
    /**
      Цвет с идентификатором **N1**

      HEX-представление - **#000000**

      RGB-представление - **RGB(0,0,0)**

       Альфа-канал - **100%**
     */
    var n1: UIColor { UIColor.UIColorFromRGB(red: 0, green: 0, blue: 0) }

    /**
      Цвет с идентификатором **N2**

      HEX-представление - **#FFFFFF**

      RGB-представление - **RGB(255,255,255)**

       Альфа-канал - **100%**
     */
    var n2: UIColor { UIColor.UIColorFromRGB(red: 255, green: 255, blue: 255) }

    /**
      Цвет с идентификатором **N3**

      HEX-представление - **#F5F5F5**

      RGB-представление - **RGB(245,245,245)**

       Альфа-канал - **100%**
     */
    var n3: UIColor { UIColor.UIColorFromRGB(red: 245, green: 245, blue: 245) }

    /**
      Цвет с идентификатором **N4**

      HEX-представление - **#444343**

      RGB-представление - **RGB(68,67,67)**

       Альфа-канал - **100%**
     */
    var n4: UIColor { UIColor.UIColorFromRGB(red: 68, green: 67, blue: 67) }

    /**
      Цвет с идентификатором **N5**

      HEX-представление - **#313131**

      RGB-представление - **RGB(49,49,49)**

       Альфа-канал - **100%**
     */
    var n5: UIColor { UIColor.UIColorFromRGB(red: 49, green: 49, blue: 49) }

    /**
      Цвет с идентификатором **N6**

      HEX-представление - **#DDB527**

      RGB-представление - **RGB(221,181,39)**

       Альфа-канал - **100%**
     */
    var n6: UIColor { UIColor.UIColorFromRGB(red: 221, green: 181, blue: 39) }

    /**
      Цвет с идентификатором **N7**

      HEX-представление - **#8BC7FF**

      RGB-представление - **RGB(139,199,255)**

       Альфа-канал - **100%**
     */
    var n7: UIColor { UIColor.UIColorFromRGB(red: 139, green: 199, blue: 255) }

    /**
      Цвет с идентификатором **N8**

      HEX-представление - **#4358A3**

      RGB-представление - **RGB(67,68,163)**

       Альфа-канал - **100%**
     */

    var n8: UIColor { UIColor.UIColorFromRGB(red: 67, green: 68, blue: 163) }

    /**
      Цвет с идентификатором **N9**

      HEX-представление - **#0E115F**

      RGB-представление - **RGB(14,17,95)**

       Альфа-канал - **100%**
     */
    var n9: UIColor { UIColor.UIColorFromRGB(red: 14, green: 17, blue: 95) }
    
    /**
      Цвет с идентификатором **N7**

      HEX-представление - **#8E8E93**

      RGB-представление - **RGB(142,142,147)**

       Альфа-канал - **100%**
     */
    var n10: UIColor { UIColor.UIColorFromRGB(red: 142, green: 142, blue: 147) }

    /**
      Цвет с идентификатором **N8**

      HEX-представление - **#D8D8DC**

      RGB-представление - **RGB(216,216,220)**

       Альфа-канал - **100%**
     */

    var n11: UIColor { UIColor.UIColorFromRGB(red: 216, green: 216, blue: 220) }

    /**
      Цвет с идентификатором **N9**

      HEX-представление - **#7A7A7A**

      RGB-представление - **RGB(122,122,122)**

       Альфа-канал - **100%**
     */
    var n12: UIColor { UIColor.UIColorFromRGB(red: 122, green: 122, blue: 122) }
}
