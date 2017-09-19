//
//  ViewController.swift
//  Starship
//
//  Created by 楊喬宇 on 2017/9/8.
//  Copyright © 2017年 楊喬宇. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var appLogo: UIImageView!
    @IBOutlet weak var therapistBtn: UIButton!
    @IBOutlet weak var parentBtn: UIButton!
    @IBOutlet weak var phoneBar: UITextField!
    @IBOutlet weak var passwdBar: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var check1: UIImageView!
    @IBOutlet weak var check2: UIImageView!
    @IBOutlet weak var therapistLabel: UILabel!
    @IBOutlet weak var parentLabel: UILabel!
    
    var identity = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.appLogo.contentMode = .scaleAspectFill
        
        self.therapistBtn.layer.cornerRadius = 15
        self.therapistBtn.clipsToBounds = true
        self.therapistBtn.imageView?.contentMode = .scaleAspectFill
        self.therapistBtn.imageView?.clipsToBounds = true
        self.therapistBtn.layer.borderWidth = 0
        
        self.parentBtn.layer.cornerRadius = 15
        self.parentBtn.clipsToBounds = true
        self.parentBtn.imageView?.contentMode = .scaleAspectFill
        self.parentBtn.imageView?.clipsToBounds = true
        self.parentBtn.layer.borderWidth = 0
        
        self.loginBtn.layer.cornerRadius = 15
        self.loginBtn.clipsToBounds = true
        self.loginBtn.layer.borderWidth = 1
        self.loginBtn.layer.borderColor = UIColor.clear.cgColor

        self.check1.layer.opacity = 0.0
        self.check2.layer.opacity = 0.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func therapistTapped(_ sender: Any) {
        self.therapistLabel.textColor = UIColor.white
        self.parentLabel.textColor = UIColor.darkGray
        self.check1.layer.opacity = 1.0
        self.check2.layer.opacity = 0.0
        self.identity = "therapist"
    }

    @IBAction func parentTapped(_ sender: Any) {
        self.therapistLabel.textColor = UIColor.darkGray
        self.parentLabel.textColor = UIColor.white
        self.check1.layer.opacity = 0.0
        self.check2.layer.opacity = 1.0
        self.identity = "parent"
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        if self.identity == "" {
            let alertController = UIAlertController(
                title: "提示",
                message: "請選擇身份類別！",
                preferredStyle: .alert)
            let okAction = UIAlertAction(
                title: "確認",
                style: .default,
                handler: nil)
            alertController.addAction(okAction)
            self.present(
                alertController,
                animated: true,
                completion: nil)
            return
        }
        guard let text1 = self.phoneBar.text, let text2 = self.passwdBar.text, !text1.isEmpty, !text2.isEmpty else {
            let alertController = UIAlertController(
                title: "提示",
                message: "資料不可為空！",
                preferredStyle: .alert)
            let okAction = UIAlertAction(
                title: "確認",
                style: .default,
                handler: nil)
            alertController.addAction(okAction)
            self.present(
                alertController,
                animated: true,
                completion: nil)
            return
        }
        if self.identity == "therapist" {
            let loginEntry = storyboard?.instantiateViewController(withIdentifier: "therapistEntry")
            self.present(loginEntry!, animated: true, completion: nil)
        } else if self.identity == "parent" {
            let loginEntry = storyboard?.instantiateViewController(withIdentifier: "parentEntry")
            self.present(loginEntry!, animated: true, completion: nil)
        }
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height/2.0
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height/2.0
            }
        }
    }
}

extension UIColor {
    public convenience init?(hexString: String) {
        let r, g, b, a: CGFloat
        
        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            let hexColor = hexString.substring(from: start)
            
            if hexColor.characters.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
}

