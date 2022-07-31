//
//  AddViewController.swift
//  todoList
//
//  Created by 한서영 on 2022/08/01.
//

import UIKit
import FMDB

class AddViewController:UIViewController, UITextViewDelegate {
    var databasePath = String()
    
    @IBOutlet weak var mTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docDir = dirPaths[0]
        
        databasePath = docDir + "/todoList.db"
        
        mTextView.textColor = UIColor.lightGray
        mTextView.text = "할 일을 입력해주세요."
        mTextView.delegate = self
        print("333333")
    }
        
    @IBAction func viewClose(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func addList(_ sender: UIButton) {
        if let value1 = mTextView.text {
            if value1 != "할 일을 입력해주세요." {
                let db = FMDatabase(path: databasePath)
                if db.open() {
                    let query1 = "insert into todoList (todo, done) values ('\(value1)', 0)"
                    if !db.executeUpdate(query1, withArgumentsIn: []) {
                        NSLog("저장 실패")
                    } else {
                        NSLog("저장 성공")
                    }
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }

        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "할 일을 입력해주세요."
            textView.textColor = UIColor.lightGray
        }
    }
}
