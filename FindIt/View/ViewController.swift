
//
//  ViewController.swift
//  FindIt
//
//  Created by Koki Nagatani on 2017/11/09.
//  Copyright © 2017年 Koki Nagatani. All rights reserved.
//

import UIKit

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
	static let candidateMargin : CGFloat = 40
	static let correctButton : CGFloat = 70	// 丸ばつボタンのサイズ
}

class ViewController: UIViewController, UITextFieldDelegate {
    
    private var field = UITextField()
    private var findButton = SpringButton()
	private var startSwipe : CGPoint!
	private var endSwipe : CGPoint!
	
	private var connection : Connection!
	var message = Message()
	var round : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = .white
        
		self.connection = Connection()
		self.connection.delegate = self
		
        // Label
        let titleLabel = SpringLabel()
        titleLabel.text = NSLocalizedString("Find It!", comment: "")
        titleLabel.textAlignment = .center
        titleLabel.font = titleLabel.font.withSize(fontSize.title_main);
        titleLabel.frame = CGRect(x:0, y:0, width:self.view.bounds.width, height:self.view.bounds.height/5*2)
        self.view.addSubview(titleLabel)
        
        titleLabel.animation = "squeezeDown"
        titleLabel.animate()

        let label = UILabel()
        label.frame = CGRect(x:0, y:self.view.bounds.height/5*2-viewSize.fieldHeight, width:0, height:0)
        label.text = NSLocalizedString("探しものは何ですか?", comment: "")
        label.font = label.font.withSize(20);
        label.sizeToFit()
        label.center.x = self.view.center.x
        self.view.addSubview(label)
        
        self.field.frame = CGRect(x:0, y:self.view.bounds.height/5*2, width:self.view.bounds.width/4*3, height:viewSize.fieldHeight)
        self.field.borderStyle = .roundedRect
        self.field.textAlignment = .center
        self.field.center.x = self.view.center.x
                
        self.view.addSubview(self.field)
        self.field.delegate = self
 
        // ボタン
        self.findButton.setTitle(NSLocalizedString("検索", comment: ""), for: .normal)
        self.findButton.setTitle(NSLocalizedString("検索中", comment: ""), for: .selected)

        self.findButton.layer.masksToBounds = true
        self.findButton.layer.cornerRadius = 10.0
        self.findButton.setTitleColor(.white, for: .normal)
        self.findButton.frame = CGRect(x:0, y:self.view.bounds.height/5*3, width:self.view.bounds.width/3*2, height:viewSize.buttonHeight)
        self.findButton.center.x = self.view.center.x
        self.findButton.backgroundColor = .theme
        self.findButton.addTarget(self, action: #selector(ViewController.onClick(_:)), for:.touchUpInside)
        view.addSubview(self.findButton)
        
        //   通常
        self.findButton.animation = "squeezeUp"
        self.findButton.animate()
        
        // 設定アイコン
        let settingButton = UIButton()
        settingButton.frame = CGRect(x:self.view.frame.size.width-50, y:50,
                                     width:30, height:30)
        settingButton.setImage(UIImage(named: "SettingIcon"), for: .normal)
        settingButton.imageView?.contentMode = .scaleAspectFit
        self.view.addSubview(settingButton)
        
        // タップされたときのactionをセット
        settingButton.addTarget(self, action: #selector(ViewController.settingButtonTapped(sender:)), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.field.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning()  {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
    // MARK:function
	func setRecvText(){
		self.connection.getCandidateList(str: self.field.text!)
		self.round+=1
	}
	
//    // 選択肢をだすビューを表示
//    private func addCandidateView(){
//        // 古いビューを削除
//        if(self.candidateView != nil) {
//            self.candidateView.view.removeFromSuperview()
//            self.candidateView.removeFromParentViewController()
//            self.candidateView = nil
//        }
//
//        // コンテナに追加
//        self.candidateView = CandidateViewController(mainViewController:self)
//        self.candidateView.view.frame = CGRect(x:viewSize.candidateMargin , y:self.view.bounds.size.height/6, width:self.view.bounds.size.width-viewSize.candidateMargin*2, height:self.view.bounds.size.height/6*4)
//        addChildViewController(self.candidateView)
//        view.addSubview(self.candidateView.view)
//        self.candidateView.didMove(toParentViewController: self)
//
//        return
//    }
//
//    private func candidatePosition(){
//        self.mainView.view.isHidden = true
//
//        self.titleLabel.frame = CGRect(x:0, y:0, width:self.view.bounds.width, height:self.view.bounds.height/6)
//        self.titleLabel.font = self.titleLabel.font.withSize(30);
//        self.titleLabel.animation = "slideUp"
//        self.titleLabel.animate()
//
//        //   ボタンを検索中にする　→
//        self.findButton.frame = CGRect(x:0, y:self.view.bounds.height/7*6, width:self.view.bounds.width/3*2, height:viewSize.fieldHeight)
//        self.findButton.center.x = self.view.center.x
//        self.findButton.setTitle(NSLocalizedString("検索中", comment: ""), for: .normal)
//        self.findButton.animation = "slideDown"
//        self.findButton.animate()
//        self.findButton.backgroundColor = .theme_sub
//
//    }
//
//    private func searchedPosition(){
//        self.mainView.view.isHidden = true
//
//        //   ボタンをあきらめるにする
//        self.findButton.setTitle(NSLocalizedString("あきらめる", comment: ""), for: .normal)
//
//        self.addCandidateView()
//    }
//
//    public func ResultPosition(result: Bool) {
//        self.mainView.view.isHidden = true
//
//        if (self.candidateView != nil) {
//            // ★情報の送信
//
//            self.findButton.isHidden = true
//            self.candidateView.view.removeFromSuperview()
//            self.candidateView.removeFromParentViewController()
//            self.candidateView = nil
//        }
//        self.resultView = ResultViewController(result:result)
//        self.addChildViewController(self.resultView)
//        self.view.addSubview(self.resultView.view)
//        self.resultView.didMove(toParentViewController: self)
//
//    }
	
	// MARK:action

	// ボタンクリック時の動作
    @objc func onClick(_ sender: AnyObject) {
        // ★検索中にする
        self.findButton.isSelected = true
        
        // 検索開始
        self.setRecvText()
		return
    }
    
    // ボタンクリック時の動作
    @objc func settingButtonTapped(sender: AnyObject) {
        let settingViewController: SettingViewController = SettingViewController()
        // SecondViewに移動する.
        self.navigationController?.pushViewController(settingViewController, animated: true)
    }
	
	// MARK:UITextFieldDelegate
	// キーボードを閉じる
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}

extension ViewController: ConnectionDelegate {
	func done(data:Data) {
		self.message.setCandidateList(data:data)
		
		DispatchQueue.main.async {
            self.findButton.isSelected = false
            
            let candidateViewController = CandidateViewController(mainViewController:self)
            // SecondViewに移動する.
            self.navigationController?.pushViewController(candidateViewController, animated: true)
        }
	}
}
