//
//  CandidateController.swift
//  FindIt
//
//  Created by Koki Nagatani on 2017/11/09.
//  Copyright © 2017年 Koki Nagatani. All rights reserved.
//


import UIKit
import SwiftGifOrigin
import AVFoundation

class ResultViewController: UIViewController {
	
	var result : Bool
	
	init(result : Bool) {
		self.result = result

		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
//        let label = UILabel()
//        label.text = "♪♫ ✌('ω'✌ )三✌('ω')✌三( ✌'ω')✌ ♫♪"
//        label.sizeToFit()
//        label.center = self.view.center
//
//        if (!result){
//            label.text = "٩(๑`^´๑)۶༄༅༄༅༄༅༄༅"
//        }
//        self.view.addSubview(label)
        
        // ローカルに保存されているgifファイルを指定
        //let imageView = UIImageView(frame: self.view.frame)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        imageView.loadGif(name: "Dance")
        imageView.center = self.view.center
        imageView.contentMode = .scaleAspectFit
        self.view.addSubview(imageView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 再生する audio ファイルのパスを取得
        
        let audioPath = Bundle.main.path(forResource: self.result ? "victory" : "defeat", ofType:"mp3")!
        let audioUrl = URL(fileURLWithPath: audioPath.tild)
        
        // auido を再生するプレイヤーを作成する
        var audioError:NSError?
        var audioPlayer : AVAudioPlayer!
        do {
            audioPlayer = try! AVAudioPlayer(contentsOf: audioUrl)
        } catch let error as NSError {
            audioError = error
            audioPlayer = nil
        }
        
        // エラーが起きたとき
        if let error = audioError {
            print("Error \(error.localizedDescription)")
        }
        audioPlayer.delegate = self
        audioPlayer.prepareToPlay()
        audioPlayer.play()
        
        print(audioPlayer.isPlaying)
    }
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	// MARK:function
	
	// MARK:action
}

extension ResultViewController : AVAudioPlayerDelegate{
    // 音楽再生が成功した時に呼ばれるメソッド
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
    }
    // デコード中にエラーが起きた時に呼ばれるメソッド
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?){
        
    }

}
