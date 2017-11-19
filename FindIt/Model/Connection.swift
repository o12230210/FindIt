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
        let listUrl = "https://kuromusubi.com/findit/?placelist"
		
		guard let url = URL(string: listUrl) else { return }
		
		URLSession.shared.dataTask(with: url) { (data, response, error) in
			if error != nil {
				print(error!.localizedDescription)
			}
			
			guard let data = data else { return }
			
			self.delegate?.done(data: data)
			}.resume()

    }
}

