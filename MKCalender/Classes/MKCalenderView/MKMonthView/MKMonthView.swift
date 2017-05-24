//
//  MKMonthView.swift
//  MKCalender
//
//  Created by Muhammad Khaliq ur Rehman on 08/04/2017.
//  Copyright © 2017 Muhammad Khaliq ur Rehman. All rights reserved.
//

import UIKit

protocol MKMonthViewDelegate: NSObjectProtocol {
    func daySelected(dayInfo: MKDay, with sender: UIButton)
}

class MKMonthView: UIView, MKWeekViewDelegate {

    private let nibName: String = "MKMonthView"
    @IBOutlet var mainView: UIView!
    
    @IBOutlet weak var firstWeekView: MKWeekView!
    @IBOutlet weak var secondWeekView: MKWeekView!
    @IBOutlet weak var thirdWeekView: MKWeekView!
    @IBOutlet weak var fourthWeekView: MKWeekView!
    @IBOutlet weak var fifthWeekView: MKWeekView!
    @IBOutlet weak var sixthWeekView: MKWeekView!
    
    public var numberOfWeek: Int = 5 {
        didSet {
            if numberOfWeek < 6 {
                sixthWeekView.isHidden = true
            } else {
                sixthWeekView.isHidden = false
            }
        }
    }
    
    public var delegate: MKMonthViewDelegate? = nil
    
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
    }
    
    private func setupViewFor(week: Int, with Info: [MKDay]) {
        switch week {
        case 0:
            firstWeekView.delegate = self
            firstWeekView.setupWeekViewFor(week: Info)
        case 1:
            secondWeekView.delegate = self
            secondWeekView.setupWeekViewFor(week: Info)
        case 2:
            thirdWeekView.delegate = self
            thirdWeekView.setupWeekViewFor(week: Info)
        case 3:
            fourthWeekView.delegate = self
            fourthWeekView.setupWeekViewFor(week: Info)
        case 4:
            fifthWeekView.delegate = self
            fifthWeekView.setupWeekViewFor(week: Info)
        case 5:
            sixthWeekView.delegate = self
            sixthWeekView.setupWeekViewFor(week: Info)
        default:
            break
        }
    }
    
    public func setupMonthViewForMonth(startDate: Date, endDate: Date, numberOfWeeks: Int, monthInfo: [[MKDay]]) {
        numberOfWeek = numberOfWeeks
        for weekNumber in 0..<numberOfWeeks {
            let weekInfo = monthInfo[weekNumber]
            setupViewFor(week: weekNumber, with: weekInfo)
        }
    }
    
    func daySelected(dayInfo: MKDay, with sender: UIButton) {
        if delegate != nil {
            delegate?.daySelected(dayInfo: dayInfo, with: sender)
        }
    }
    
}
