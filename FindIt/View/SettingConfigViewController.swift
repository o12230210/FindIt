//
//  CandidateController.swift
//  FindIt
//
//  Created by Koki Nagatani on 2017/11/09.
//  Copyright © 2017年 Koki Nagatani. All rights reserved.
//


import UIKit
import RealmSwift



class SettingConfigViewController: UIViewController, UITextFieldDelegate {

	private var placeField = UITextField()
	private var nameField = UITextField()
    private var imageButton = UIButton()
    
    private var image : UIImage!
	
    
    private let id : Int
    private var data : LocalData
    let placeList : [Place]

    
    init(id: Int = -1, placeList:[Place]) {
        //データの取得
        let realm = try! Realm()

        if(id >= 0) {
            self.id = id
            // ローカルに保存してあるデータ
            self.data = realm.object(ofType: LocalData.self, forPrimaryKey: id)!
        }
        else {
            // id=-1 == 新規登録
            self.data = LocalData()
            self.id = self.data.createNewId()
        }
        self.placeList = placeList
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

		self.view.backgroundColor = .white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTapped))
        
        let placeLabel = UILabel(frame: CGRect(x:20, y:0, width:self.view.bounds.width, height:viewSize.fieldHeight))
        placeLabel.text = "場所"
        placeLabel.baselineAdjustment = .alignBaselines
        self.view.addSubview(placeLabel)
        
		self.placeField.frame = CGRect(x:0, y:viewSize.labelHeight, width:self.view.bounds.width/4*3, height:viewSize.fieldHeight)
		self.placeField.borderStyle = .roundedRect
        if(self.data.placeId != -1){
            self.placeField.text = self.placeList[self.data.placeId-1].name
        }
        self.placeField.center.x = self.view.center.x
		self.view.addSubview(self.placeField)
        self.placeField.delegate = self
		
        let nameLabel = UILabel(frame: CGRect(x:20, y:viewSize.labelHeight*2, width:self.view.bounds.width, height:viewSize.fieldHeight))
        nameLabel.text = "名前"
        nameLabel.baselineAdjustment = .alignBaselines
        self.view.addSubview(nameLabel)
        
		self.nameField.frame = CGRect(x:0, y:viewSize.labelHeight*3, width:self.view.bounds.width/4*3, height:viewSize.fieldHeight)
		self.nameField.borderStyle = .roundedRect
        self.nameField.text = self.data.name
        self.nameField.center.x = self.view.center.x
		self.view.addSubview(self.nameField)
        self.nameField.delegate = self
        
        self.imageButton.frame =  CGRect (x:0, y:viewSize.labelHeight*4, width:self.view.frame.size.width,height:self.view.frame.size.height-viewSize.labelHeight*4)
        self.imageButton.center.x = self.view.center.x
        
        // 画像がある場合
        let path = NSHomeDirectory() + "/Documents/" + String(self.data.id) + ".png"
        if (FileManager().fileExists(atPath: path)){
            let data =  try! Data.init(contentsOf: URL(fileURLWithPath: path))
            let image = UIImage(data:data)
            self.imageButton.setImage(image, for: .normal)
        }
        else{
            self.imageButton.setImage(UIImage(named: "ImageNone"), for: .normal)
        }
        self.imageButton.imageView?.contentMode = .scaleAspectFit
        self.view.addSubview(self.imageButton)
        // タップされたときのactionをセット
        self.imageButton.addTarget(self, action: #selector(SettingConfigViewController.imageButtonTapped(sender:)), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
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
    // ボタンクリック時の動作
    @objc func imageButtonTapped(sender: AnyObject) {
        let c = UIImagePickerController()
        c.delegate = self // 今回追加
        present(c, animated: true)

    }
 
    @objc func saveTapped(sender: AnyObject) {
        // 保存
        let data = LocalData()
        data.id = self.id
        data.name = self.nameField.text!

        // ★要改善
        for place in self.placeList {
            if(place.name == self.placeField.text){
                data.placeId = place.id
                break
            }
        }
        let realm = try! Realm()
        // データを追加
        try! realm.write() {
            realm.add(data, update: true)  // データが無ければ追加、あったら上書き
        }

        // 画像の保存
        if(self.image != nil) {
            let path: String = NSHomeDirectory() + "/Documents/" + String(self.id) + ".png"
            print(path)
            let jpgImageData = UIImageJPEGRepresentation(self.image!,0.8)
            let result = try! jpgImageData!.write(to:URL(fileURLWithPath: path))
        }

        let alertController = UIAlertController(title: "保存しました",message: "", preferredStyle: UIAlertControllerStyle.alert)
        let cancelButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
            (action:UIAlertAction!) -> Void in
            self.navigationController?.popViewController(animated: true)
        })
        alertController.addAction(cancelButton)
        present(alertController,animated: true,completion: nil)
    }

    
    // MARK:UITextFieldDelegate
    // キーボードを閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension SettingConfigViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        // キャンセルボタンを押された時に呼ばれる
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // 写真が選択された時に呼ばれる
        self.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.imageButton.setImage(image, for: .normal)
        self.imageButton.imageView?.contentMode = .scaleAspectFit
        
        picker.dismiss(animated: true, completion: nil)
    }
}

