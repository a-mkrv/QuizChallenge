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
    
    let dataSource = loadJsonCategories(from: "Categories")
    var curSelectedCellIndex: Int?
    var delegate: PrepareDelegate?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
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
        return dataSource?.typeQuestions.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellId = String(describing: SetCategoriesCell.self)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SetCategoriesCell
        
        cell.typeLabel.text = dataSource?.typeQuestions[indexPath.row].name
        cell.categories = dataSource?.typeQuestions[indexPath.row].types ?? []
        cell.curTableCellIndex = indexPath.row
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
