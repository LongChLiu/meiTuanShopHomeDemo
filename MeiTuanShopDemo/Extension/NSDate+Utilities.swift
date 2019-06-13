//
//  NSDate+Utilities.swift
//  MeiTuanShopDemo
//
//  Created by 艺教星 on 2019/5/6.
//  Copyright © 2019 艺教星. All rights reserved.
//

import Foundation


let D_MINUTE = 60
let D_HOUR = 3600
let D_DAY = 86400
let D_WEEK = 604800
let D_YEAR = 31556926

let kNSDateUtilitiesFormatFullDateWithTime = "MMM d, yyyy h:mm a"
let kNSDateUtilitiesFormatFullDate = "MMM d, yyyy"
let kNSDateUtilitiesFormatShortDateWithTime = "MMM d h:mm a"
let kNSDateUtilitiesFormatShortDate = "MMM d"
let kNSDateUtilitiesFormatWeekday = "EEEE"
let kNSDateUtilitiesFormatWeekdayWithTime = "EEEE h:mm a"
let kNSDateUtilitiesFormatTime = "HH:mm"
let kNSDateUtilitiesFormatTimeWithPrefix = "'at' h:mm a"
let kNSDateUtilitiesFormatSQLDate = "yyyy-MM-dd"
let kNSDateUtilitiesFormatSQLTime = "HH:mm:ss"
let kNSDateUtilitiesFormatSQLDateWithTime = "yyyy-MM-dd HH:mm:ss"



let calendarUnit : NSCalendar.Unit = [NSCalendar.Unit.year , NSCalendar.Unit.month , NSCalendar.Unit.day , NSCalendar.Unit.weekOfMonth , NSCalendar.Unit.hour , NSCalendar.Unit.minute , NSCalendar.Unit.second , NSCalendar.Unit.weekday , NSCalendar.Unit.weekdayOrdinal]


let calendar = NSCalendar.autoupdatingCurrent


extension Date{
 
    static func currentCalendar() -> NSCalendar{
        return calendar as NSCalendar
    }
    
    //MARK: Relative Dates
    static func dateWithDaysFromNow(days:Int) -> Date{
        return Date().dateByAddingDays(dDays: days)
    }
    
    static func dateWithDaysBeforeNow(days:Int) -> Date{
        return Date().dateBySubtractingDays(dDays: days)
    }

    static func dateTomorrow()->Date{
        return Date.dateWithDaysFromNow(days: 1)
    }
    
