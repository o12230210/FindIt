//
//  CandidateController.swift
//  FindIt
//
//  Created by Koki Nagatani on 2017/11/09.
//  Copyright © 2017年 Koki Nagatani. All rights reserved.
//


import UIKit
import Koloda

class CandidateViewController: UIViewController {
    
    var mainViewController : ViewController!
    
    private var kolodaView : KolodaView!
	private let OKbutton = UIButton()
	private let NGbutton = UIButton()
	
	private var frame : CGRect!
    
    init(mainViewController : ViewController) {
        self.mainViewController = mainViewController

		super.init(nibName: nil, bundle: nil)
    }
	
	deinit {
		self.kolodaView = nil
	}
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = .white
        
        let titleLabel = SpringLabel()
        titleLabel.frame = CGRect(x:0, y:0, width:self.view.bounds.width, height:self.view.bounds.height/6)
        titleLabel.text = NSLocalizedString("Find It!", comment: "")
        titleLabel.font = titleLabel.font.withSize(30)
        titleLabel.textAlignment = .center
        self.view.addSubview(titleLabel)
        titleLabel.animation = "slideDown"
        titleLabel.animate()
        
        self.kolodaView = KolodaView()
        self.view.addSubview(kolodaView)
        let cardSize = self.view.frame.width - viewSize.candidateMargin
        kolodaView.frame = CGRect(x:0, y:self.view.bounds.height/5, width:cardSize, height:cardSize)
        kolodaView.center.x = self.view.center.x
//		kolodaView.widthAnchor.constraint(equalTo:self.view.widthAnchor, constant: -10.0).isActive = true
		kolodaView.layer.shadowColor = UIColor.gray.cgColor        // シャドウカラー
		kolodaView.layer.shadowOffset = CGSize(width:1, height:1);        //  シャドウサイズ
		kolodaView.layer.shadowOpacity = 1.0;        // 透明度
		kolodaView.layer.shadowRadius = 1;        // 角度
        kolodaView.dataSource = self
        kolodaView.delegate = self
		
		OKbutton.frame = CGRect(x:self.view.frame.size.width/2+10, y:(self.view.frame.size.height + cardSize + 5) / 2, width:viewSize.correctButton, height:viewSize.correctButton)
		OKbutton.setTitle(NSLocalizedString("⚪︎", comment: ""), for: .normal)
		OKbutton.setTitleColor(.OKbutton, for: .normal)
		OKbutton.titleLabel?.font = OKbutton.titleLabel?.font.withSize(fontSize.correctButton);
		OKbutton.titleLabel?.textAlignment = .center;
		OKbutton.titleLabel?.baselineAdjustment = .alignCenters;
		OKbutton.addTarget(self, action: #selector(CandidateViewController.onOKClick(_:)), for:.touchUpInside)
		self.view.addSubview(OKbutton)

		NGbutton.frame = CGRect(x:self.view.frame.size.width/2-viewSize.correctButton-20, y:(self.view.frame.size.height + cardSize) / 2, width:viewSize.correctButton, height:viewSize.correctButton)
		NGbutton.setTitle(NSLocalizedString("×", comment: ""), for: .normal)
		NGbutton.setTitleColor(.NGbutton, for: .normal)
		NGbutton.titleLabel?.font = NGbutton.titleLabel?.font.withSize(fontSize.correctButton);
		NGbutton.titleLabel?.textAlignment = .center;
		NGbutton.titleLabel?.baselineAdjustment = .alignCenters;
		NGbutton.addTarget(self, action: #selector(CandidateViewController.onNGClick(_:)), for:.touchUpInside)
		self.view.addSubview(NGbutton)
        
        // ボタン
        let giveupButton = SpringButton()
        giveupButton.setTitle(NSLocalizedString("あきらめる", comment: ""), for: .normal)
        
        giveupButton.layer.masksToBounds = true
        giveupButton.layer.cornerRadius = 10.0
        giveupButton.setTitleColor(.white, for: .normal)
        giveupButton.frame = CGRect(x:0, y:self.view.bounds.height/5*4, width:self.view.bounds.width/3*2, height:viewSize.buttonHeight)
        giveupButton.center.x = self.view.center.x
        giveupButton.backgroundColor = .theme_sub
        giveupButton.addTarget(self, action: #selector(CandidateViewController.onClick(_:)), for:.touchUpInside)
        view.addSubview(giveupButton)
        
        //   通常
        giveupButton.animation = "squeezeUp"
        giveupButton.animate()
        
    }

    @objc func onClick(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
	@objc func onOKClick(_ sender: AnyObject) {
        self.OK();
    }
	@objc func onNGClick(_ sender: AnyObject) {
		self.kolodaView.swipe(_:.left, force: false)
	}

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:function
    func OK(){
        let viewController = ResultViewController(result:true)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    // MARK:action
}



extension CandidateViewController: KolodaViewDelegate {
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
		self.mainViewController.setRecvText()
        koloda.reloadData()
        print("finish")
//		self.mainViewController.ResultPosition(result:false)
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
//        UIApplication.shared.openURL(URL(string: "https://yalantis.com/")!)
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        switch direction {
        case .right:
			print("Swiped to right! : あった")
            self.OK();
            break;
            
        case .left:
			print("Swiped to left! : なかった")
            break;
			
        default:
            return
        }
	}
}


extension CandidateViewController: KolodaViewDataSource {
        
    func kolodaNumberOfCards(_ koloda:KolodaView) -> Int {
		print(self.mainViewController.message.candidateList.count)
        return self.mainViewController.message.candidateList.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .fast
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let view = UIView(frame: koloda.bounds)
        view.backgroundColor = randomColor()
//		view.backgroundColor = .white
//		view.backgroundColor = .card
		
        let label = UILabel()
		label.text = self.mainViewController.message.candidateList[index].place
		label.font = label.font.withSize(fontSize.card);
		label.frame = view.frame
		label.textAlignment = .center
        view.addSubview(label)
  
        // 画像がある場合
        let path = NSHomeDirectory() + "/Documents/" + String(self.mainViewController.message.candidateList[index].id) + ".png"
        if (FileManager().fileExists(atPath: path)){
            let data =  try! Data.init(contentsOf: URL(fileURLWithPath: path))
            let image = UIImageView(image:UIImage(data:data))
            image.frame = CGRect(x:view.frame.origin.x , y:view.center.y, width:view.frame.width, height:view.frame.height/2-10)
            label.frame = CGRect(x:view.frame.origin.x , y:view.frame.origin.y, width:view.frame.width, height:view.frame.height/2)
            image.contentMode = .scaleAspectFit
            view.addSubview(image)
        }
		
        return view
    }
	
    func randomColor() -> UIColor {
		print(UIColor(red: randomFloat(), green: randomFloat(), blue: randomFloat(), alpha: 1))
        return UIColor(red: randomFloat(), green: randomFloat(), blue: randomFloat(), alpha: 1)
    }
    
    func randomFloat() -> CGFloat {
		let upper : UInt32 = 100
		let lower : UInt32 = 80
		
		return CGFloat(arc4random_uniform(upper - lower) + lower) / CGFloat(upper)
		//        return CGFloat(Float(arc4random()) / Float(UInt32.max))
    }

//
//    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
//        return Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)![0] as? OverlayView
//    }
}
