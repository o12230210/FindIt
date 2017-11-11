//
//  ViewController.swift
//  FindIt
//
//  Created by Koki Nagatani on 2017/11/09.
//  Copyright © 2017年 Koki Nagatani. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    private var titleLabel : UILabel!
    private var label : UILabel!
    private var field : UITextField!
    private var findButton: UIButton!
	
	private var rightSwipe : UISwipeGestureRecognizer!
	private var leftSwipe : UISwipeGestureRecognizer!

	private var candidateView : CandidateViewController!
	
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
				
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
		self.candidateView.view.frame = CGRect(x:0 , y:self.view.bounds.size.height/6, width:self.view.bounds.size.width/6*4, height:self.view.bounds.size.height/6*4)
		addChildViewController(self.candidateView)
		view.addSubview(self.candidateView.view)
		self.candidateView.didMove(toParentViewController: self)
        
        print(self.view.bounds)
        print(self.candidateView.view.frame)


		return
	}
	
    // MARK:function
	private func addGesture() {
		self.view.addGestureRecognizer(self.rightSwipe)
		self.view.addGestureRecognizer(self.leftSwipe)
	}
	
    private func candidatePosition(){
        self.titleLabel.frame = CGRect(x:0, y:0, width:self.view.bounds.width, height:self.view.bounds.height/6)
    }
    
    private func mainPosition(){
        // Label
        if(self.titleLabel == nil){
            self.titleLabel = UILabel()
            self.titleLabel.text = NSLocalizedString("title", comment: "")
            self.titleLabel.font = self.titleLabel.font.withSize(50);
            self.titleLabel.textAlignment = .center
            self.titleLabel.baselineAdjustment = .alignCenters;
            self.view.addSubview(self.titleLabel)
        }
        
        self.titleLabel.frame = CGRect(x:0, y:0, width:self.view.bounds.width, height:self.view.bounds.height/6*2)
        
        
        // Label
        if(self.label == nil){
            self.label = UILabel()
            self.label.frame = CGRect(x:0, y:self.view.bounds.height/6*2, width:self.view.bounds.width, height:50)
            self.label.text = NSLocalizedString("main-description", comment: "")
            self.label.font = self.label.font.withSize(20);
            self.label.textAlignment = .center
            self.view.addSubview(self.label)
        }
        
        // テキストフィールド
        if(self.field == nil){
            self.field = UITextField()
            self.field.frame = CGRect(x:0, y:0, width:self.view.bounds.width/4*3, height:50)
            self.field.borderStyle = .roundedRect
            self.field.textAlignment = .center
            self.view.addSubview(self.field)
            self.field.delegate = self
            self.field.center = self.view.center
        }

        
        // ボタン
        if(self.findButton == nil){
            self.findButton = UIButton()
            self.findButton.frame = CGRect(x:self.view.bounds.width/6, y:self.view.bounds.height/3*2, width:self.view.bounds.width/3*2, height:40)
            self.findButton.backgroundColor = .orange
            self.findButton.layer.masksToBounds = true
            self.findButton.layer.cornerRadius = 10.0
            self.findButton.tag = 1
            //   通常
            self.findButton.setTitle(NSLocalizedString("find", comment: ""), for: .normal)
            self.findButton.setTitleColor(.white, for: .normal)
            
            self.findButton.addTarget(self, action: #selector(ViewController.onClick(_:)), for:.touchUpInside)
            self.view.addSubview(self.findButton)
        }

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
		
        self.candidatePosition();
		self.addCandidateView()
		
		// スワイプ動作の追加
		view.addGestureRecognizer(self.rightSwipe)
        view.addGestureRecognizer(self.leftSwipe)

		return
    }
	
	// MARK:UITextFieldDelegate
	// キーボードを閉じる
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}

