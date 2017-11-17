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
        
//        self.view.backgroundColor = .red
		self.frame = CGRect(x:viewSize.candidateMargin, y:0, width:self.view.frame.size.width-viewSize.candidateMargin*4, height:self.view.frame.size.width-viewSize.candidateMargin*4)
		
		self.kolodaView = KolodaView()
        self.view.addSubview(kolodaView)
        kolodaView.frame = self.frame
			//		kolodaView.center = self.view.center
//		kolodaView.widthAnchor.constraint(equalTo:self.view.widthAnchor, constant: -10.0).isActive = true
		kolodaView.layer.shadowColor = UIColor.gray.cgColor        // シャドウカラー
		kolodaView.layer.shadowOffset = CGSize(width:1, height:1);        //  シャドウサイズ
		kolodaView.layer.shadowOpacity = 1.0;        // 透明度
		kolodaView.layer.shadowRadius = 1;        // 角度
        kolodaView.dataSource = self
        kolodaView.delegate = self
		
		OKbutton.frame = CGRect(x:self.view.frame.size.width/2+10, y:self.view.frame.size.width-viewSize.candidateMargin*4+35, width:viewSize.correctButton, height:viewSize.correctButton)
		OKbutton.setTitle(NSLocalizedString("⚪︎", comment: ""), for: .normal)
		OKbutton.setTitleColor(.OKbutton, for: .normal)
		OKbutton.titleLabel?.font = OKbutton.titleLabel?.font.withSize(fontSize.correctButton);
		OKbutton.titleLabel?.textAlignment = .center;
		OKbutton.titleLabel?.baselineAdjustment = .alignCenters;
		OKbutton.addTarget(self, action: #selector(CandidateViewController.onOKClick(_:)), for:.touchUpInside)
		self.view.addSubview(OKbutton)

		NGbutton.frame = CGRect(x:self.view.frame.size.width/2-viewSize.correctButton-20, y:self.view.frame.size.width-viewSize.candidateMargin*4+30, width:viewSize.correctButton, height:viewSize.correctButton)
		NGbutton.setTitle(NSLocalizedString("×", comment: ""), for: .normal)
		NGbutton.setTitleColor(.NGbutton, for: .normal)
		NGbutton.titleLabel?.font = NGbutton.titleLabel?.font.withSize(fontSize.correctButton);
		NGbutton.titleLabel?.textAlignment = .center;
		NGbutton.titleLabel?.baselineAdjustment = .alignCenters;
		NGbutton.addTarget(self, action: #selector(CandidateViewController.onNGClick(_:)), for:.touchUpInside)
		self.view.addSubview(NGbutton)
    }
	
	@objc func onOKClick(_ sender: AnyObject) {
//		self.kolodaView.swipe(_:.right, force: false)
		self.mainViewController.ResultPosition(result:true)
	}
	@objc func onNGClick(_ sender: AnyObject) {
		self.kolodaView.swipe(_:.left, force: false)
	}

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:function
    
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
			self.mainViewController.ResultPosition(result:true)
        case .left:
			print("Swiped to left! : なかった")
//			self.mainViewController.ResultPosition(result:false)
			
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
		label.frame = self.frame
		label.textAlignment = .center
        view.addSubview(label)
		
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
