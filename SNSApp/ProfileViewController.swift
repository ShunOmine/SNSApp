//
//  ProfileViewController.swift
//  SNSApp
//
//  Created by 大嶺舜 on 2019/08/17.
//  Copyright © 2019 大嶺舜. All rights reserved.
//

import UIKit

import UIKit
import FirebaseAuth

class ProfieViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    // プロフィール画像
    @IBOutlet weak var profileImageView: UIImageView!
    // 名前編集用テキストフィールド
    @IBOutlet weak var userNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // テキストフィールドのでdelegateをセット
        userNameTextField.delegate = self
        
        getProfile()
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
            userNameTextField.text = profName
        } else {
            // なければ匿名としておく
            userNameTextField.text = "匿名"
        }
        
    }
    
    // プロフィール写真変更用のアクションシート
    @IBAction func changeProfPhoto(_ sender: Any) {
        // アクションシートを定義
        let alert = UIAlertController(title: "選択してください", message: nil, preferredStyle: .actionSheet)
        // カメラ
        let cameraAction = UIAlertAction(title: "カメラ", style: .default, handler:{(action: UIAlertAction) -> Void in
            self.photoAction(sourceType: .camera)
        })
        // アルバム
        let photosAction = UIAlertAction(title: "アルバム", style: .default, handler:{(action: UIAlertAction) -> Void in
            self.photoAction(sourceType: .photoLibrary)
        })
        // キャンセル
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        
        alert.addAction(cameraAction)
        alert.addAction(photosAction)
        alert.addAction(cancelAction)
        // 表示
        present(alert, animated: true)
        
    }
    
    //    // カメラ表示
    //    func openCamera() {
    //
    //        let sourceType = UIImagePickerController.SourceType.camera
    //        // カメラが使用可能かチェック
    //        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
    //            // インスタンス作成
    //            let cameraPicker = UIImagePickerController()
    //            cameraPicker.sourceType = sourceType
    //            cameraPicker.delegate = self
    //            self.present(cameraPicker, animated: true)
    //        }
    //    }
    
    // アルバム表示
    func openPhotos() {
        photoAction(sourceType: .photoLibrary)
        
    }
    
    // カメラ・フォトライブラリの処理
    func photoAction(sourceType: UIImagePickerController.SourceType) {
        // カメラ・フォトライブラリが使用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            // インスタンス作成
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true)
        }
        
    }
    
    // 画像選択後によばれる
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //
        if let pickedImage = info[.originalImage] as? UIImage {
            // 画面サイズに合わせて
            profileImageView.contentMode = .scaleToFill
            // プロフ画像に反映
            profileImageView.image = pickedImage
        }
        // pickerは閉じる
        picker.dismiss(animated: true)
    }
    
    // 決定
    @IBAction func save(_ sender: Any) {
        
        // データ型
        var data: NSData = NSData()
        // imageの存在確認
        if let image = profileImageView.image {
            data = image.jpegData(compressionQuality:0.1)! as NSData
        }
        // プロフィール画像を保存用にbase64Stringに変換
        let base64String = data.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters) as String
        
        // textFieldの中身をuserNameに入れる
        let userName = userNameTextField.text
        
        // アプリ内へ保存
        UserDefaults.standard.set(base64String,forKey:"profileImage")
        UserDefaults.standard.set(userName,forKey:"userName")
        
        // 遷移
        dismiss(animated: true)
    }
    
    // ログアウト処理
    @IBAction func logOut(_ sender: Any) {
        // ログアウト処理
        try! Auth.auth().signOut()
        
        // ログイン画面へ遷移
        let storyboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Login")
        self.present(vc, animated: true)
    }
    
    // タップ時にキーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (userNameTextField.isFirstResponder) {
            userNameTextField.resignFirstResponder()
        }
    }
}
