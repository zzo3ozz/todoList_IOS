//
//  TodoCell.swift
//  todoList
//
//  Created by 한서영 on 2022/08/01.
//

import UIKit
import FMDB

class TodoCell:UITableViewCell {
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var tdLabel: UILabel!
    
    
    
    var databasePath = String()
    var filled = 0
    
    @IBAction func doCheck(_ sender: Any) {
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docDir = dirPaths[0]
        databasePath = docDir + "/todoList.db"
        
        let db = FMDatabase(path: databasePath)

        if db.open() {
            if filled == 1 {
                filled = 0
            } else {
                filled = 1
            }
            let query1 = "update todoList set done = \(filled) where todo = '\(tdLabel.text!)'"
            if !db.executeUpdate(query1, withArgumentsIn: []) {
                NSLog("업데이트 실패")
            } else {
                print(query1)
                NSLog("업데이트 성공")
            }

        }
        
        do_Check()
    }
    
    
    func do_Check() {
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docDir = dirPaths[0]
        databasePath = docDir + "/todoList.db"
        
        let db = FMDatabase(path: databasePath)
        
        if db.open() {
            let query = "select done from todoList where todo = '\(tdLabel.text!)'"
            if let result = db.executeQuery(query, withArgumentsIn: []) {
                while result.next() {
                    filled =  Int(result.int(forColumn: "done"))
                }
                
            } else {
                NSLog("결과 없음")
            }
        }
        if filled == 1 {
            checkBtn.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        } else {
            checkBtn.setImage(UIImage(systemName: "circle"), for: .normal)
        }
    }
    


}
