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
    // インスタンス化
    let db = Firestore.firestore()
    
    // 更新
    let refreshControl = UIRefreshControl()
    
    // Table View
    @IBOutlet weak var tableView: UITableView!
    
    // 投稿情報を全て格納
    var items = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        // refreshControlに文言を追加
        refreshControl.attributedTitle = NSAttributedString(string: "引っ張って更新")
        // アクションを指定
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        fetch()
        // リロード
        tableView.reloadData()
        refresh()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // セルの数は投稿情報の数
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        // itemsの中からindexPathのrow番目を取得
        let dict = items[(indexPath as NSIndexPath).row]
        // プロフィール画像
        let profileImageView = cell.viewWithTag(1) as! UIImageView
        // 画像情報
        guard let profImage = dict["profileImage"] else {
            return cell
        }
        // NSData型に変換
        let dataProfImage = NSData(base64Encoded: profImage as! String ,options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
        // さらにUIImage型へ変換
        let decodeProfImage = UIImage(data: dataProfImage! as Data)
        // prfileImageViewへ代入
        profileImageView.image = decodeProfImage
        // 丸くする
        profileImageView.layer.cornerRadius = 8.0
        profileImageView.clipsToBounds = true
        
        // ユーザー名
        let userNameLabel = cell.viewWithTag(2) as! UILabel
        userNameLabel.text = dict["userName"] as? String
        
        // 投稿画像
        let postImageView = cell.viewWithTag(3) as! UIImageView
        let postImage = (dict["postImage"])
        let dataPostImage = NSData(base64Encoded: postImage as! String, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
        let decodePostImage = UIImage(data: dataPostImage! as Data)
        postImageView.image = decodePostImage
        
        // コメント
        let commentTextView = cell.viewWithTag(4) as! UITextView
        commentTextView.text = dict["comment"] as? String
        
        return cell
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
        print("hello hello")
        // 画像情報の存在確認
        if let pickedImage = info[.originalImage] as? UIImage {
            let storyboard: UIStoryboard = UIStoryboard(name: "Edit.storyborad", bundle: nil)
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
    
    // データの取得
    func fetch() {
        db.collection("user")
            .getDocuments() {(querysnapshot, err) in
                
                var tempItems = [NSDictionary]()
                for item in querysnapshot!.documents {
                    
                    let dict = item.data()
                    tempItems.append(dict as NSDictionary)
                }
                self.items = tempItems
                // 順番を入れ替え
                self.items = self.items.reversed()
                // リロード
                self.tableView.reloadData()
        }
    }
    
    // 更新
    @objc func refresh() {
        // 初期化
        items = [NSDictionary]()
        // データをサーバから取得
        fetch()
        // リロード
        tableView.reloadData()
        // リフレッシュ終了
        refreshControl.endRefreshing()
    }

}

