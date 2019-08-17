//
//  ViewController.swift
//  SNSApp
//
//  Created by 大嶺舜 on 2019/08/17.
//  Copyright © 2019 大嶺舜. All rights reserved.
//

import UIKit
// firebase
import FirebaseFirestore

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // セルの数は投稿情報の数
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
    }
    
    // インスタンス化
    let db = Firestore.firestore()
    // Table View
    @IBOutlet weak var tableView: UITableView!
    
    // 投稿情報を全て格納
    var items = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // カメラボタンを押した処理
    @IBAction func openCamera(_ sender: Any) {
        // カメラのソースタイプの設定
        let sourceType = UIImagePickerController.SourceType.camera
        // カメラが使用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            
            // インスタンス作成
            let cameraPicker = UIImagePickerController()
            // ソースタイプの代入
            cameraPicker.sourceType = sourceType
            // デリゲートの接続
            cameraPicker.delegate = self
            // 画面遷移
            self.present(cameraPicker, animated: true)
        }
    }
    
    // アルバムボタンを押した処理
    @IBAction func openPhotos(_ sender: Any) {
        // フォトライブラリのソースタイプの設定
        let sourceType = UIImagePickerController.SourceType.photoLibrary
        // フォトライブラリが使用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            
            // インスタンス作成
            let cameraPicker = UIImagePickerController()
            // ソースタイプの代入
            cameraPicker.sourceType = sourceType
            // デリゲートの接続
            cameraPicker.delegate = self
            // 画面遷移
            self.present(cameraPicker, animated: true)
        }
    }
    
    @IBAction func profile(_ sender: Any) {
        // 対象のstoryboardファイルを選択
        let storyboard: UIStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Profile")
        // 遷移処理
        self.present(vc, animated: true)
    }
    
    // 写真が選択された時に呼ばれる
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 画像情報の存在確認
        if let pickedImage = info[.originalImage] as? UIImage {
            let storyboard: UIStoryboard = UIStoryboard(name: "Edit", bundle: nil)
            guard let vc = storyboard.instantiateViewController(withIdentifier: "Edit") as? EditViewController else {
                print("編集画面への遷移失敗")
                return
            }
            
            // 画像の受け渡し
            vc.editImage = pickedImage
            // 画面遷移
            picker.pushViewController(vc, animated: true)
        }
    }
    

}

