//
//  Date+Extensions.swift
//  Gizmo
//
//  Created by Nayanda Haberty on 27/07/22.
//

import Foundation

// MARK: Date

public extension Date {
    
    /// true if the date is considered as now. The error tolerable is +- 1 miliSeconds from actual Date now
    @inlinable var isNow: Bool {
        abs(self.timeLeft(to: Date())) < 1.miliSeconds
    }
    
    @inlinable var isPast: Bool {
        Date() > self
    }
    
    @inlinable var isFuture: Bool {
        Date() < self
    }
    
    /// Returns `true` if the given date is within today, as defined by the gregorian calendar and calendar's locale.
    /// - Parameter timeZone: The time zone of the calendar, default will be current
    /// - Returns: `true` if its today
    @inlinable func isToday(timeZone: TimeZone = .current) -> Bool {
        Calendar(timeZone: timeZone).isDateInToday(self)
    }
    
    /// Returns `true` if the given date is within yesterday, as defined by the gregorian calendar and calendar's locale.
    /// - Parameter timeZone: The time zone of the calendar, default will be current
    /// - Returns: `true` if its yesterday
    @inlinable func isYesterday(timeZone: TimeZone = .current) -> Bool {
        Calendar(timeZone: timeZone).isDateInYesterday(self)
    }
    
    /// Returns `true` if the given date is within tomorrow, as defined by the gregorian calendar and calendar's locale.
    /// - Parameter timeZone: The time zone of the calendar, default will be current
    /// - Returns: `true` if its tomorrow
    @inlinable func isTomorrow(timeZone: TimeZone = .current) -> Bool {
        Calendar(timeZone: timeZone).isDateInTomorrow(self)
    }
    
    /// Returns clock second value from the current Date, as defined by the gregorian calendar and calendar's locale.
    /// - Parameter timeZone: The time zone of the calendar, default will be current
    /// - Returns: Clock second value
    @inlinable func clockSecond(timeZone: TimeZone = .current) -> Int? {
        Calendar(timeZone: timeZone).dateComponents([.second], from: self).second
    }
    
    /// Returns clock minute value from the current Date, as defined by the gregorian calendar and calendar's locale.
    /// - Parameter timeZone: The time zone of the calendar, default will be current
    /// - Returns: Clock minute value
    @inlinable func clockMinute(timeZone: TimeZone = .current) -> Int? {
        Calendar(timeZone: timeZone).dateComponents([.minute], from: self).minute
    }
    
    /// Returns clock hour value from the current Date, as defined by the gregorian calendar and calendar's locale.
    /// - Parameter timeZone: The time zone of the calendar, default will be current
    /// - Returns: Clock hour value
    @inlinable func clockHour(timeZone: TimeZone = .current) -> Int? {
        Calendar(timeZone: timeZone).dateComponents([.hour], from: self).hour
    }
    
    /// Returns clock hour value from the current Date in form of 12 hours format, as defined by the gregorian calendar and calendar's locale.
    /// - Parameter timeZone: The time zone of the calendar, default will be current
    /// - Returns: Clock hour value in 12 hours format
    @inlinable func clockHour12(timeZone: TimeZone = .current) -> AMPM? {
        guard let hour = clockHour(timeZone: timeZone) else { return nil }
        if hour < 12 {
            return .am(hour)
        } else {
            return .pm(hour == 12 ? 12 : hour - 12)
        }
    }
    
    /// Returns calendar date from the current Date, as defined by the calendar based identifier and calendar's locale.
    /// - Parameters:
    ///   - identifier: Identifier of the calendar. eg: gregorian. Default value is gregorian
    ///   - timeZone: The time zone of the calendar, default will be current
    /// - Returns: Calendar date
    @inlinable func calendarDate(identifier: Calendar.Identifier = .gregorian, timeZone: TimeZone = .current) -> Int? {
        Calendar(identifier: identifier, timeZone: timeZone).dateComponents([.day], from: self).day
    }
    
