//
//  CandidateController.swift
//  FindIt
//
//  Created by Koki Nagatani on 2017/11/09.
//  Copyright © 2017年 Koki Nagatani. All rights reserved.
//


import UIKit
import RealmSwift



class SettingConfigViewController: UIViewController {

	private var itemField = UITextField()
	private var nameField = UITextField()
	
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

		self.view.backgroundColor = .white

		self.itemField.frame = CGRect(x:0, y:viewSize.labelHeight, width:self.view.bounds.width/4*3, height:viewSize.fieldHeight)
		self.itemField.borderStyle = .roundedRect
		self.view.addSubview(self.itemField)
		//        self.itemField.delegate = self
		
		self.nameField.frame = CGRect(x:0, y:viewSize.labelHeight+50, width:self.view.bounds.width/4*3, height:viewSize.fieldHeight)
		self.nameField.borderStyle = .roundedRect
		self.view.addSubview(self.nameField)
		//        self.nameField.delegate = self
		

		
        let label = UILabel()
        label.text = "Setting"
        label.sizeToFit()
        label.center = self.view.center

        view.addSubview(label)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK:function
    func addData(data:LocalData){
        // Realmのインスタンスを取得
        let realm = try! Realm()

        // データを追加
        try! realm.write() {
            realm.add(data, update: true)  // データが無ければ追加、あったら上書き
        }
    }




    // MARK:action
}



