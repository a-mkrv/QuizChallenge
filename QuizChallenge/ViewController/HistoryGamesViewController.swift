//
//  HistoryGamesViewController.swift
//  QuizChallenge
//
//  Created by A.Makarov on 11/03/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import UIKit
import SkeletonView

enum StatusGame {
    case Active
    case Finished
}

struct GameSection {
    
    var header: String
    var games: [String]
    var status: StatusGame
    
    init(header: String, games: [String], status: StatusGame) {
        self.header = header
        self.games = games
        self.status = status
    }
}

class HistoryGamesViewController: UIViewController {
    
    @IBOutlet weak var gamesTableView: UITableView!
    
    var tableCellHeight = 115
    var isHistoryLoaded = false
    var gamesSections = [GameSection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadGameHistory()
        
        Timer.scheduledTimer(withTimeInterval: 4.0, repeats: false) { _ in
            self.isHistoryLoaded = true
            self.gamesTableView.reloadData()
        }
    }
    
    func loadGameHistory() {
        let debugData = [1, 1, 1].sorted { $0 < $1 }.map( { return String($0) })
        var activeGames = GameSection(header: "Active Games", games: [], status: .Active)
        var finishedGames = GameSection(header: "Finished Games", games: [], status: .Finished)
        debugData.forEach{ $0 == "0" ? finishedGames.games.append($0) : activeGames.games.append($0) }
        
        activeGames.games.isEmpty ? () : gamesSections.append(activeGames)
        finishedGames.games.isEmpty ? () : gamesSections.append(finishedGames)
    }
    
    @IBAction func pressBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: HistoryGamesViewController UITableView Extension
extension HistoryGamesViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Count sections and rows
    func numberOfSections(in tableView: UITableView) -> Int {
        return isHistoryLoaded ? gamesSections.count : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard isHistoryLoaded else {
            return (Int(view.frame.height) / tableCellHeight)
        }
        
        return gamesSections[section].games.count
    }
    
    // Setup Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryGameCell", for: indexPath) as! HistoryGameCell
        
        if isHistoryLoaded {
            cell.endSkeletonAnimation()
            cell.gameStatusLabel.text = String(gamesSections[indexPath.section].games[indexPath.row])
        } else {
            cell.startSkeletonAnimate()
        }
        
        return cell
    }
    
    // Setup Header Section
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView()
        view.backgroundColor = .white
        
        let label = UILabel()
        label.text = gamesSections[section].header
        label.frame = CGRect(x: 16, y: 0, width: 150, height: 38)
        label.font = UIFont(name: "Futura-Medium", size: 20.0)
        label.textColor = UIColor.royal
        
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return isHistoryLoaded ? 45 : 0
    }
}
