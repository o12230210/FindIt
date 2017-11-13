//
//  Connection.swift
//  FindIt
//
//  Created by asuka on 2017/11/11.
//  Copyright © 2017年 Koki Nagatani. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol ConnectionDelegate {
	func done()
}

class Connection {
	private var mainViewController : ViewController
	var delegate: ConnectionDelegate?
	
	init(mainViewController : ViewController){
		self.mainViewController = mainViewController
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setRecvText(str:String, round:Int){
		var recvText = [[String: String]]()
		
		let listUrl = "https://kuromusubi.com/findit/?item="
			+ str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
			+ "&round=" + String(round)
		Alamofire.request(listUrl).responseJSON{ response in
			
			if let dict = response.result.value as? Dictionary<String, AnyObject> {
				// 変数keysにdictのkeyのみを取り出す
				var keys : Array = Array(dict.keys)
				// keysを昇順でソートする
				keys.sort(by:{$0 < $1})
				let json = JSON(response.result.value)
				for i in keys {
					let id = json[i]["id"].int!
					let place = json[i]["place"].string!
					
					recvText.append(["id":String(id),"place":place])
				}
				
				self.mainViewController.message.recvText = recvText
				self.delegate?.done()
			}
		}
    }
}

