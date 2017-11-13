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
    
    var message : Message!
    
    private var kolodaView = KolodaView()
    
    init(message:Message) {
        super.init(nibName: nil, bundle: nil)
        self.message = message
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = .white
        
        self.view.addSubview(kolodaView)
        kolodaView.frame = CGRect(x:0, y:0, width:self.view.bounds.size.width/8*6, height:self.view.bounds.size.height/6*4)
        kolodaView.dataSource = self
        kolodaView.delegate = self
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



extension CandidateViewController: KolodaViewDelegate {
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
//        koloda.reloadData()
        print("finish")
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
//        UIApplication.shared.openURL(URL(string: "https://yalantis.com/")!)
        print("71")
  
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        switch direction {
        case .right:
            print("Swiped to right!")
        case .left:
            print("Swiped to left!")
        default:
            return
        }
    }
}


extension CandidateViewController: KolodaViewDataSource {
        
    func kolodaNumberOfCards(_ koloda:KolodaView) -> Int {
        return self.message.recvText.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .fast
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let view = UIView(frame: koloda.bounds)
        view.backgroundColor = randomColor()
        
        let label = UILabel()
        label.text = Array(self.message.recvText)[index]["place"]
        label.center = self.view.center
        label.font = label.font.withSize(fontSize.title_sub.rawValue);
        label.sizeToFit()

        view.addSubview(label)
        
        print(label.frame)

        return view
    }
    
    func randomColor() -> UIColor {
        return UIColor(red: randomFloat(), green: randomFloat(), blue: randomFloat(), alpha: 1)
    }
    
    func randomFloat() -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UInt32.max))
    }

//
//    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
//        return Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)![0] as? OverlayView
//    }
}
