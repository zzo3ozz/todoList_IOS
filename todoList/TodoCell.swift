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
    
    
    var primaryKey:Int = 0
    var databasePath = String()
    var filled = 0
    
    @IBAction func doCheck(_ sender: Any) {
        let db = FMDatabase(path: databasePath)

        if db.open() {
            if filled == 1 {
                filled = 0
            } else {
                filled = 1
            }
            let query1 = "update todoList set done = \(filled) where id = '\(primaryKey)' "
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
            let query = "select * from todoList where todo = '\(tdLabel.text!)' limit 1"
            if let result = db.executeQuery(query, withArgumentsIn: []) {
                if result.next() {
                    filled =  Int(result.int(forColumn: "done"))
                    primaryKey = Int(result.int(forColumn: "id"))
                }
                
            } else {
                NSLog("결과 없음")
            }
            print(query)
        }
        if filled == 1 {
            checkBtn.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        } else {
            checkBtn.setImage(UIImage(systemName: "circle"), for: .normal)
        }
    }
    


}