    static func dateTodayString()->String{
        let today = Date.dateWithDaysFromNow(days: 0)
        let formatter = DateFormatter.init()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: today)
    }
    
    static func dateTomorrowString()->String{
        let today = Date.dateWithDaysFromNow(days: 1)
        let formatter = DateFormatter.init()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: today)
    }
    
    static func dateTodayString(formatterStr:String) -> String{
        let today = Date.dateWithDaysFromNow(days: 0)
        let formatter = DateFormatter()
        formatter.dateFormat = formatterStr
        return formatter.string(from: today)
    }
    
    static func dateTomorrowString(formatterStr:String) -> String{
        let today = Date.dateWithDaysFromNow(days: 1)
        let formatter = DateFormatter()
        formatter.dateFormat = formatterStr
        return formatter.string(from: today)
    }
    
    static func dateYesterday()->Date{
        return Date.dateWithDaysBeforeNow(days: 1)
    }
    
    static func dateWithHoursFromNow(dHours:Int) -> Date{
        let aTimeInterval = Int(Date().timeIntervalSinceReferenceDate) + D_HOUR * dHours
        let newDate = Date.init(timeIntervalSinceReferenceDate: TimeInterval(aTimeInterval))
        return newDate
    }
    
    static func dateWithHoursBeforeNow(dHours:Int) -> Date{
        let aTimeInterval = Date().timeIntervalSinceReferenceDate - TimeInterval(D_HOUR * dHours)
        let newDate = Date.init(timeIntervalSinceReferenceDate: aTimeInterval)
        return newDate
    }
    
    static func dateWithMinutesFromNow(dMinutes:Int) -> Date{
        let aTimeInterval = Date().timeIntervalSinceReferenceDate + TimeInterval(D_MINUTE*dMinutes);
        let newDate = Date.init(timeIntervalSinceReferenceDate: aTimeInterval)
        return newDate
    }
    
    static func dateWithMinutesBeforeNow(dMinutes:Int) -> Date{
        let aTimeInterval = Date().timeIntervalSinceReferenceDate - TimeInterval(D_MINUTE * dMinutes)
        let newDate = Date.init(timeIntervalSinceReferenceDate: aTimeInterval)
        return newDate
    }
    
    static func getDayBetween(dateOne:Date?,between another:Date?) -> Int{
        if dateOne != nil && another != nil {
            let timeDiff = another!.timeIntervalSince1970 - dateOne!.timeIntervalSince1970
            let oneDaySecs = 24*3600
            let day = Int(timeDiff)/oneDaySecs
            return day
        }
        return 0
    }
    
    
    //MARK: String Properties
    func string(Format format:String) ->String{
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func string(DateStyle dateStyle:DateFormatter.Style,timeStyle:DateFormatter.Style)->String{
        let formatter = DateFormatter()
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        return formatter.string(from: self)
    }
    
    func shortString()->String{
        return self.string(DateStyle: DateFormatter.Style.short, timeStyle: DateFormatter.Style.short)
    }
    
    func shortTimeString()->String{
        return self.string(DateStyle: DateFormatter.Style.none, timeStyle: DateFormatter.Style.short)
    }
    
    func shortDateString()->String{
        return self.string(DateStyle: DateFormatter.Style.short, timeStyle: DateFormatter.Style.none)
    }
    
    func mediumString()->String{
        return self.string(DateStyle: DateFormatter.Style.medium, timeStyle: DateFormatter.Style.medium)
    }
    
    func mediumTimeString()->String{
        return self.string(DateStyle: DateFormatter.Style.none, timeStyle: DateFormatter.Style.medium)
    }
    
    func mediumDateString()->String{
        return self.string(DateStyle: DateFormatter.Style.medium, timeStyle: DateFormatter.Style.none)
    }
    
    func longString()->String{
        return self.string(DateStyle: DateFormatter.Style.long, timeStyle: DateFormatter.Style.long)
    }
    
    func longTimeString()->String{
        return self.string(DateStyle: DateFormatter.Style.none, timeStyle: DateFormatter.Style.long)
    }
    
    func longDateString()->String{
        return self.string(DateStyle: DateFormatter.Style.long, timeStyle: DateFormatter.Style.none)
    }
    
    
    
    
    //MARK: Comparing Dates
    func isEqualToDateIgnoringTime(aDate:Date)->Bool{
        //let set:Set<NSCalendar.Unit> = calendarUnit
        var components1 = Date.currentCalendar().components(calendarUnit, from: self)
        var components2 = Date.currentCalendar().components(calendarUnit, from: aDate as Date)
        return (components1.year == components2.year) && (components1.month == components1.month) && (components1.day == components1.day)
    }
    
    func isToday()->Bool{
        return self.isEqualToDateIgnoringTime(aDate: Date())
    }
    
    func isTomorrow()->Bool{
        return self.isEqualToDateIgnoringTime(aDate: Date.dateTomorrow())
    }
    
    func isYesterday()->Bool{
        return self.isEqualToDateIgnoringTime(aDate: Date.dateYesterday())
    }
    
    //MARK: This hard codes the assumption that a week is 7 days
    func isSameWeekAsDate(aDate:Date) -> Bool{
        var components1 = Date.currentCalendar().components(calendarUnit, from: self)
        var components2 = Date.currentCalendar().components(calendarUnit, from: aDate)
        //Must be same week, 12/31 and 1/1 will both be week "1" if they are in the same week
        if components1.weekOfYear != components2.weekOfYear {
            return false
        }
        //Must have a time interval under 1 week
        return Int(fabs(self.timeIntervalSince(aDate))) < D_WEEK
    }
    
    func isThisWeek()->Bool{
        return self.isSameWeekAsDate(aDate: Date())
    }
    
    func isNextWeek()->Bool{
        let aTimeInterval = Date().timeIntervalSinceReferenceDate + TimeInterval(D_WEEK)
        let newDate = Date.init(timeIntervalSinceReferenceDate: aTimeInterval)
        return self.isSameWeekAsDate(aDate: newDate)
    }
    
    func isLastWeek()->Bool{
        let aTimeInterval = Date().timeIntervalSinceReferenceDate - TimeInterval(D_WEEK)
        let newDate = Date(timeIntervalSinceReferenceDate: aTimeInterval)
        return self.isSameWeekAsDate(aDate: newDate)
    }
    
    func isSameMonthAsDate(aDate:Date) -> Bool{
        var components1 = Date.currentCalendar().components([.year,.month], from: self)
        var components2 = Date.currentCalendar().components([.year,.month], from: aDate)
        return components1.month == components2.month && components1.year == components2.year
    }
    
    func isThisMonth()->Bool{
        return self.isSameMonthAsDate(aDate: Date())
    }
    
    func isLastMonth()->Bool{
        return self.isSameMonthAsDate(aDate: Date().dateBySubtractingDays(dDays: 1))
    }
    
    func isNextMonth()->Bool{
        return self.isSameMonthAsDate(aDate: Date().dateByAddingMonths(dMonths: 1))
    }
    
    func isSameYearAsDate(aDate:Date)->Bool{
        var component1 = Date.currentCalendar().components(NSCalendar.Unit.year, from: self)
        var component2 = Date.currentCalendar().components(NSCalendar.Unit.year, from: aDate)
        return component1.year == component2.year
    }
    
    func isThisYear()->Bool{
        return self.isSameYearAsDate(aDate: Date())
    }
    
    func isNextYear()->Bool{
        var components1 = Date.currentCalendar().components(NSCalendar.Unit.year, from: self)
        var components2 = Date.currentCalendar().components(NSCalendar.Unit.year, from: Date())
        return (components1.year == (components2.year! + 1))
    }
    
    func isLastYear()->Bool{
        var components1 = Date.currentCalendar().components(NSCalendar.Unit.year, from: self)
        var components2 = Date.currentCalendar().components(NSCalendar.Unit.year, from: Date())
        return (components1.year == (components2.year! - 1))
    }
    
    
    func isEarlierThanDate(aDate:Date) -> Bool{
        return self.compare(aDate) == ComparisonResult.orderedAscending
    }
    
    func isLaterThanDate(aDate:Date) -> Bool{
        return self.compare(aDate) == ComparisonResult.orderedDescending
    }
    
    func isInFuture()->Bool{
        return self.isLaterThanDate(aDate: Date())
    }
    
    func isInPast()->Bool{
        return self.isEarlierThanDate(aDate: Date())
    }
    
    //MARK: mark - Roles
    func isTypicallyWeekend()->Bool{
        var components = Date.currentCalendar().components(NSCalendar.Unit.weekday, from: self)
        if components.weekday == 1 || components.weekday == 7 {
            return true
        }
        return false
    }
    
    func isTypicallyWorkday()->Bool{
        return !self.isTypicallyWeekend()
    }
    
    //MARK: Adjusting Dates
    func dateByAddingYears(dYears:Int) -> Date{
        var dateComponents = DateComponents()
        dateComponents.year = dYears
        let newDate = NSCalendar.current.date(byAdding: dateComponents, to: self)
        return newDate!
    }
    
    func dateBySubtractingMonths(dMonths:Int) -> Date{
        return self.dateByAddingMonths(dMonths: -dMonths)
    }
    
    func dateByAddingMonths(dMonths:Int) -> Date{
        var dateComponents = DateComponents()
        dateComponents.month = dMonths
        let newDate = NSCalendar.current.date(byAdding: dateComponents, to: self)
        return newDate!
    }
    
    
    func dateByAddingDays(dDays:Int) -> Date{
        var dateComponents = DateComponents()
        dateComponents.day = dDays
        let newDate = NSCalendar.current.date(byAdding: dateComponents as DateComponents, to: self as Date)
        return newDate!
    }
    
    func dateBySubtractingDays(dDays:Int) -> Date{
        return self.dateByAddingDays(dDays: dDays * -1)
    }
    
    func dateByAddingHours(dHours:Int) -> Date{
        let aTimeInterval = self.timeIntervalSinceReferenceDate + TimeInterval(D_HOUR * dHours)
        let newDate = Date(timeIntervalSinceReferenceDate: aTimeInterval)
        return newDate
    }
    
    func dateBySubtractingHours(dHours:Int) -> Date{
        return self.dateByAddingHours(dHours: dHours * -1)
    }
    
    func dateByAddingMinutes(dMinutes:Int) -> Date{
        let aTimeInterval = self.timeIntervalSinceReferenceDate + TimeInterval(D_MINUTE * dMinutes)
        let newDate = Date.init(timeIntervalSinceReferenceDate: aTimeInterval)
        return newDate
    }
    
    func dateBySubtractingMinutes(dMinutes:Int) -> Date{
        return self.dateByAddingMinutes(dMinutes: dMinutes * -1)
    }
    
    func componentsWithOffsetFromDate(aDate:Date) -> DateComponents{
        let dTime = Date.currentCalendar().components(calendarUnit, from: aDate, to: self, options: NSCalendar.Options.init(rawValue: 0))
        return dTime
    }
    
    //MARK: Extremes
    func dateAtStartOfDay()->Date?{
        var components = Date.currentCalendar().components(calendarUnit, from: self)
        components.hour = 0
        components.minute = 0
        components.second = 0
        return Date.currentCalendar().date(from: components)
    }
    
    //Thanks gsempe & mteece
    func dateAtEndOfDay()->Date{
        var components = Date.currentCalendar().components(calendarUnit, from: self)
        components.hour = 23    //Thanks Aleksey Kononov
        components.minute = 59
        components.second = 59
        return Date.currentCalendar().date(from: components)!
    }
    
    
    //MARK: Retrieving Intervals
    func minutesAfterDate(aDate:Date)->Int{
        let ti = self.timeIntervalSince(aDate)
        return Int(ti) / D_MINUTE
    }
    
    func minutesBeforeDate(aDate:Date) -> Int{
        let ti = aDate.timeIntervalSince(self)
        return Int(ti) / D_MINUTE
    }
    
    
    func hoursAfterDate(aDate:Date) -> Int{
        let ti = self.timeIntervalSince(aDate)
        return Int(ti) / D_HOUR
    }
    
    func hoursBeforeDate(aDate:Date) -> Int{
        let ti = aDate.timeIntervalSince(self)
        return Int(ti) / D_HOUR
    }
    
    func daysAfterDate(aDate:Date)->Int{
        let ti = self.timeIntervalSince(aDate)
        return Int(ti) / D_DAY
    }
    
    func daysBeforeDate(aDate:Date)->Int{
        let ti = aDate.timeIntervalSince(self)
        return Int(ti) / D_DAY
    }
    
    //Thanks, dmitrydims
    //I have not yet thoroughly tested this
    func distanceInDaysToDate(anotherDate:Date) -> Int{
        let gregorianCalendar = NSCalendar.init(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let components = gregorianCalendar?.components(NSCalendar.Unit.day, from: self, to: anotherDate, options: NSCalendar.Options.init(rawValue: 0))
        return components!.day!
    }
    
    
    //MARK: Decomposing Dates
    func nearestHour()->Int{
        let aTimeInterval = Date().timeIntervalSinceReferenceDate + TimeInterval(D_MINUTE * 30)
        let newDate = Date.init(timeIntervalSinceReferenceDate: aTimeInterval)
        var components = Date.currentCalendar().components(NSCalendar.Unit.hour, from: newDate)
        return components.hour!
    }
    
    func hour()->Int{
        var components = Date.currentCalendar().components(calendarUnit, from: self)
        return components.hour!
    }
    
    func minute()->Int{
        var components = Date.currentCalendar().components(calendarUnit, from: self)
        return components.minute!
    }
    
    func seconds()->Int{
        var components = Date.currentCalendar().components(calendarUnit, from: self)
        return components.second!
    }
    
    func day()->Int{
        var components = Date.currentCalendar().components(calendarUnit, from: self)
        return components.day!
    }
    
    func month()->Int{
        var components = Date.currentCalendar().components(calendarUnit, from: self)
        return components.month!
    }
    
    func week()->Int{
        var components = Date.currentCalendar().components(calendarUnit, from: self)
        return components.weekOfYear!
    }
    
    func weekday()->Int{
        var components = Date.currentCalendar().components(calendarUnit, from: self)
        return components.weekday!
    }
    
    func nthWeekday()->Int{
        var components = Date.currentCalendar().components(calendarUnit, from: self)
        return components.weekdayOrdinal!
    }
    
    func year()->Int{
        var components = Date.currentCalendar().components(calendarUnit, from: self)
        return components.year!
    }
    
    
}

