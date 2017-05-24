//
//  MKCalenderManager.swift
//  MKCalender
//
//  Created by Muhammad Khaliq ur Rehman on 09/04/2017.
//  Copyright © 2017 Muhammad Khaliq ur Rehman. All rights reserved.
//

import UIKit

struct MKDay {
    var day: Int? = nil
    var week: Int? = nil
    var month: Int? = nil
    var year: Int? = nil
    var isInCurrentMonth: Bool? = nil
    
    init(day: Int, week: Int, month: Int, year: Int, isInCurrentMonth: Bool) {
        self.day = day
        self.week = week
        self.month = month
        self.year = year
        self.isInCurrentMonth = isInCurrentMonth
    }
}

struct MKMonthInfo {
    var startDate: Date? = nil
    var endDate: Date? = nil
    var numberOfWeeks: Int? = 0
    var monthDates: [[MKDay]]? = nil
    
    init(startDate: Date, endDate: Date, numberOfWeeks: Int, monthDates: [[MKDay]]) {
        self.startDate = startDate
        self.endDate = endDate
        self.numberOfWeeks = numberOfWeeks
        self.monthDates = monthDates
    }
}

class MKCalenderManager: NSObject {
    
    private let startDayOfWeek: Int = 2
    
    private func getMonthFor(date : Date) -> (monthStartDate: Date, monthEndDate: Date, numberOfWeeks: Int, monthInformation: [[MKDay]]) {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = startDayOfWeek
        var components = calendar.dateComponents([.year, .month, .weekday], from: date)
        
        // First Day of Month
        components.day = 1
        let currentMonth = components.month
        let currentMonthYear = components.year
        let monthStartDate = calendar.date(from: components)
        
        // Last Day of Month
        components.month = components.month! + 1
        let nextMonth = components.month
        let nextMonthYear = components.year
        components.day = components.day! - 1
        let monthEndDate = calendar.date(from: components)
        
        // Number of Weeks in Month
        var numberOfWeeksInMonth = calendar.range(of: .weekOfMonth, in: .month, for: date)?.count
        
        // Dates Fall in Current Month
        let datesInrange = calendar.range(of: .day, in: .month, for: date)
        var currentMonthDates : [Int] = []
        for value in datesInrange!.lowerBound..<datesInrange!.upperBound {
            currentMonthDates.append(value)
        }
        
        //Find Weekday Index of First- and LastDay of Month.
        let firstDayIndexInWeekView = indexForDate(weekDay: calendar.dateComponents([.weekday], from: monthStartDate!).weekday! - 1)
        let lastDayIndexInWeekView = indexForDate(weekDay: calendar.dateComponents([.weekday], from: monthEndDate!).weekday! - 1)
        
        // Dates Fall in Next Month
        var nextMonthDates : [Int] = []
        let numberOfDaysInNextMonth = 7 - lastDayIndexInWeekView
        if numberOfDaysInNextMonth > 0 {
            for value in 1...numberOfDaysInNextMonth {
                nextMonthDates.append(value)
            }
        }
        
        // Dates Fall in Previous Month
        // Reset components
        components = calendar.dateComponents([.year, .month, .weekOfMonth], from: date)
        
        // Last Day of Previous Month
        components.month = components.month! - 1
        let previousMonth = components.month
        let previousMonthYear = components.year
        let previousMonthEndDay = calendar.date(from: components)!
        
        let datesInRangeOfPreviousMonth = calendar.range(of: .day, in: .month, for: previousMonthEndDay)
        var previousMonthDates: [Int] = []
        let numberOfDaysInPreviousMonth = 7 - (8 - firstDayIndexInWeekView)
        let subRangeLowerBound = (datesInRangeOfPreviousMonth?.upperBound)! - numberOfDaysInPreviousMonth
        if subRangeLowerBound < datesInRangeOfPreviousMonth!.upperBound {
            for value in subRangeLowerBound..<datesInRangeOfPreviousMonth!.upperBound {
                previousMonthDates.append(value)
            }
        }
        
        // If Total Dates are Larger Then Amount of Weeks * 7, Add Extra Week
        if currentMonthDates.count + nextMonthDates.count + previousMonthDates.count > numberOfWeeksInMonth! * 7 {
            numberOfWeeksInMonth = numberOfWeeksInMonth! + 1
        }
        
        var  monthInformationToReturn: [[MKDay]] = []
        
        var dayOfMonthIndex = 0
        
        for weekIndex in 1...numberOfWeeksInMonth! {
            
            var dayOfWeekIndex = 0
            
            switch weekIndex {
                
            // First Week
            case 1:
                var weekInformationToReturn: [MKDay] = []
                
                // Get The Last Days of Previous Month
                if previousMonthDates.count > 0 {
                    for day in 0..<previousMonthDates.count {
                        let dayValue = previousMonthDates[day]
                        let dayToReturn = MKDay(day: dayValue, week: weekIndex, month: previousMonth!, year: previousMonthYear!, isInCurrentMonth: false)
                        weekInformationToReturn.append(dayToReturn)
                    }
                }
                
                // Get First Days of Month
                let firstDaysInCurrentMonth = 7 - numberOfDaysInPreviousMonth
                
                if firstDaysInCurrentMonth > 0 {
                    dayOfWeekIndex = firstDayIndexInWeekView
                    
                    for _ in 0..<firstDaysInCurrentMonth {
                        let dayValue = currentMonthDates[dayOfMonthIndex]
                        let dayToReturn = MKDay(day: dayValue, week: weekIndex, month: currentMonth!, year: currentMonthYear!, isInCurrentMonth: true)
                        weekInformationToReturn.append(dayToReturn)
                        dayOfWeekIndex = dayOfWeekIndex + 1
                        dayOfMonthIndex = dayOfMonthIndex + 1
                    }
                }
                
                monthInformationToReturn.append(weekInformationToReturn)
                
            // Last Week
            case numberOfWeeksInMonth!:
                var weekInformationToReturn: [MKDay] = []
                
                // Get Last Days of Current Month
                let lastDaysInCurrentMonth = 7 - numberOfDaysInNextMonth
                
                if lastDaysInCurrentMonth > 0 {
                    for _ in 0..<lastDaysInCurrentMonth {
                        let dayValue = currentMonthDates[dayOfMonthIndex]
                        let dayToReturn = MKDay(day: dayValue, week: weekIndex, month: currentMonth!, year: currentMonthYear!, isInCurrentMonth: true)
                        weekInformationToReturn.append(dayToReturn)
                        dayOfWeekIndex = dayOfWeekIndex + 1
                        dayOfMonthIndex = dayOfMonthIndex + 1
                    }
                }
                
                // Get The First Days of Next Month
                if nextMonthDates.count > 0 {
                    for day in 0..<nextMonthDates.count {
                        let dayValue = nextMonthDates[day]
                        let dayToReturn = MKDay(day: dayValue, week: weekIndex, month: nextMonth!, year: nextMonthYear!, isInCurrentMonth: false)
                        weekInformationToReturn.append(dayToReturn)
                    }
                }
                
                monthInformationToReturn.append(weekInformationToReturn)
                
            // Middle Weeks
            default:
                guard dayOfMonthIndex < currentMonthDates.count else {
                    continue
                }
                
                var weekInformationToReturn: [MKDay] = []
                
                for _ in 0...6 {
                    let dayValue = currentMonthDates[dayOfMonthIndex]
                    let dayToReturn = MKDay(day: dayValue, week: weekIndex, month: currentMonth!, year: currentMonthYear!, isInCurrentMonth: true)
                    weekInformationToReturn.append(dayToReturn)
                    dayOfWeekIndex = dayOfWeekIndex + 1
                    dayOfMonthIndex = dayOfMonthIndex + 1
                }
                
                monthInformationToReturn.append(weekInformationToReturn)
            }
        }
        return (monthStartDate!, monthEndDate!, numberOfWeeksInMonth!, monthInformationToReturn)
    }
    
    private func indexForDate(weekDay: Int) -> Int {
        if weekDay <= 0 {
            return weekDay + 7
        } else {
            return weekDay
        }
    }
    
    public func getMonthInfoFrom(date: Date) -> (monthStartDate: Date, monthEndDate: Date, numberOfWeeks: Int, monthInformation: [[MKDay]]) {
        let info = getMonthFor(date: date)
        return info
    }
    
}

extension Date {
    public func isToday() -> Bool {
        let todayDate = Date()
        return todayDate.isSameDate(date: self)
    }
    
    private func isSameDate(date: Date) -> Bool {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "MM/dd/yyyy"
        
        let firstDate = dateFormater.date(from: dateFormater.string(from: self))
        let secondDate = dateFormater.date(from: dateFormater.string(from: date))
        
        let comparisonResult = firstDate?.compareDate(date: secondDate!)
        if comparisonResult! == .orderedSame {
            return true
        } else {
            return false
        }
    }
    
    private func compareDate(date: Date) -> ComparisonResult {
        return self.compare(date)
    }
    
    public func isWeekEnd() -> Bool {
        let calender = Calendar(identifier: .gregorian)
        return calender.isDateInWeekend(self)
    }
}
