//
//  EditViewController.swift
//  SNSApp
//
//  Created by 大嶺舜 on 2019/08/17.
//  Copyright © 2019 大嶺舜. All rights reserved.
//

import UIKit
import FirebaseFirestore

class EditViewController: UIViewController {
    // インスタンス化
    let db = Firestore.firestore()
    
    // pickerで選択した写真を受け取る変数
    var editImage: UIImage = UIImage()
    
    // プロフィール画像
    @IBOutlet weak var profileImageView: UIImageView!
    // プロフィール名
    @IBOutlet weak var profileNameLabel: UILabel!
    // コメント
    @IBOutlet weak var commentTextView: UITextView!
    // 投稿用画像
    @IBOutlet weak var postImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // pickerで選択した画像を反映
        postImageView.image = editImage
        // イメージビューの角を丸くする
        profileImageView.layer.cornerRadius = 8.0
        // イメージビューの枠からはみ出る部分をクリッピング
        profileImageView.clipsToBounds = true
    }
    
    @IBAction func postAll(_ sender: Any) {
        // 名前
        let userName = profileNameLabel.text!
        
        // コメント
        let comment = commentTextView.text
        
        // 投稿画像
        var postImageData: NSData = NSData()
        if let postImage = postImageView.image {
            // 画像のクオリティオリジナルの０.１倍まで下げる
            postImageData = postImage.jpegData(compressionQuality:0.1)! as NSData
        }
        let base64PostImage = postImageData.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters) as String
        
        // プロフィール画像
        var profileImageData: NSData = NSData()
        if let profileImage = profileImageView.image {
            profileImageData = profileImage.jpegData(compressionQuality:0.1)! as NSData
        }
        let base64ProfileImage = profileImageData.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters) as String
        
        // サーバーに飛ばす箱（辞書型）を用意
        let user: NSDictionary = ["userName": userName,"comment": comment ?? "","postImage": base64PostImage, "profileImage": base64ProfileImage]
        
        // 辞書ごとFirestoreの"user"へpost
        db.collection("user").addDocument(data: user as! [String : Any])
        
        // 画面遷移(タイムラインへ)
        // rootViewControllerの1つ先のViewControllerに戻る
        //        navigationController?.popToViewController(navigationController!.viewControllers[1], animated: true)
        //        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //        let vc = storyboard.instantiateViewController(withIdentifier: "Main")
        //        self.present(vc, animated: true)

    }
    
    // ローカルで持っているprofile情報を反映
    func getProfile() {
        // 画像情報
        if let profImage = UserDefaults.standard.object(forKey: "profileImage") {
            // NSData型に変換
            let dataImage = NSData(base64Encoded: profImage as! String ,options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
            
            // さらにUIImage型へ変換
            let decodedImage = UIImage(data: dataImage! as Data)
            // prfileImageViewへ代入
            profileImageView.image = decodedImage
        } else {
            // なければアイコン画像をいれておく
            profileImageView.image = #imageLiteral(resourceName: "人物アイコン")
        }
        
        // 名前情報
        if let profName = UserDefaults.standard.object(forKey: "userName") as? String {
            // profileNameLabelへ代入
            profileNameLabel.text = profName
        } else {
            // なければ匿名としておく
            profileNameLabel.text = "匿名"
        }
    }
    
    // キーボードを閉じる処理
    // タッチされたかを判断
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // キーボードが開いていたら
        if (commentTextView.isFirstResponder) {
            // 閉じる
            commentTextView.resignFirstResponder()
        }
    }
}
