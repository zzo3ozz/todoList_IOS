//
//  TodoCell.swift
//  todoList
//
//  Created by 한서영 on 2022/08/01.
//

import UIKit

class TodoCell:UITableViewCell {
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var tdLabel: UILabel!
    var filled = false
    
    @IBAction func doCheck(_ sender: Any) {
        if filled {
            checkBtn.setImage(UIImage(systemName: "circle"), for: .normal)
            filled = false
        } else {
            checkBtn.setImage(UIImage(systemName: "circle.inset.filled"), for: .normal)
            filled = true
        }
        

    }

}
