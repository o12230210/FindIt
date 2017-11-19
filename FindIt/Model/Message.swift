//
//  Messages.swift
//  FindIt
//
//  Created by asuka on 2017/11/12.
//  Copyright © 2017年 Koki Nagatani. All rights reserved.
//

import Foundation
import RealmSwift

struct CandidateList : Codable{
	var id : Int
	var place : String
	var placeId : Int
}

class Message {
	public var candidateList = [CandidateList]()
	
	func setCandidateList(data: Data) {
		let tmp = try? JSONDecoder().decode([CandidateList].self, from: data)
		
        let realm = try! Realm()
        let local = realm.objects(LocalData.self)

        var array = [CandidateList]()
        
        // Localのリストと結合
        for t in tmp! {
            if (local.filter("placeId=%@",t.placeId).count > 0){
                for l in local.filter("placeId=%@",t.placeId){
                    array.append(CandidateList(id: l.id, place: l.name, placeId: l.placeId))
                }
            }
            else{
                    array.append(t)
            }
        }
        
        self.candidateList = array
        
        print(array)
	}
}
