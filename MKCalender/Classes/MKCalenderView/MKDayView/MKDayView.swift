//
//  MKDayView.swift
//  MKCalender
//
//  Created by Muhammad Khaliq ur Rehman on 07/04/2017.
//  Copyright © 2017 Muhammad Khaliq ur Rehman. All rights reserved.
//

import UIKit

protocol MKDayViewDelegate: NSObjectProtocol {
    func daySelected(dayInfo: MKDay, with sender: UIButton)
}

class MKDayView: UIView {

    @IBOutlet var mainView: UIView!
    @IBOutlet weak var dayButton: UIButton! {
        didSet {
            self.dayButton.layer.cornerRadius = self.dayButton.bounds.width / 2
            self.dayButton.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchUpInside)
        }
    }
    private var currentDaySelected: Bool? = false
    private let nibName: String = "MKDayView"
    
    private var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }
    private var actualDate: Date? = nil
    private let calendar: Calendar = Calendar(identifier: .gregorian)
    private var info: MKDay? = nil
    public var delegate: MKDayViewDelegate? = nil
    
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
    
    @objc private func buttonPressed(sender: UIButton) {
        if delegate != nil {
            delegate?.daySelected(dayInfo: info!, with: sender)
        }
    }
    
    private func setupView() {
        dayButton.setTitle(String(describing: info!.day!), for: .normal)
        let dateString = (String(describing: info!.year!)) + "-" + (String(describing: info!.month!)) + "-" + (String(describing: info!.day!))
        actualDate = dateFormatter.date(from: dateString)
        
        if actualDate?.isWeekEnd() == true && info?.isInCurrentMonth == true {
            dayButton.backgroundColor = UIColor.red
        } else {
            if info?.isInCurrentMonth == false {
                dayButton.backgroundColor = UIColor.gray
            } else {
                dayButton.backgroundColor = UIColor(red: 1/255, green: 142/255, blue: 0/255, alpha: 1)
            }
            
        }
        
        if (actualDate?.isToday())! {
            delegate?.daySelected(dayInfo: info!, with: dayButton)
        }
    }
    
    public func setupDayViewFor(day: MKDay) {
        info = day
        setupView()
    }

}
