//
//  ViewController.swift
//  todoList
//
//  Created by 한서영 on 2022/07/31.
//

import UIKit
import FMDB

class ViewController: UIViewController {
    var databasePath = String()
    var list = Array<todoMember>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("load")
        initDB()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        selectAll()
        self.tableView.reloadData()
    }

    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBAction func doDone(_ sender: UIButton) {
        selectAll()
        
        var count = 0
        for i in 0...(list.count - 1) {
            if list[i].done == 1 {
                count += 1
            }
        }
        var result:String
        let rate = Double(count) / Double(list.count)
        
        if rate < 0.3 {
            result = "분발합시다."
        } else if rate < 0.7 {
            result = "수고했어요!"
        } else {
            result = "참 잘했어요!"
        }
        
        let alertVC = UIAlertController(title: "할 일 끝!", message: "\(result)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertVC.addAction(okAction)
        self.present(alertVC, animated: true, completion: nil)
        
        let db = FMDatabase(path: databasePath)

        if db.open() {
            try! db.executeUpdate("delete from todoList", values: [])
        }

        list.removeAll()
        self.tableView.reloadData()
    }
    
    func initDB() {
        let fileMgr = FileManager.default
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docDir = dirPaths[0]
        
        databasePath = docDir + "/todoList.db"
        if !fileMgr.fileExists(atPath: databasePath) {
            let db = FMDatabase(path: databasePath)
            // 디비 만들기
            if db.open() {
                // 테이블 만들기
                // SQL : 질의문
                // 글자를 저장하기 위한 컬럼 타입 : text
                let query = "create table if not exists todoList (id integer primary key autoincrement, todo text, done integer default 0)"
                if !db.executeStatements(query) {
                    NSLog("디비 생성 실패")
                } else {
                    NSLog("디비 생성 성공")
                }
            }
        } else {
            NSLog("디비파일 있음")
        }
    }

    func selectAll() {
        list.removeAll()
        
        let db = FMDatabase(path: databasePath)
        
        if db.open() {
            let query = "select * from todoList"
            if let result = db.executeQuery(query, withArgumentsIn: []) {
                while result.next() {
                    var member = todoMember(num: 0, todo: "", done: 0)
                    member.todo = String(result.string(forColumn: "todo")!)
                    member.done = Int(result.int(forColumn: "done"))

                    list.append(member)
                }
                self.tableView.reloadData()
            } else {
                NSLog("결과 없음")
            }
        }
    }
    
}

extension ViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for:indexPath) as! TodoCell
        let numbers = self.list[indexPath.row]
        cell.tdLabel.text = numbers.todo
        cell.do_Check()
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            
            if editingStyle == .delete {
                let db = FMDatabase(path: databasePath)
                if db.open() {
                    try! db.executeUpdate("delete from todoList where todo = '\(list[indexPath.row].todo)'", values: [])
                }
                
                list.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
            } else if editingStyle == .insert {
                
                
            }
    }
    
    
}
