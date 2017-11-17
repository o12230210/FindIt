//
//  Connection.swift
//  FindIt
//
//  Created by asuka on 2017/11/11.
//  Copyright © 2017年 Koki Nagatani. All rights reserved.
//

import Foundation

protocol ConnectionDelegate {
	func done(data:Data)
}

class Connection {

    var delegate: ConnectionDelegate?
		
	func getCandidateList(str:String){
		let listUrl = "https://kuromusubi.com/findit/?item="
			+ str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

		//Implementing URLSession
		guard let url = URL(string: listUrl) else { return }
		
		URLSession.shared.dataTask(with: url) { (data, response, error) in
			if error != nil {
				print(error!.localizedDescription)
			}
			
			guard let data = data else { return }

			self.delegate?.done(data: data)
			}.resume()
	}

    func getPlaceList() {
//        var recvText = [[String: String]]()
//
//        let listUrl = "https://kuromusubi.com/findit/?placelist"
//        Alamofire.request(listUrl).responseJSON{ response in
//
//            if let dict = response.result.value as? Dictionary<String, AnyObject> {
//                // 変数keysにdictのkeyのみを取り出す
//                var keys : Array = Array(dict.keys)
//                // keysを昇順でソートする
//                keys.sort(by:{$0 < $1})
//                let json = JSON(response.result.value)
//                for i in keys {
//                    let id = json[i]["id"].int!
//                    let name = json[i]["name"].string!
//
//                    recvText.append(["placeId":String(id),"name":name])
//                }
//
//                print("receiveDone")
//
//                self.delegate?.done(list:recvText)
//            }
//        }
    }

    
    
	
//    func setRecvText(str:String, round:Int){
//        var recvText = [[String: String]]()
//
//        let listUrl = "https://kuromusubi.com/findit/?item="
//            + str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
//            + "&round=" + String(round)
//        Alamofire.request(listUrl).responseJSON{ response in
//
//            if let dict = response.result.value as? Dictionary<String, AnyObject> {
//                // 変数keysにdictのkeyのみを取り出す
//                var keys : Array = Array(dict.keys)
//                // keysを昇順でソートする
//                keys.sort(by:{$0 < $1})
//                let json = JSON(response.result.value)
//                for i in keys {
//                    let id = json[i]["id"].int!
//                    let place = json[i]["place"].string!
//
//                    recvText.append(["id":String(id),"place":place])
//                }
//
//                print("receiveDone")
//
//                self.mainViewController.message.recvText = recvText
//                self.delegate?.done()
//            }
//        }
//    }
}

