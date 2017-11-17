//
//  CandidateController.swift
//  FindIt
//
//  Created by Koki Nagatani on 2017/11/09.
//  Copyright © 2017年 Koki Nagatani. All rights reserved.
//


import UIKit
import RealmSwift



class SettingConfigViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

       self.view.backgroundColor = .white
        let label = UILabel()
        label.text = "Setting"
        label.sizeToFit()
        label.center = self.view.center

        let data = LocalData()
        data.id = 0
        data.placeId = 9
        data.name = "私のベッド"

        addData(data: data)

        let realm = try! Realm()

        // Realmに保存されてるDog型のオブジェクトを全て取得
        let dogs = realm.objects(LocalData.self)

        // ためしに名前を表示
        for dog in dogs {
            print("name: \(dog.name)")
        }

        view.addSubview(label)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK:function
    func addData(data:LocalData){
        // Realmのインスタンスを取得
        let realm = try! Realm()

        // データを追加
        try! realm.write() {
            realm.add(data, update: true)  // データが無ければ追加、あったら上書き
        }
    }




    // MARK:action
}



