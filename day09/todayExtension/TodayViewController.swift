//
//  TodayViewController.swift
//  todayExtension
//
//  Created by Antoine FEUERSTEIN on 3/5/19.
//  Copyright © 2019 Antoine FEUERSTEIN. All rights reserved.
//

import UIKit
import NotificationCenter
import day08_framework

fileprivate let articlesCountInExpandedMode: Int = 4

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet var tableView: UITableView!
    var articles: [Article] = Article.getAllArticles()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        print("perfome update")
        completionHandler(NCUpdateResult.newData)
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        print("did change", maxSize, self.view.bounds)
        self.preferredContentSize = maxSize
        self.view.layoutIfNeeded()
        self.tableView.reloadSections(IndexSet.init(integersIn: 0...0), with: .automatic)
    }
}

extension TodayViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.extensionContext?.widgetActiveDisplayMode == .compact {
            return self.articles.count > 0 ? 1 : 0
        }
        return self.articles.count >= articlesCountInExpandedMode ?
                articlesCountInExpandedMode : self.articles.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ArticleTableViewCell
        
        cell.fill(with: self.articles[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.extensionContext?.widgetActiveDisplayMode == .compact {
            return self.preferredContentSize.height
        }
        if self.articles.count < articlesCountInExpandedMode {
            return self.preferredContentSize.height / CGFloat(self.articles.count)
        }
        return self.preferredContentSize.height / CGFloat(articlesCountInExpandedMode)
    }
    
}
