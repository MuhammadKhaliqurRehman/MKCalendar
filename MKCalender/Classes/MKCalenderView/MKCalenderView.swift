//
//  MKCalenderView.swift
//  MKCalender
//
//  Created by Muhammad Khaliq ur Rehman on 08/04/2017.
//  Copyright © 2017 Muhammad Khaliq ur Rehman. All rights reserved.
//

import UIKit

class MKCalenderView: UIView, MKMonthViewDelegate {

    private let nibName: String = "MKCalenderView"
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var monthView: MKMonthView!
    @IBOutlet weak var selectedDateLabel: UILabel!
    private let calenderManager: MKCalenderManager = MKCalenderManager()
    private var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyyy"
        return dateFormatter
    }
    private let calendar = Calendar(identifier: .gregorian)
    
    private var currentDisplayingDate: Date? = nil
    
    private var previousDaySelected: UIButton? = nil
    private var previousDayInfo: MKDay? = nil
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromNib()
    }
    
    private func loadFromNib() {
        Bundle.main.loadNibNamed(nibName, owner: self, options: nil)
        self.addSubview(mainView)
        mainView.frame = self.bounds
        setupViewForDate(date: Date())
    }
    
    private func setupViewForDate(date: Date) {
        let selectedDateString = dateFormatter.string(from: date)
        selectedDateLabel.text = selectedDateString
        let monthInformation = calenderManager.getMonthInfoFrom(date: date)
        monthView.delegate = self
        monthView.setupMonthViewForMonth(startDate: monthInformation.monthStartDate, endDate: monthInformation.monthEndDate, numberOfWeeks: monthInformation.numberOfWeeks, monthInfo: monthInformation.monthInformation)
    }

    @IBAction func previousYear(_ sender: UIButton) {
        let previousYearDate = calendar.date(byAdding: .year, value: -1, to: currentDisplayingDate!)
        currentDisplayingDate = previousYearDate
        setupViewForDate(date: previousYearDate!)
    }
    
    @IBAction func previousMonth(_ sender: UIButton) {
        let previousMonthDate = calendar.date(byAdding: .month, value: -1, to: currentDisplayingDate!)
        currentDisplayingDate = previousMonthDate
        setupViewForDate(date: previousMonthDate!)
    }
    
    @IBAction func nextMonth(_ sender: UIButton) {
        let nextMonthDate = calendar.date(byAdding: .month, value: 1, to: currentDisplayingDate!)
        currentDisplayingDate = nextMonthDate
        setupViewForDate(date: nextMonthDate!)
    }
    
    @IBAction func nextYear(_ sender: UIButton) {
        let nextYearDate = calendar.date(byAdding: .year, value: 1, to: currentDisplayingDate!)
        currentDisplayingDate = nextYearDate
        setupViewForDate(date: nextYearDate!)
    }
    
    func daySelected(dayInfo: MKDay, with sender: UIButton) {
        if previousDaySelected != nil && previousDayInfo != nil {
            setupPreviousSelectedButtonView()
        }
        sender.backgroundColor = UIColor.brown
        previousDayInfo = dayInfo
        previousDaySelected = sender
        
        let actualDate = actualDateFromMKDay(dayInfo: dayInfo)
        currentDisplayingDate = actualDate
        
        let selectedDateString = dateFormatter.string(from: actualDate)
        selectedDateLabel.text = selectedDateString
    }
    
    private func setupPreviousSelectedButtonView() {
        let actualDate = actualDateFromMKDay(dayInfo: previousDayInfo!)
        
        if actualDate.isWeekEnd() == true && previousDayInfo!.isInCurrentMonth == true {
            previousDaySelected!.backgroundColor = UIColor.red
        } else {
            if previousDayInfo!.isInCurrentMonth == false {
                previousDaySelected!.backgroundColor = UIColor.gray
            } else {
                previousDaySelected!.backgroundColor = UIColor(red: 1/255, green: 142/255, blue: 0/255, alpha: 1)
            }
            
        }
    }
    
    private func actualDateFromMKDay(dayInfo: MKDay) -> Date {
        let dateString = (String(describing: previousDayInfo!.year!)) + "-" + (String(describing: previousDayInfo!.month!)) + "-" + (String(describing: previousDayInfo!.day!))
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: dateString)!
    }
    
}
