//
//  ViewController.swift
//  00
//
//  Created by Antoine FEUERSTEIN on 2/12/19.
//  Copyright © 2019 Antoine FEUERSTEIN. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var numbers: [UIButton]!
    @IBOutlet var buttons: [UIButton]!
    
    @IBOutlet var labelView: UIView!
    @IBOutlet var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.labelView.layer.borderWidth = 2
        self.labelView.layer.borderColor = UIColor.black.cgColor
        self.labelView.backgroundColor = UIColor.gray
        self.label.textColor = UIColor.white
        for button in self.buttons {
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.black.cgColor
            button.backgroundColor = UIColor.gray
            button.setTitleColor(UIColor.white, for: .normal)
        }
        for button in self.numbers {
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.black.cgColor
            button.backgroundColor = UIColor.orange
            button.setTitleColor(UIColor.white, for: .normal)
        }
    }

    
    
}










