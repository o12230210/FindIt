//
//  ViewController.swift
//  FindIt
//
//  Created by Koki Nagatani on 2017/11/09.
//  Copyright © 2017年 Koki Nagatani. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    private var label : UILabel = UILabel()
    private var field : UITextField = UITextField()
    private var button: UIButton = UIButton()
	
	private var rightSwipe : UISwipeGestureRecognizer!
	private var leftSwipe : UISwipeGestureRecognizer!

	private var candidateView : CandidateViewController!
	
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Label
        self.label.text = NSLocalizedString("main-description", comment: "")
        self.label.sizeToFit()
        self.label.textAlignment = .center
        self.view.addSubview(self.label)
        
        // テキストフィールド
		self.field.sizeToFit()
		self.field.text = ""
        self.field.borderStyle = .roundedRect
        self.field.textAlignment = .center
        self.view.addSubview(self.field)
		self.field.delegate = self
        
        // ボタン
		self.button.sizeToFit()
        self.button.backgroundColor = .orange
        self.button.layer.masksToBounds = true
		self.button.layer.cornerRadius = 10.0
		self.button.tag = 1
		//   通常
        self.button.setTitle(NSLocalizedString("find", comment: ""), for: .normal)
        self.button.setTitleColor(.white, for: .normal)
        //   押した時
        self.button.setTitle("find", for: .highlighted)
        self.button.setTitleColor(.yellow, for: .highlighted)
		
		self.button.addTarget(self, action: #selector(ViewController.onClick(_:)), for:.touchUpInside)
        self.view.addSubview(self.button)
		
		self.mainPosition()
		
		// スワイプ動作の初期化
		self.rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.didSwipe(_:)))
		self.rightSwipe.direction = .right
		
		self.leftSwipe = UISwipeGestureRecognizer(target: self, action:  #selector(ViewController.didSwipe(_:)))
		self.leftSwipe.direction = .left
		
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	// 選択肢をだすビューを表示
	private func addCandidateView(){
		// 古いビューを削除
		if(self.candidateView != nil) {
			self.candidateView.removeFromParentViewController()
			self.candidateView = nil
		}
		
		// コンテナに追加
		self.candidateView = CandidateViewController()
		self.candidateView.view.frame = CGRect(x:0, y:self.view.bounds.height/4, width:self.view.bounds.width, height:self.view.bounds.height/4*3)
		addChildViewController(self.candidateView)
		view.addSubview(self.candidateView.view)
		self.candidateView.didMove(toParentViewController: self)

		return
	}
	
	// メインのViewたちの位置
	private func mainPosition(){
		self.label.frame = CGRect(x:0, y:self.view.bounds.height/4, width:self.view.bounds.width, height:50)
		self.field.frame = CGRect(x:0, y:0, width:self.view.bounds.width/4*3, height:50)
		self.field.center = self.view.center
		self.button.frame = CGRect(x:self.view.bounds.width/6, y:self.view.bounds.height/3*2, width:self.view.bounds.width/3*2, height:40)
	}

	// メインのビューたちが移動する位置
	private func candidatePosition(){
		self.label.frame = CGRect(x:0, y:self.view.bounds.height/8, width:self.view.bounds.width, height:50)
		self.field.isHidden = true
		self.button.isHidden = true
	}

	//
	private func addGesture() {
		self.view.addGestureRecognizer(self.rightSwipe)
		self.view.addGestureRecognizer(self.leftSwipe)
	}
	
	
	
	// MARK:action

	// スワイプ時の処理
	@objc func didSwipe(_ sender: UISwipeGestureRecognizer) {
		if sender.direction == .right {
		}
		else if sender.direction == .left {
			
			addCandidateView()
		}
	}

	
	// ボタンクリック時の動作
	
    @objc func onClick(_ sender: AnyObject) {
//		let alertController = UIAlertController(title: "test",message: "test", preferredStyle: UIAlertControllerStyle.alert)
//		let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
//		alertController.addAction(okAction)
//		present(alertController,animated: true,completion: nil)
		
		self.candidatePosition()
		self.addCandidateView()
		
		// スワイプ動作の追加
		let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.didSwipe(_:)))
		rightSwipe.direction = .right
		view.addGestureRecognizer(rightSwipe)
		
		let leftSwipe = UISwipeGestureRecognizer(target: self, action:  #selector(ViewController.didSwipe(_:)))
		leftSwipe.direction = .left
		view.addGestureRecognizer(leftSwipe)

		return
    }

	
	// MARK:UITextFieldDelegate
	// キーボードを閉じる
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}

