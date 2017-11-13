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

class Connection {
    
    init(){
    }
    
    func sendItem(str:String) {
        let listUrl = "https://kuromusubi.com/findit/?item="
            + str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        Alamofire.request(listUrl).responseJSON{ response in
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                print(dict)
//                return dict
            }
            
//            return nil
            
            
//            print(response.result.value)
//
//            guard let result = response.result.value else {
//                return
//            }
//
//            let json = JSON(result)
//
//            print(json)
//
//            for (key, subJson) in json {
//                print("\(key) is \(subJson)")
//
//            }
            
//            let dic = try JSONSerialization.jsonObject(with: json, options: []) as? [String: Any]
//
//            print(dic)
        }
    }
}

