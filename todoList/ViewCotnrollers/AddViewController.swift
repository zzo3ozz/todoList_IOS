//
//  AddViewController.swift
//  todoList
//
//  Created by 한서영 on 2022/08/01.
//

import UIKit

class AddViewController:UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func viewClose(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
