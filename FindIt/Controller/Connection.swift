//
//  Connection.swift
//  FindIt
//
//  Created by asuka on 2017/11/11.
//  Copyright © 2017年 Koki Nagatani. All rights reserved.
//

import Foundation
import Alamofire

class Connection {
    
    init(){
    }
    
    func sendItem(str:String) {
        let listUrl = "https://kuromusubi.com/findit/?item="
            + str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        Alamofire.request(listUrl).responseJSON{ response in
            
            guard let result = response.result.value else {
                return
            }
            
            print(result)
            
        }
    }
}

