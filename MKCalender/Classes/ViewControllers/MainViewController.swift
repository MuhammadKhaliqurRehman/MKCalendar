//
//  MainViewController.swift
//  MKCalender
//
//  Created by Muhammad Khaliq ur Rehman on 07/04/2017.
//  Copyright © 2017 Muhammad Khaliq ur Rehman. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var calenderView: MKCalenderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupNavigationBar()
        setupViewController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    private func setupNavigationBar() {
        self.navigationController?.navigationBar.isTranslucent = false
        self.title = "MKCalendar"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 1/255, green: 142/255, blue: 0/255, alpha: 1)
    }
    
    private func setupViewController() {
        
    }
}
