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
    @objc dynamic var id = 0
    @objc dynamic var placeId = 0
    @objc dynamic var name = ""
    @objc dynamic var imageName = ""
    
    // idをプライマリキーに設定
    override static func primaryKey() -> String? {
        return "id"
    }
    
    // 新しいIDを採番します。
    private func createNewId() -> Int {
        let realm = try! Realm()
        return (realm.objects(type(of: self).self).sorted(byKeyPath: "id", ascending: false).first?.id ?? 0) + 1
    }
}

class SettingViewController: UIViewController {
    var tableView = UITableView()
    private var itemField = UITextField()
    private var nameField = UITextField()

    
    var data : Results<LocalData>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.tableView.frame = CGRect(x: 0, y: 50, width: self.view.frame.width, height: self.view.frame.height/2)
        // Cell名の登録をおこなう.
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(self.tableView)
        // Delegate設定
        self.tableView.delegate = self
        // DataSource設定
        self.tableView.dataSource = self
        
        
        //データの取得
        let realm = try! Realm()
        // Realmに保存されてるDog型のオブジェクトを全て取得
        self.data = realm.objects(LocalData.self)
        
        print(self.data.count)

//         self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.rightBarButtonItem = self.editButtonItem
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SettingViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { // sectionの数を決める
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Uncomment the following line to preserve selection between presentations
        
        return data.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        print(indexPath.row)
        
        cell.textLabel?.text = self.data[indexPath.row].name
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
}

extension SettingViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        self.navigationItem.title = "Selected \(indexPath.section)-\(indexPath.row)"
        let alertController = UIAlertController(title: "test",message: "あきらめて踊ろう", preferredStyle: UIAlertControllerStyle.alert)
        let cancelButton = UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.cancel, handler: nil)
        alertController.addAction(cancelButton)
        present(alertController,animated: true,completion: nil)
        
    }
    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
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
