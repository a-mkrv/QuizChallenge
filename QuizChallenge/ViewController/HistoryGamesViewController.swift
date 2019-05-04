//
//  HistoryGamesViewController.swift
//  QuizChallenge
//
//  Created by A.Makarov on 11/03/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import UIKit
import SkeletonView
import RxSwift

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
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: Create request to check existing games
        switch Int.random(in: 0...1) {
        case 0:
            gamesTableView.removeFromSuperview()
            
            let emptyView = EmptyActiveGameView()
            view.addSubview(emptyView)
            view.backgroundColor = .white

            emptyView.translatesAutoresizingMaskIntoConstraints = false
            emptyView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            emptyView.widthAnchor.constraint(equalToConstant: 300).isActive = true
            emptyView.heightAnchor.constraint(equalToConstant: view.frame.height / 1.5).isActive = true
            startButtonHandler(button: emptyView.button)
            
        case 1:
            loadGameHistory()
            
            Timer.scheduledTimer(withTimeInterval: 4.0, repeats: false) { _ in
                self.isHistoryLoaded = true
                self.gamesTableView.reloadData()
            }
        default: break
        }
    }
    
    func loadGameHistory() {
        let debugData = [1, 0, 0, 1, 0, 1, 1].sorted { $0 < $1 }.map( { return String($0) })
        var activeGames = GameSection(header: "Active Games", games: [], status: .Active)
        var finishedGames = GameSection(header: "Finished Games", games: [], status: .Finished)
        debugData.forEach{ $0 == "0" ? finishedGames.games.append($0) : activeGames.games.append($0) }
        
        if !activeGames.games.isEmpty {
            activeGames.games.append("1")
            gamesSections.append(activeGames)
        }
        finishedGames.games.isEmpty ? () : gamesSections.append(finishedGames)
    }
    
    func startButtonHandler(button: UIButton) {
        button.rx.tap
            .subscribe { [weak self] _ in
                guard let sSelf = self, var vcArray = sSelf.navigationController?.viewControllers else { return }
                
                let vc = CommonHelper.loadViewController(named: "TypeGameSB") as! TypeGameViewController
                vcArray.removeLast()
                vcArray.append(vc)
                sSelf.navigationController?.setViewControllers(vcArray, animated: true)
            }.disposed(by: self.disposeBag)
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
        
        if isHistoryLoaded && indexPath.section == 0 && indexPath.row == gamesSections[0].games.count - 1 {
            let startCell = tableView.dequeueReusableCell(withIdentifier: "StartGameCell", for: indexPath) as! StartGameCell
            startButtonHandler(button: startCell.startGameButton)
            return startCell
        }
        
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if !isHistoryLoaded {
            return CGFloat(tableCellHeight)
        }

        if indexPath.section == 0 && indexPath.row == gamesSections[0].games.count - 1 {
            return 65.0
        }
        
        return CGFloat(tableCellHeight)
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
