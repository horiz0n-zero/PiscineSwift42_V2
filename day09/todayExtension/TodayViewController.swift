//
//  TodayViewController.swift
//  todayExtension
//
//  Created by Antoine FEUERSTEIN on 3/5/19.
//  Copyright © 2019 Antoine FEUERSTEIN. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        print("perfome update")
        completionHandler(NCUpdateResult.newData)
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        print("did change", maxSize)
    }
}
