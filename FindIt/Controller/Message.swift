//
//  Messages.swift
//  FindIt
//
//  Created by asuka on 2017/11/12.
//  Copyright © 2017年 Koki Nagatani. All rights reserved.
//

import Foundation
import SwiftyJSON

class Message {
    public var sendText : Any!
    public var recvText : Any!
    
    init(){
        
    }
    
    func parseFromJson(result:Any){
        let json = JSON(result)
        
        for (key, subJson) in json {
            print("\(key) is \(subJson)")
            
        }

    }
}
