//
//  ViewController.swift
//  FindIt
//
//  Created by Koki Nagatani on 2017/11/09.
//  Copyright © 2017年 Koki Nagatani. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    var label : UILabel = UILabel()
    var field : UITextField = UITextField()
    var button: UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Label
        self.label.text = NSLocalizedString("main-description", comment: "")
        self.label.frame = CGRect(x:0, y:self.view.bounds.height/4, width:self.view.bounds.width, height:100)
        self.label.textAlignment = .center
        self.view.addSubview(self.label)
        
        // テキストフィールド
        self.field.frame = CGRect(x:0, y:0, width:self.view.bounds.width/4*3, height:50)
        self.field.text = "Hello Swift!!"
        self.field.delegate = self
        self.field.borderStyle = .roundedRect
        self.field.textAlignment = .center
        self.field.center = self.view.center
        self.view.addSubview(self.field)
        
        // ボタン
        self.button.frame = CGRect(x:self.view.bounds.width/6, y:self.view.bounds.height/3*2, width:self.view.bounds.width/3*2, height:40)
        self.button.backgroundColor = .orange
        self.button.layer.masksToBounds = true
        //   通常
        self.button.setTitle(NSLocalizedString("find", comment: ""), for: .normal)
        self.button.setTitleColor(.white, for: .normal)
        //   押した時
        self.button.setTitle("find", for: .highlighted)
        self.button.setTitleColor(.yellow, for: .highlighted)

        self.button.layer.cornerRadius = 10.0
        
        self.button.tag = 1
        
//        self.button.addTarget(self, action: #selector(ViewController.onClick(sender:)), for:.touchUpInside)
        
        self.view.addSubview(self.button)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    // selfをデリゲートにしているので、ここにデリゲートメソッドを書く
//    func textFieldShouldReturn(textField: UITextField!) -> Bool {
//        self.view.endEditing(true)
//        return false
//    }
//
//
//    func onClick(sender: AnyObject) {
//
//    }
}

