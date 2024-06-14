//
//  Event.swift
//  Event Countdown
//
//  Created by Almoutasem on 14/06/2024.
//
import SwiftUI

struct Event: Identifiable, Comparable, Codable {
    let id: UUID
    var title: String
    var date: Date
    var textColor: Color

    static func < (lhs: Event, rhs: Event) -> Bool {
        lhs.date < rhs.date
    }

    enum CodingKeys: String, CodingKey {
        case id, title, date, textColor
    }

    init(id: UUID, title: String, date: Date, textColor: Color) {
        self.id = id
        self.title = title
        self.date = date
        self.textColor = textColor
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        date = try container.decode(Date.self, forKey: .date)
        let colorData = try container.decode(Data.self, forKey: .textColor)
        if let uiColor = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(colorData) as? UIColor {
            textColor = Color(uiColor)
        } else {
            textColor = .black
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(date, forKey: .date)
        let uiColor = UIColor(textColor)
        let colorData = try NSKeyedArchiver.archivedData(withRootObject: uiColor, requiringSecureCoding: false)
        try container.encode(colorData, forKey: .textColor)
    }
}
