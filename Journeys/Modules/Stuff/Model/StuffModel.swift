//
//  StuffModel.swift
//  Journeys
//
//  Created by Nastya Ischenko on 18/12/2022.
//

// MARK: - StuffModel

final class StuffModel {
    weak var output: StuffModelOutput!
}

extension StuffModel: StuffModelInput {
    func obtainStuffData() {
        output.stuffWasObtainedData(data: [Stuff(id: "1", emoji: "🩳", name: "Шорты", isPacked: true),
                                           Stuff(id: "2", emoji: "🪥", name: "Зубная щетка", isPacked: true),
                                           Stuff(id: "3", emoji: "🪢", name: "Веревка", isPacked: false),
                                           Stuff(id: "4", emoji: "👕", name: "Футболка", isPacked: true),
                                           Stuff(id: "5", emoji: "🧼", name: "Мыло", isPacked: false),
                                           Stuff(id: "6", emoji: "🩲", name: "Нижнее белье", isPacked: true),
                                           Stuff(id: "7", emoji: "👗", name: "Платье", isPacked: false),
                                           Stuff(id: "8", emoji: "👠", name: "Обувь", isPacked: false)]
                                    )
    }
}
