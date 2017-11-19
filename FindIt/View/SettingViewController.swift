//
//  SettingViewController.swift
//  FindIt
//
//  Created by asuka on 2017/11/16.
//  Copyright © 2017年 Koki Nagatani. All rights reserved.
//

import UIKit
import RealmSwift

/// プライマリキーのあるデータ
class LocalData: Object {
    @objc dynamic var id = -1
    @objc dynamic var placeId = -1
    @objc dynamic var name = ""
    @objc dynamic var imageName = ""
    
    // idをプライマリキーに設定
    override static func primaryKey() -> String? {
        return "id"
    }
    
    // 新しいIDを採番します。
    func createNewId() -> Int {
        let realm = try! Realm()
        return (realm.objects(type(of: self).self).sorted(byKeyPath: "id", ascending: false).first?.id ?? 10000) + 1
    }
}

struct Place : Codable{
	var id : Int
	var name : String
}


class SettingViewController: UIViewController {
    var tableView : UITableView!
	
	var data : Results<LocalData>!
	
	var placeList = [Place]()
	var localPlaceIdList = [Int]()	// LocalDataの場所IDを一意に取得
	
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false

        self.view.backgroundColor = .white
		
        self.getData()
        
//        self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
        if(self.tableView != nil){
            //データの取得
            let realm = try! Realm()
            // ローカルに保存してあるデータ
            self.data = realm.objects(LocalData.self)
            
            print(self.data)
            
            // ローカルに保存してあるデータからセクションタイトル用に場所一覧を取得
            let distinct = Set(self.data.value(forKey: "placeId") as! [Int])
            self.localPlaceIdList = Array(distinct)
            
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
	
	
	//MARK: - Function
	func getData() {
		// サーバーから取得
		let connection = Connection()
		connection.delegate = self
		connection.getPlaceList()
		
        //データの取得
        let realm = try! Realm()
        // ローカルに保存してあるデータ
        self.data = realm.objects(LocalData.self)
        
        print(self.data)
        
        // ローカルに保存してあるデータからセクションタイトル用に場所一覧を取得
        let distinct = Set(self.data.value(forKey: "placeId") as! [Int])
        self.localPlaceIdList = Array(distinct)
        
		print(self.localPlaceIdList)
	}
    
    //MARK: -ACTION
    @objc func addTapped(sender: AnyObject){
        let settingConfigViewController: SettingConfigViewController = SettingConfigViewController(placeList:self.placeList)
        self.navigationController?.pushViewController(settingConfigViewController, animated: true)
    }
}

extension SettingViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { // sectionの数を決める
		return self.localPlaceIdList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Uncomment the following line to preserve selection between presentations
		// ローカルに保存してあるデータからセクションタイトル用に場所一覧を取得
		let section = self.data.filter("placeId=%@", self.localPlaceIdList[section])
        
        print(section)

        return section.count
    }
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		let name = self.placeList[self.localPlaceIdList[section]-1].name	//DBは1始まり、placeListは0はじまりのため
		
        return name
		
	}
	
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        print(indexPath.row)
        
        cell.textLabel?.text = Array(self.data.filter("placeId=%@", self.localPlaceIdList[indexPath.section]))[indexPath.row].name
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
}

extension SettingViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
//        self.navigationItem.title = "Selected \(indexPath.section)-\(indexPath.row)"
//        let alertController = UIAlertController(title: "test",message: "あきらめて踊ろう", preferredStyle: UIAlertControllerStyle.alert)
//        let cancelButton = UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.cancel, handler: nil)
//        alertController.addAction(cancelButton)
//        present(alertController,animated: true,completion: nil)
        
        let settingConfigViewController: SettingConfigViewController
            = SettingConfigViewController(id: Array(self.data.filter("placeId=%@", self.localPlaceIdList[indexPath.section]))[indexPath.row].id,
                                          placeList:self.placeList)
        
        self.navigationController?.pushViewController(settingConfigViewController, animated: true)
    }
	
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
}

extension SettingViewController : ConnectionDelegate {
	func done(data:Data) {
		
		// サーバーから取得したデータを変換
		let array = try? JSONDecoder().decode([Place].self, from: data)
		self.placeList = array!
		
		print(self.placeList)
        
        DispatchQueue.main.async {
            self.tableView = UITableView()
            self.tableView.frame = self.view.frame
            // Cell名の登録をおこなう.
            self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            self.view.addSubview(self.tableView)
            // Delegate設定
            self.tableView.delegate = self
            // DataSource設定
            self.tableView.dataSource = self
            self.view.addSubview(self.tableView)
        }

	}
}
