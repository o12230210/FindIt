////
////  CandidateController.swift
////  FindIt
////
////  Created by Koki Nagatani on 2017/11/09.
////  Copyright © 2017年 Koki Nagatani. All rights reserved.
////
//
//
//import UIKit
//
//class ViewController: UIViewController, UITextFieldDelegate {
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
//        
//        
//        // Label
//        let label = UILabel()
//        label.text = NSLocalizedString("main-description", comment: "")
//        label.frame = CGRect(x:0, y:self.view.bounds.height/4, width:self.view.bounds.width, height:100)
//        label.textAlignment = .center
//        self.view.addSubview(label)
//        
//        // テキストフィールド
//        let field = UITextField()
//        field.frame = CGRect(x:0, y:0, width:self.view.bounds.width/4*3, height:50)
//        field.text = "Hello Swift!!"
//        field.delegate = self
//        field.borderStyle = .roundedRect
//        field.textAlignment = .center
//        field.center = self.view.center
//        self.view.addSubview(field)
//        
//        // ボタン
//        let button = UIButton()
//        button.frame = CGRect(x:self.view.bounds.width/6, y:self.view.bounds.height/3*2, width:self.view.bounds.width/3*2, height:40)
//        button.backgroundColor = .orange
//        button.layer.masksToBounds = true
//        button.setTitle(NSLocalizedString("find", comment: ""), for: .normal)
//        button.setTitleColor(.white, for: .normal)
//        
//        button.setTitle("find", for: .highlighted)
//        button.setTitleColor(.yellow, for: .highlighted)
//        
//        button.layer.cornerRadius = 10.0
//        
//        
//        button.tag = 1
//        
//        button.addTarget(self, action: "onClickMyButton:", for:.touchUpInside)
//        
//        self.view.addSubview(button)
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    
//}

