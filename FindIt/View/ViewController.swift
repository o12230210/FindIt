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

}

enum fontSize : CGFloat {
    case title_main = 50
    case title_sub = 25
}

enum viewSize : CGFloat {
    case fieldHeight = 50
    case buttonHeight = 55
}

class ViewController: UIViewController, UITextFieldDelegate {
    
    private var mainView : UIView!
    private var candidateView : CandidateViewController!
    
    private var titleLabel : SpringLabel!
    private var label : UILabel!
    private var field : UITextField!
    private var findButton: SpringButton!
	
	private var rightSwipe : UISwipeGestureRecognizer!
	private var leftSwipe : UISwipeGestureRecognizer!

    private var connection = Connection()
    private var message = Message()
    
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
	
    // MARK:function
	private func addGesture() {
		self.view.addGestureRecognizer(self.rightSwipe)
		self.view.addGestureRecognizer(self.leftSwipe)
	}
	

    // 選択肢をだすビューを表示
    private func addCandidateView(){
        // 古いビューを削除
        if(self.candidateView != nil) {
            self.candidateView.removeFromParentViewController()
            self.candidateView = nil
        }
        
        // コンテナに追加
        self.candidateView = CandidateViewController(message:self.message)
        self.candidateView.view.frame = CGRect(x:self.view.bounds.size.width/8 , y:self.view.bounds.size.height/6, width:self.view.bounds.size.width/8*6, height:self.view.bounds.size.height/6*4)
        addChildViewController(self.candidateView)
        view.addSubview(self.candidateView.view)
        self.candidateView.didMove(toParentViewController: self)
        
        print(self.view.bounds)
        print(self.candidateView.view.frame)
        
        return
    }
    
    
    private func mainPosition(){
        // Label
        if(self.titleLabel == nil){
            self.titleLabel = SpringLabel()
            self.titleLabel.text = NSLocalizedString("title", comment: "")
            self.titleLabel.font = self.titleLabel.font.withSize(fontSize.title_main.rawValue);
            self.titleLabel.textAlignment = .center
            self.titleLabel.baselineAdjustment = .alignCenters;
            self.view.addSubview(self.titleLabel)
        }
    
        self.titleLabel.frame = CGRect(x:0, y:0, width:self.view.bounds.width, height:self.view.bounds.height/6*2)
        
        if(self.mainView == nil){
            self.mainView = UIView(frame: CGRect(x: 10,y: 10, width:200, height:200))
            self.mainView.backgroundColor = .black
            // Label
            if(self.label == nil){
                self.label = UILabel()
                self.label.frame = CGRect(x:0, y:self.view.bounds.height/6*2, width:self.view.bounds.width, height:50)
                self.label.text = NSLocalizedString("main-description", comment: "")
                self.label.font = self.label.font.withSize(20);
                self.label.textAlignment = .center
                self.mainView.addSubview(self.label)
            }
            
            // テキストフィールド
            if(self.field == nil){
                self.field = UITextField()
                self.field.frame = CGRect(x:0, y:0, width:self.view.bounds.width/4*3, height:viewSize.fieldHeight.rawValue)
                self.field.borderStyle = .roundedRect
                self.field.textAlignment = .center
                self.mainView.addSubview(self.field)
                self.field.delegate = self
                self.field.center = self.view.center
            }
        } else {
            self.mainView.isHidden = false
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
        self.findButton.frame = CGRect(x:self.view.bounds.width/6, y:self.view.bounds.height/5*3, width:self.view.bounds.width/3*2, height:viewSize.buttonHeight.rawValue)
        self.findButton.backgroundColor = .theme
        //   通常
        self.findButton.setTitle(NSLocalizedString("find", comment: ""), for: .normal)
        
    }
    
    private func candidatePosition(){
        self.mainView.isHidden = true
        
        self.titleLabel.frame = CGRect(x:0, y:0, width:self.view.bounds.width, height:self.view.bounds.height/6)
        self.titleLabel.font = self.titleLabel.font.withSize(30);
        self.titleLabel.animation = "slideUp"
        self.titleLabel.animate()
        
        //   ボタンを検索中にする　→
        self.findButton.frame = CGRect(x:self.view.bounds.width/6, y:self.view.bounds.height/7*6, width:self.view.bounds.width/3*2, height:viewSize.fieldHeight.rawValue)
        self.findButton.setTitle(NSLocalizedString("検索中", comment: ""), for: .normal)
        self.findButton.animation = "slideDown"
        self.findButton.animate()
        self.findButton.backgroundColor = .theme_sub
    }
    
    private func searchedPosition(){
        //   ボタンをあきらめるにする
        self.findButton.setTitle(NSLocalizedString("あきらめる", comment: ""), for: .normal)

    }
    
    private func ResultPosition(result: Bool) {
        self.findButton.isHidden = true
    
    }
    
    private func sendToServer(str:String){
        // 受信したJSONのパース
        
        
    }
	
	
	// MARK:action
	// スワイプ時の処理
	@objc func didSwipe(_ sender: UISwipeGestureRecognizer) {
		if sender.direction == .right {
            //addCandidateView()
            let alertController = UIAlertController(title: "test",message: "あきらめて踊ろう", preferredStyle: UIAlertControllerStyle.alert)
            let cancelButton = UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.cancel, handler: nil)
            alertController.addAction(cancelButton)
            present(alertController,animated: true,completion: nil)

		}
		else if sender.direction == .left {
		}
	}

	// ボタンクリック時の動作
    @objc func onClick(_ sender: AnyObject) {
		
        let listUrl = "https://kuromusubi.com/findit/?item="
            + self.field.text!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        Alamofire.request(listUrl).responseJSON{ response in
            
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                // 変数keysにdictのkeyのみを取り出す
                var keys : Array = Array(dict.keys)
                // keysを昇順でソートする
                keys.sort(by:{$0 < $1})
                
            
            
            let json = JSON(response.result.value)
            
            var recvText = [[String: String]]()
                
            for i in keys {
                let id = json[i]["id"].int!
                let place = json[i]["place"].string!
                
                recvText.append(["id":String(id),"place":place])
        
            }
            
                
                
            print(recvText)
            
            self.message.recvText = recvText

            self.addCandidateView()
            self.searchedPosition()

            }
        }
        
        self.candidatePosition();
		
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

