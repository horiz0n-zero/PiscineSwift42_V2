//
//  AddEditViewController.swift
//  day03
//
//  Created by Antoine FEUERSTEIN on 3/1/19.
//  Copyright © 2019 Antoine FEUERSTEIN. All rights reserved.
//

import Foundation
import UIKit

class AddEditViewController: UIViewController {
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet var datePicker: UIDatePicker!
    
    var currentNote: Note? = nil
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for button in self.buttons {
            button.layer.cornerRadius = 8
            button.layer.borderWidth = 1
            button.layer.borderColor = self.titleTextField.backgroundColor?.cgColor
        }
        titleTextField.layer.cornerRadius = 8
        titleTextField.layer.borderWidth = 1
        titleTextField.layer.borderColor = UIColor.red.withAlphaComponent(0.3).cgColor
        descriptionTextView.layer.cornerRadius = 8
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.borderColor = UIColor.red.withAlphaComponent(0.3).cgColor
        self.datePicker.setValue(self.titleTextField.backgroundColor!, forKey: "textColor")
        guard let note = self.currentNote else {
            return
        }
        
        self.titleTextField.text = note.title
        self.descriptionTextView.text = note.description
    }
    
    @IBAction func annulerAction(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func ajouterAction(sender: UIButton) {
        var note: Note
        
        if let currentNote = self.currentNote {
            note = currentNote
            note.updated = Date.init()
        }
        else {
            if self.titleTextField.text == "" || self.descriptionTextView.text == "" {
                let alert = UIAlertController.init(title: "Erreur", message: "Contenue manquant", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction.init(title: "Ok", style: .default, handler: nil))
                alert.addTextField(configurationHandler: nil)
                return self.present(alert, animated: true, completion: nil)
            }
            note = Note.init(title: self.titleTextField.text!,
                             description: self.descriptionTextView.text)
        }
        
        ViewController.shared.receiveNote(note: note)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    @objc func keyBoardWillShow(sender: Notification) {
        for (key, value) in sender.userInfo! {
            print(key, value)
        }
    }
    @objc func keyBoardWillHide(sender: Notification) {
        for (key, value) in sender.userInfo! {
            print(key, value)
        }
    }
    
    
}




