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
    var isHidden = false
    
    init(header: String, games: [String], status: StatusGame) {
        self.header = header
        self.games = games
        self.status = status
    }
}

class HistoryGamesViewController: BaseViewController {
    
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
        let debugData = [1, 0, 0, 1, 0, 1, 1].sorted { $0 < $1 }.map( { return String($0) })
        var activeGames = GameSection(header: "Active Games", games: [], status: .Active)
        var finishedGames = GameSection(header: "Finished Games", games: [], status: .Finished)
        debugData.forEach{ $0 == "0" ? finishedGames.games.append($0) : activeGames.games.append($0) }
        
        activeGames.games.isEmpty ? () : gamesSections.append(activeGames)
        finishedGames.games.isEmpty ? () : gamesSections.append(finishedGames)
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
        
        guard !gamesSections[section].isHidden else {
            return 0
        }
        
        return gamesSections[section].games.count
    }
    
    // Setup Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryGameCell", for: indexPath) as! HistoryGameCell
        
        if isHistoryLoaded {
            cell.endSkeletonAnimation()
            cell.statusGame = String(gamesSections[indexPath.section].games[indexPath.row])
            cell.score = "5 / 10"
        } else {
            cell.startSkeletonAnimate()
        }
        
        return cell
    }
    
    // Setup Header Section
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView()
        view.backgroundColor = .white
        view.tag = section
        
        let label = UILabel()
        label.text = gamesSections[section].header
        label.frame = CGRect(x: 16, y: 0, width: 150, height: 38)
        label.font = UIFont(name: "Futura-Medium", size: 20.0)
        label.textColor = .white
        view.addShadowAndRadius(offset: CGSize(width: 1, height: 1), color: .gray, radius: 2, opacity: 0.18, cornerRadius: 5)

        let headerTapGesture = UITapGestureRecognizer()
        headerTapGesture.addTarget(self, action: #selector(sectionHeaderTouched(_:)))
        view.addGestureRecognizer(headerTapGesture)
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if section == 0 {
            view.backgroundColor = UIColor.lightRoyal
        } else if section == 1 {
            view.backgroundColor = UIColor(named: "Color-4")
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        view.backgroundColor = .clear
        view.tintColor = .clear
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return isHistoryLoaded ? 45 : 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    @objc func sectionHeaderTouched(_ sender: UITapGestureRecognizer) {
        
        if let headerView = sender.view {
            let tag = headerView.tag
            gamesSections[tag].isHidden = !gamesSections[tag].isHidden
            gamesTableView.reloadSections(IndexSet(integer: tag), with: .automatic)
        }
    }
}
