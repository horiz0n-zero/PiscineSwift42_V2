//
//  ViewController.swift
//  day03
//
//  Created by Antoine FEUERSTEIN on 3/1/19.
//  Copyright © 2019 Antoine FEUERSTEIN. All rights reserved.
//

import UIKit

struct Note: Hashable {
    var title: String
    var description: String
    var created: Date
    var updated: Date? = nil
    
    var hashValue: Int {
        return self.title.hashValue ^ self.description.hashValue ^ self.created.hashValue
    }
    static func ==(lhs: Note, rhs: Note) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    init(title: String, description: String) {
        self.title = title
        self.description = description
        self.created = Date.init()
    }
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    var notes: [Note] = []
    static var shared: ViewController!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ViewController.shared = self
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UINib.init(nibName: "PlusTableViewCell", bundle: nil), forCellReuseIdentifier: "PlusTableViewCell")
        self.tableView.register(UINib.init(nibName: "NoteTableViewCell", bundle: nil), forCellReuseIdentifier: "NoteTableViewCell")
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.notes.count
        }
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "NoteTableViewCell", for: indexPath) as! NoteTableViewCell
            
            cell.fill(with: self.notes[indexPath.row])
            return cell
        }
        let cellPlus = self.tableView.dequeueReusableCell(withIdentifier: "PlusTableViewCell", for: indexPath) as! PlusTableViewCell
        
        return cellPlus
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddEditViewController") as? AddEditViewController {
            if indexPath.section == 0 {
                vc.currentNote = self.notes[indexPath.row]
            }
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func receiveNote(note: Note) {
        if let index = self.notes.index(of: note) {
            self.notes[index] = note
        }
        else {
            self.notes.append(note)
        }
        self.tableView.reloadSections(IndexSet.init(integersIn: 0...0), with: .automatic)
    }
}