    /// Returns day from the current Date, as defined by the gregorian calendar and calendar's locale.
    /// - Parameter timeZone: The time zone of the calendar, default will be current
    /// - Returns: Current day from the `Date`
    @inlinable func calendarDay(timeZone: TimeZone = .current) -> Day? {
        guard let day = Calendar(timeZone: timeZone).dateComponents([.weekday], from: self).weekday else { return nil }
        return Day(rawValue: day)
    }
    
    /// Returns month from the current Date, as defined by the gregorian calendar and calendar's locale.
    /// - Parameter timeZone: The time zone of the calendar, default will be current
    /// - Returns: Current month from the `Date`
    @inlinable func calendarMonth(timeZone: TimeZone = .current) -> Month? {
        guard let day = Calendar(timeZone: timeZone).dateComponents([.month], from: self).month else { return nil }
        return Month(rawValue: day)
    }
    
    /// Returns calendar year from the current Date, as defined by the calendar based identifier and calendar's locale.
    /// - Parameters:
    ///   - identifier: Identifier of the calendar. eg: gregorian. Default value is gregorian
    ///   - timeZone: The time zone of the calendar, default will be current
    /// - Returns: Calendar year
    @inlinable func calendarYear(identifier: Calendar.Identifier = .gregorian, timeZone: TimeZone = .current) -> Int? {
        Calendar(identifier: identifier, timeZone: timeZone).dateComponents([.year], from: self).year
    }
    
    @inlinable func isGregorianLeapYear(timeZone: TimeZone = .current) -> Bool {
        guard let year = calendarYear(timeZone: timeZone) else { return false }
        return year % 400 == 0 || year % 100 == 0 || year % 4 == 0
    }
    
    /// Return time left from this date to another date
    /// It will be negative if another date is less than this date
    /// - Parameter other: other date
    /// - Returns: time left to other date
    @inlinable func timeLeft(to other: Date) -> TimeInterval {
        other.timeIntervalSinceReferenceDate - timeIntervalSinceReferenceDate
    }
    
    /// Convert date to given string format
    /// Formatting is using default DateFormatter from Swift
    /// Please refer to those classes for more information
    /// - Parameter format: Date string format
    /// - Parameter timeZone: timezone used, it will use NSTimeZone.default defaultly
    /// - Returns: Formatted String from this Date
    @inlinable func dateString(_ format: String, timeZone: TimeZone = .current) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

public extension Date {
    /// Initialize date from String with a given format
    /// It will produce nil if fail
    /// Formatting is using default DateFormatter from Swift
    /// Please refer to those classes for more information
    /// - Parameters:
    ///   - string: string with the given format
    ///   - format: Date string format
    ///   - timeZone: timezone used, it will use NSTimeZone.default defaultly
    @inlinable init?(_ string: String, format: String, timeZone: TimeZone = .current) {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone
        dateFormatter.dateFormat = format
        guard let date = dateFormatter.date(from: string) else { return nil }
        self = date
    }
}

// MARK: Date Enum

public extension Date {
    /// Day in gregorian Calendar
    enum Day: Int {
        case sunday = 1
        case monday = 2
        case tuesday = 3
        case wednesday = 4
        case thursday = 5
        case friday = 6
        case saturday = 7
    }
    
    /// Month in gregorian Calendar
    enum Month: Int {
        case january = 1
        case february = 2
        case march = 3
        case april = 4
        case may = 5
        case june = 6
        case july = 7
        case august = 8
        case september = 9
        case october = 10
        case november = 11
        case december = 12
    }
    
    /// 12 Hour clock format
    enum AMPM: Hashable {
        case am(Int)
        case pm(Int)
    }
}

// MARK: Calendar

public extension Calendar {
    
    /// Init Calendar with given time zone
    /// - Parameters:
    ///   - identifier: Identifier of the calendar. eg: gregorian. Default value is gregorian
    ///   - timeZone: The time zone of the calendar
    @inlinable init(identifier: Calendar.Identifier = .gregorian, timeZone: TimeZone) {
        var calendar = Calendar(identifier: identifier)
        calendar.timeZone = timeZone
        self = calendar
    }
}
