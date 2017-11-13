//
//  CandidateController.swift
//  FindIt
//
//  Created by Koki Nagatani on 2017/11/09.
//  Copyright © 2017年 Koki Nagatani. All rights reserved.
//


import UIKit

class ResultViewController: UIViewController {
	
	var result : Bool
	
	init(result : Bool) {
		self.result = result

		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		let label = UILabel()
		label.text = "♪♫ ✌('ω'✌ )三✌('ω')✌三( ✌'ω')✌ ♫♪"
		label.sizeToFit()
		label.center = self.view.center
		
		if (!result){
			label.text = "٩(๑`^´๑)۶༄༅༄༅༄༅༄༅"
		}
		
		view.addSubview(label)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	// MARK:function
	
	// MARK:action
}
