//
//  DateExtension.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 13.04.2025.
//

import Foundation

extension Date {
    func toLocalString(format: String = "dd-MM-yyyy HH:mm") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = .current // Текущий часовой пояс пользователя
        return formatter.string(from: self)
    }
    
    func toServerFormat(format: String = "dd-MM-yyyy HH:mm") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = TimeZone.current // Часовой пояс пользователя
        return formatter.string(from: self)
    }
    
//    func formattedCustom() -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "d MMMM yyyy HH:mm"
//        formatter.timeZone = TimeZone(secondsFromGMT: 0) // Или твой нужный
//        return formatter.string(from: self)
//    }
}

extension String {
    /// Преобразует строку, полученную с сервера (в час. поясе сервера), в локальный `Date`
    func toLocalDateFromServer(
        format: String = "dd-MM-yyyy HH:mm",
        serverTimeZone: TimeZone = TimeZone(identifier: "Europe/London")!
    ) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = serverTimeZone
        return formatter.date(from: self) // Date — всегда UTC внутри
    }
//    func toDate(serverFormat: String = "dd-MM-yyyy HH:mm",
//                serverTimeZone: TimeZone = TimeZone(identifier: "Europe/London")!) -> Date? {
//
//        let formatter = DateFormatter()
//        formatter.dateFormat = serverFormat
//        formatter.timeZone = serverTimeZone
//        
//        // Парсим дату (в часовом поясе сервера)
//        guard let serverDate = formatter.date(from: self) else {
//            return nil
//        }
//        // Конвертируем в локальное время
//        let localTimeZone = TimeZone.current
//        let secondsFromGMT = localTimeZone.secondsFromGMT(for: serverDate)
//        let localDate = serverDate.addingTimeInterval(TimeInterval(secondsFromGMT))
//        
//        return localDate
//    }
}
