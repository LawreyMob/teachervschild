//
//  ViewController.swift
//  HKScoreboard
//
//  Created by Lawrence Tan on 5/5/17.
//  Copyright © 2017 Lawrey. All rights reserved.
//

import UIKit

let kHighscoreUpdatedNotification = "HighscoreUpdated"

class HKSScoreboardViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var teacherScoreLabel: UILabel!
    @IBOutlet weak var childScoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupObservers()
        self.loadData()
    }
    
    fileprivate func loadData() {
        let queue = DispatchQueue(label: "loadScores", attributes: .concurrent, target: .main)
        let group = DispatchGroup()
        
        HKSLoading.shared.showOverlay(view: self.view)
        
        group.enter()
        queue.async(group: group) {
            HKSClient.getKidsFromServer { (hasResult, error) in }
            group.leave()
        }
        
        group.enter()
        queue.async(group: group) {
            HKSClient.getTeachersFromServer { (hasResult, error) in }
            group.leave()
        }
        
        group.notify(queue: DispatchQueue.main) {
            self.reloadScoreboard()
            HKSLoading.shared.hideOverlayView()
        }
    }
    
    fileprivate func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadScoreboard), name: NSNotification.Name(rawValue: kHighscoreUpdatedNotification), object: nil)
    }
    
    fileprivate func setupView() {
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 80
    }
    
    func reloadScoreboard() {
        self.tableView.reloadData()
        self.updateOverallScores()
    }
    
    fileprivate func updateOverallScores() {
        let totalKidsScore = hksClient.kids.reduce(0, {$0 + $1.score})
        let totalTeachersScore = hksClient.teachers.reduce(0, {$0 + $1.score})
        self.childScoreLabel.text = "\(totalKidsScore)"
        self.teacherScoreLabel.text = "\(totalTeachersScore)"
    }
    
    fileprivate func getRankingBy(row: Int) -> String {
        switch row {
        case 0:
            return "1st"
        case 1:
            return "2nd"
        case 2:
            return "3rd"
        default:
            return "\(row+1)th"
        }
    }
    @IBAction func refreshButtonTapped(_ sender: Any) {
        self.loadData()
    }
}

extension HKSScoreboardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hksClient.kids.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HKSKidCell", for: indexPath) as! HKSKidTableViewCell
        let kid = hksClient.kids[indexPath.row]
        cell.nameLabel.text = "\(self.getRankingBy(row: indexPath.row)) - \(kid.name)"
        cell.pointsLabel.text = "\(kid.score) PTS"
        return cell
    }
}
