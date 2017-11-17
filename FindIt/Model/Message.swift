//
//  Messages.swift
//  FindIt
//
//  Created by asuka on 2017/11/12.
//  Copyright © 2017年 Koki Nagatani. All rights reserved.
//

import Foundation

struct CandidateList : Codable{
	var id : Int
	var place : String
	var placeId : Int
}

class Message {
	public var candidateList = [CandidateList]()
	
	func setCandidateList(data: Data) {
		let array = try? JSONDecoder().decode([CandidateList].self, from: data)
		
		self.candidateList = array!
	}
}
