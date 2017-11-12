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
    
    
    private var label : UILabel = UILabel()
    
    private var kolodaView = KolodaView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = .white
        
        let margin : CGFloat = 10.0;
        
        kolodaView.frame = self.view.frame

        self.view.addSubview(kolodaView)

        print(kolodaView.frame)
        
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
        koloda.reloadData()
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        UIApplication.shared.openURL(URL(string: "https://yalantis.com/")!)
    }
}


extension CandidateViewController: KolodaViewDataSource {
        
    func kolodaNumberOfCards(_ koloda:KolodaView) -> Int {
        return 10
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .fast
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let view = UIView(frame: koloda.bounds)
        view.backgroundColor = randomColor()
        
        // Label
        let date = Date()
        let calendar = Calendar.current
        let second = calendar.component(.second, from: date)
        self.label.text = String(second)
        self.label.sizeToFit()
        self.label.textAlignment = .center
        view.addSubview(self.label)

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
