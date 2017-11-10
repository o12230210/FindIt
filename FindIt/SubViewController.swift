//
//  SubViewController.swift
//  FindIt
//
//  Created by appletaro on 2017/11/10.
//  Copyright © 2017年 Koki Nagatani. All rights reserved.
//

import UIKit

class SubViewController: UIViewController {
	private var candidateViewController : CandidateViewController = CandidateViewController()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		self.view.backgroundColor = .blue
		
		self.candidateViewController.view.frame = CGRect(x:0, y:self.view.bounds.height/4, width:self.view.bounds.width, height:self.view.bounds.height/4*3)
		view.addSubview(self.candidateViewController.view)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	// MARK:function
	func createNewView(){
		
	}
	
	
	// MARK:action
	@objc func onClick(_ sender: AnyObject) {
		let alertController = UIAlertController(title: "test",message: "test", preferredStyle: UIAlertControllerStyle.alert)
		let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
		alertController.addAction(okAction)
		present(alertController,animated: true,completion: nil)
		
		return
		
	}
	
}

