//
//  CandidateController.swift
//  FindIt
//
//  Created by Koki Nagatani on 2017/11/09.
//  Copyright © 2017年 Koki Nagatani. All rights reserved.
//


import UIKit

class CandidateViewController: UIViewController {
	private var label : UILabel = UILabel()
	
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
		
		self.view.backgroundColor = .orange
		
		
		
        // Label
		let date = Date()
		let calendar = Calendar.current
		let second = calendar.component(.second, from: date)
		self.label.text = String(second)
		self.label.sizeToFit()
		self.label.textAlignment = .center
		self.view.addSubview(self.label)
    }
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	// MARK:function
	
	// MARK:action
	@objc func onClick(_ sender: AnyObject) {

		
		return
		
	}
	
	deinit{
		//ここで解放処理
		print("★");
	}

}

