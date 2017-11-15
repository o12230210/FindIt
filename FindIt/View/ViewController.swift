//
//  ViewController.swift
//  FindIt
//
//  Created by Koki Nagatani on 2017/11/09.
//  Copyright © 2017年 Koki Nagatani. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


extension UIColor {
    class var theme: UIColor { return #colorLiteral(red: 0.999717176, green: 0.6463285685, blue: 0.007703759708, alpha: 1) }
    class var theme_sub: UIColor { return #colorLiteral(red: 0.9930148721, green: 0.8213359714, blue: 0.02535311319, alpha: 1) }
	class var OKbutton: UIColor { return #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1) }
	class var NGbutton: UIColor { return #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1) }
	class var card : UIColor { return #colorLiteral(red: 0.9905192256, green: 0.9350119233, blue: 0.4534321427, alpha: 1) }
}

struct fontSize {
	static let title_main : CGFloat = 50
    static let title_sub : CGFloat = 25
	static let correctButton : CGFloat = 70
	static let card : CGFloat = 40
}

struct viewSize  {
    static let fieldHeight : CGFloat = 50
    static let buttonHeight : CGFloat = 45
	static let labelHeight : CGFloat = 50
	static let candidateMargin : CGFloat = 10
	static let correctButton : CGFloat = 70	// 丸ばつボタンのサイズ

}

class ViewController: UIViewController, UITextFieldDelegate {
    
	private var mainView : UIViewController!
    private var candidateView : CandidateViewController!
	private var resultView : ResultViewController!
    
    private var titleLabel : SpringLabel!
    private var label : UILabel!
    private var field : UITextField!
    private var findButton: SpringButton!
	
	private var rightSwipe : UISwipeGestureRecognizer!
	private var leftSwipe : UISwipeGestureRecognizer!
	private var startSwipe : CGPoint!
	private var endSwipe : CGPoint!
	
	private var connection : Connection!
	var message = Message()
	var round : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
		self.connection = Connection(mainViewController:self)
		self.connection.delegate = self
		
        self.mainPosition()
        
		// スワイプ動作の初期化
		let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.didSwipe(_:)))
		rightSwipe.direction = .right
		
