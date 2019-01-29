//
//  TopicQuizCell.swift
//  QuizChallenge
//
//  Created by Anton Makarov on 22/01/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import UIKit

class TopicQuizCell: UICollectionViewCell, CellSelectable {
    
    @IBOutlet weak var tableView: UITableView!
    var curSelectedCellIndex: Int?
    
    var delegate: PrepareDelegate?
    let dataSource = [("Sport", ["All", "Football", "Gym"]),
                      ("Animals", ["All", "Bear", "Dogs", "Cats"]),
                      ("IT", ["All", "Computer", "Mobile", "Programming"]),
                      ("Person", ["All", "Famous", "Russian", "Girls"]),
                      ("Cars", ["All", "Audi", "Lexus", "Lada"]),
                      ("Other", ["All", "Sounds", "Questions", "Wall", "Navigate"])]

    override func layoutSubviews() {
        super.layoutSubviews()
        
        tableView.delegate = self
        tableView.dataSource = self        
    }
    
    @IBAction func startGame(_ sender: Any) {
        delegate?.startGame()
    }
    
    func selectCell(index: Int) {
        if let sIndex = curSelectedCellIndex {
            let indexPath = IndexPath(row: sIndex, section: 0)
            tableView.beginUpdates()
            tableView.reloadRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
        curSelectedCellIndex = index
    }
}

extension TopicQuizCell: UITableViewDataSource, UITableViewDelegate  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellId = String(describing: SetCategoriesCell.self)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SetCategoriesCell
        cell.typeLabel.text = dataSource[indexPath.row].0
        cell.categories = dataSource[indexPath.row].1
        cell.curTableCellIndex = indexPath.row
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
