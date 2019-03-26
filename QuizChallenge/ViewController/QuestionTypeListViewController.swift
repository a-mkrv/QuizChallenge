//
//  QuestionTypeListViewController.swift
//  QuizChallenge
//
//  Created by A.Makarov on 26/03/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class QuestionTypeListViewController: BaseViewController, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let qiestionTypeItems: BehaviorRelay<[String]> = BehaviorRelay(value: ["All", "Sport", "Animals", "Politics", "Programming"])
    let disposeBag = DisposeBag()
    var type = PublishSubject<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        qiestionTypeItems.asObservable()
            .bind(to: tableView.rx.items) { (tableView, row, element) in
                let indexPath = IndexPath(row: row, section: 0)
                
                if row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCustomCell", for: indexPath) as! QuestionCustomCell
                    cell.type.subscribe(onNext: { [weak self] type in
                        self?.type.onNext(type)
                    }).disposed(by: self.disposeBag)
                    return cell
                }
                else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionTypeCell", for: indexPath) as! QuestionTypeCell
                    cell.nameLabel?.text = element
                    cell.type.subscribe(onNext: { [weak self] type in
                        self?.type.onNext(type)
                    }).disposed(by: self.disposeBag)
                    return cell
                }
            }
            .disposed(by: disposeBag)
    }
}

class QuestionTypeCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    let type = PublishSubject<String>()
    
    @IBAction func chooseType(_ sender: Any) {
        self.type.onNext(nameLabel?.text ?? "Nil")
    }
}

class QuestionCustomCell: UITableViewCell {
    
    @IBOutlet weak var textField: IBTextField!
    let type = PublishSubject<String>()
    
    @IBAction func chooseType(_ sender: Any) {
        self.type.onNext(textField?.text ?? "Nil")
    }
}