		let leftSwipe = UISwipeGestureRecognizer(target: self, action:  #selector(ViewController.didSwipe(_:)))
		leftSwipe.direction = .left
		
		// スワイプ動作の追加
		view.addGestureRecognizer(rightSwipe)
		view.addGestureRecognizer(leftSwipe)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
    // MARK:function
	func setRecvText(){
		self.connection.setRecvText(str: self.field.text!)
		self.round+=1
	}
	
    // 選択肢をだすビューを表示
    private func addCandidateView(){
        // 古いビューを削除
        if(self.candidateView != nil) {
			self.candidateView.view.removeFromSuperview()
            self.candidateView.removeFromParentViewController()
            self.candidateView = nil
        }
        
        // コンテナに追加
		self.candidateView = CandidateViewController(mainViewController:self)
		self.candidateView.view.frame = CGRect(x:viewSize.candidateMargin , y:self.view.bounds.size.height/6, width:self.view.bounds.size.width-viewSize.candidateMargin*2, height:self.view.bounds.size.height/6*4)
		addChildViewController(self.candidateView)
        view.addSubview(self.candidateView.view)
        self.candidateView.didMove(toParentViewController: self)
		
        return
    }
    
    
    private func mainPosition(){
        // Label
        if(self.titleLabel == nil){
            self.titleLabel = SpringLabel()
            self.titleLabel.text = NSLocalizedString("Find It!", comment: "")
            self.titleLabel.textAlignment = .center
            self.view.addSubview(self.titleLabel)
        }
		self.titleLabel.font = self.titleLabel.font.withSize(fontSize.title_main);
		self.titleLabel.frame = CGRect(x:0, y:0, width:self.view.bounds.width, height:self.view.bounds.height/5*2)
        
        if(self.mainView == nil){
			self.mainView = UIViewController()
            self.mainView.view.frame = CGRect(x: 0,y: self.view.bounds.height/5*2, width:self.view.bounds.width, height:self.view.bounds.height/5*1)
			self.view.addSubview(self.mainView.view)
            // Label
            if(self.label == nil){
                self.label = UILabel()
                self.label.frame = CGRect(x:0, y:0, width:self.view.bounds.width, height:viewSize.labelHeight)
                self.label.text = NSLocalizedString("探しものは何ですか?", comment: "")
                self.label.font = self.label.font.withSize(20);
                self.label.textAlignment = .center
                self.mainView.view.addSubview(self.label)
            }
			self.titleLabel.animation = "squeezeDown"
			self.titleLabel.animate()
			
            // テキストフィールド
            if(self.field == nil){
                self.field = UITextField()
                self.field.frame = CGRect(x:0, y:viewSize.labelHeight, width:self.view.bounds.width/4*3, height:viewSize.fieldHeight)
                self.field.borderStyle = .roundedRect
                self.field.textAlignment = .center
				self.field.center.x = self.view.center.x

				self.mainView.view.addSubview(self.field)
                self.field.delegate = self
            }
        } else {
            self.mainView.view.isHidden = false
        }
        
        // ボタン
        if(self.findButton == nil){
            self.findButton = SpringButton()
            self.findButton.layer.masksToBounds = true
            self.findButton.layer.cornerRadius = 10.0
            self.findButton.tag = 1
            self.findButton.setTitleColor(.white, for: .normal)
            
            self.findButton.addTarget(self, action: #selector(ViewController.onClick(_:)), for:.touchUpInside)
            self.view.addSubview(self.findButton)
        } else {
            self.findButton.isHidden = false
        }
        self.findButton.frame = CGRect(x:0, y:self.view.bounds.height/5*3, width:self.view.bounds.width/3*2, height:viewSize.buttonHeight)
		self.findButton.center.x = self.view.center.x
		self.findButton.backgroundColor = .theme
        //   通常
        self.findButton.setTitle(NSLocalizedString("検索", comment: ""), for: .normal)
		self.findButton.animation = "squeezeUp"
		self.findButton.animate()
		
        // 設定アイコン
        // Buttonが画面の中央で横幅いっぱいのサイズになるように設定
        let settingButton = UIButton()
        settingButton.frame = CGRect(x:self.view.frame.size.width-50, y:0,
                              width:30, height:30)
        settingButton.setImage(UIImage(named: "SettingIcon"), for: .normal)
        settingButton.imageView?.contentMode = .scaleAspectFit
        self.mainView.view.addSubview(settingButton)
        
        // タップされたときのactionをセット
        settingButton.addTarget(self, action: #selector(ViewController.settingButtonTapped(sender:)), for: .touchUpInside)

        // いらないビューが出ていたら削除
		if(self.candidateView != nil) {
			UIView.transition(from: self.candidateView.view, to: self.mainView.view, duration: 0.6, options: .curveLinear, completion: { _ in
				self.candidateView.willMove(toParentViewController: nil)
				self.candidateView.view.removeFromSuperview()
				self.candidateView.removeFromParentViewController()
				self.candidateView = nil
			})
		}
		
		if(self.resultView != nil) {
			self.resultView.view.removeFromSuperview()
			self.resultView.removeFromParentViewController()
			self.resultView = nil
		}
	}
    
    private func candidatePosition(){
        self.mainView.view.isHidden = true
        
        self.titleLabel.frame = CGRect(x:0, y:0, width:self.view.bounds.width, height:self.view.bounds.height/6)
        self.titleLabel.font = self.titleLabel.font.withSize(30);
        self.titleLabel.animation = "slideUp"
        self.titleLabel.animate()
        
        //   ボタンを検索中にする　→
        self.findButton.frame = CGRect(x:0, y:self.view.bounds.height/7*6, width:self.view.bounds.width/3*2, height:viewSize.fieldHeight)
		self.findButton.center.x = self.view.center.x
        self.findButton.setTitle(NSLocalizedString("検索中", comment: ""), for: .normal)
        self.findButton.animation = "slideDown"
        self.findButton.animate()
        self.findButton.backgroundColor = .theme_sub
		
    }
    
    private func searchedPosition(){
		self.mainView.view.isHidden = true
		
        //   ボタンをあきらめるにする
        self.findButton.setTitle(NSLocalizedString("あきらめる", comment: ""), for: .normal)

		self.addCandidateView()
    }
    
    public func ResultPosition(result: Bool) {
		self.mainView.view.isHidden = true
		
		if (self.candidateView != nil) {
			// ★情報の送信
			
			self.findButton.isHidden = true
			self.candidateView.view.removeFromSuperview()
			self.candidateView.removeFromParentViewController()
			self.candidateView = nil
		}
        self.resultView = ResultViewController(result:result)
        self.addChildViewController(self.resultView)
        self.view.addSubview(self.resultView.view)
        self.resultView.didMove(toParentViewController: self)

    }
	
	
	// MARK:action
	// スワイプ時の処理
	@objc func didSwipe(_ sender: UISwipeGestureRecognizer) {
		if sender.direction == .right {
//			let alertController = UIAlertController(title: "test",message: "あきらめて踊ろう", preferredStyle: UIAlertControllerStyle.alert)
//			let cancelButton = UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.cancel, handler: nil)
//			alertController.addAction(cancelButton)
//			present(alertController,animated: true,completion: nil)

			print("didSwipe")
			// 候補表示中のとき
			self.mainPosition()
		}
		else if sender.direction == .left {
		}
	}
	
	func panGesture(_ sender: UIPanGestureRecognizer) {
		
		if (sender.state == .began) {
			self.startSwipe = sender.location(in: self.view)
		}
		else if (sender.state == .ended) {
			self.endSwipe = sender.location(in: self.view)
			var dx = self.endSwipe.x - self.startSwipe.x
			var dy = self.endSwipe.y - self.startSwipe.y
			var distance = sqrt(dx*dx + dy*dy );
			print(distance)
		}
	}

	// ボタンクリック時の動作
    @objc func onClick(_ sender: AnyObject) {
		
		// メイン画面
		if (self.candidateView == nil) {
			// 表示を変更
			self.candidatePosition()
			// 検索開始
			self.setRecvText()
		}
		else {
			// 候補表示中
			self.ResultPosition(result: false)
		}
		return
    }
    
    
    // ボタンクリック時の動作
    @objc func settingButtonTapped(sender: AnyObject) {
        let settingViewController: SettingViewController = SettingViewController()
        // アニメーションを設定する.
        settingViewController.modalTransitionStyle = .flipHorizontal
        // Viewの移動する.
        self.present(settingViewController, animated: true, completion: nil)
    }
	
	// MARK:UITextFieldDelegate
	// キーボードを閉じる
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}

extension ViewController: ConnectionDelegate {
	func done() {
		// 付箋たちを出す
		self.searchedPosition()
	}
}
