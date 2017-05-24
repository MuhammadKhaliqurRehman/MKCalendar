//
//  MKWeekView.swift
//  MKCalender
//
//  Created by Muhammad Khaliq ur Rehman on 08/04/2017.
//  Copyright © 2017 Muhammad Khaliq ur Rehman. All rights reserved.
//

import UIKit

protocol MKWeekViewDelegate: NSObjectProtocol {
    func daySelected(dayInfo: MKDay, with sender: UIButton)
}

class MKWeekView: UIView, MKDayViewDelegate {
    
    @IBOutlet var mainView: UIView!
    
    private let nibName: String = "MKWeekView"
    
    @IBOutlet weak var firstDay: MKDayView!
    @IBOutlet weak var secondDay: MKDayView!
    @IBOutlet weak var thirdDay: MKDayView!
    @IBOutlet weak var fourthDay: MKDayView!
    @IBOutlet weak var fifthDay: MKDayView!
    @IBOutlet weak var sixthDay: MKDayView!
    @IBOutlet weak var seventhDay: MKDayView!
    
    public var delegate: MKWeekViewDelegate? = nil
    
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
    
    private func setupViewFor(day: Int, with Info: MKDay) {
        switch day {
        case 0:
            firstDay.delegate = self
            firstDay.setupDayViewFor(day: Info)
        case 1:
            secondDay.delegate = self
            secondDay.setupDayViewFor(day: Info)
        case 2:
            thirdDay.delegate = self
            thirdDay.setupDayViewFor(day: Info)
        case 3:
            fourthDay.delegate = self
            fourthDay.setupDayViewFor(day: Info)
        case 4:
            fifthDay.delegate = self
            fifthDay.setupDayViewFor(day: Info)
        case 5:
            sixthDay.delegate = self
            sixthDay.setupDayViewFor(day: Info)
        case 6:
            seventhDay.delegate = self
            seventhDay.setupDayViewFor(day: Info)
        default:
            break
        }
    }
    
    public func setupWeekViewFor(week: [MKDay]) {
        for day in 0..<week.count {
            let dayValue = week[day]
            setupViewFor(day: day, with: dayValue)
        }
    }
    
    func daySelected(dayInfo: MKDay, with sender: UIButton) {
        if delegate != nil {
            delegate?.daySelected(dayInfo: dayInfo, with: sender)
        }
    }

}
