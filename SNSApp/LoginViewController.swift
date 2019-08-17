//
//  LoginViewController.swift
//  SNSApp
//
//  Created by 大嶺舜 on 2019/08/17.
//  Copyright © 2019 大嶺舜. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    // メールアドレス登録
    @IBOutlet var emailTextField: CustomField!
    // パスワード入力
    @IBOutlet var passwordTextField: CustomField!
    // アカウント作成
    @IBAction func createUser(sender: AnyObject) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            // alert
            validateTextField()
            return
        }
        Auth.auth().createUser(withEmail: email, password: password, completion: {(user, error) in
            if let error = error {
                // エラー時の処理
                print("認証失敗")
                self.showErrorAlert(error: error)
            } else {
                // 成功時の処理
                // アプリ内で管理する用のUserDefoult
                UserDefaults.standard.set("check", forKey: "set")
                // viewを消す
                self.dismiss(animated: true)
            }
        })
    }
    // ログイン
    @IBAction func loginUser(sender: AnyObject) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            validateTextField()
            return
        }
        // サインイン処理
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if let error = error {
                // エラーアラートの表示
                self.showErrorAlert(error: error)
            } else {
            }
        })
    }
    
    func toTimeLine() {
        
    }
    
    // 入力されているか確認
    func validateTextField() {
        // アラート出す
        let alert = UIAlertController(title: "入力エラー", message: "入力がされていません", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    // エラーが返ってきた場合のアラート
    func showErrorAlert(error: Error?) {
        let alert = UIAlertController(title: "入力エラー", message: error?.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    
    // キーボードを閉じる処理
    // タッチされたかを判断
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // キーボードが開いていたら
        if (emailTextField.isFirstResponder) {
            // 閉じる
            emailTextField.resignFirstResponder()
        }
        if (passwordTextField.isFirstResponder) {
            passwordTextField.resignFirstResponder()
        }
    }

}

// カスタムTextField
@IBDesignable class CustomField: UITextField {
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
            self.clipsToBounds = (self.cornerRadius > 0)
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = self.borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = self.borderWidth
        }
    }
}

// カスタムButton
@IBDesignable class CustomButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
            self.clipsToBounds = (self.cornerRadius > 0)
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = self.borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = self.borderWidth
        }
    }
}
