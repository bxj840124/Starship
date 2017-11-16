//
//  createClassViewController1.swift
//  Starship
//
//  Created by 楊喬宇 on 2017/9/10.
//  Copyright © 2017年 楊喬宇. All rights reserved.
//

import UIKit

class createClassViewController1: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var coverImg: UIImageView!
    @IBOutlet weak var selectImgBtn: UIButton!
    @IBOutlet weak var classTitle: UITextField!
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        coverImg.layer.cornerRadius = 15
        coverImg.clipsToBounds = true
        selectImgBtn.layer.cornerRadius = 15
        selectImgBtn.clipsToBounds = true
        
        self.imagePicker.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: classTitle.frame.size.height - width, width: classTitle.frame.size.width, height: classTitle.frame.size.height)
        
        border.borderWidth = width
        classTitle.layer.addSublayer(border)
        classTitle.layer.masksToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectImgTapped(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        /*
         The sourceType property wants a value of the enum named        UIImagePickerControllerSourceType, which gives 3 options:
         
         UIImagePickerControllerSourceType.PhotoLibrary
         UIImagePickerControllerSourceType.Camera
         UIImagePickerControllerSourceType.SavedPhotosAlbum
         
         */
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.coverImg.contentMode = .scaleAspectFill
            self.coverImg.image = pickedImage
        }
        /*
         
         Swift Dictionary named “info”.
         We have to unpack it from there with a key asking for what media information we want.
         We just want the image, so that is what we ask for.  For reference, the available options are:
         
         UIImagePickerControllerMediaType
         UIImagePickerControllerOriginalImage
         UIImagePickerControllerEditedImage
         UIImagePickerControllerCropRect
         UIImagePickerControllerMediaURL
         UIImagePickerControllerReferenceURL
         UIImagePickerControllerMediaMetadata
         
         */
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion:nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "next2" {
            guard let dvc = segue.destination as? createClassViewController2 else {
                return
            }
            dvc.className = self.classTitle.text!
            dvc.cover = self.coverImg.image!
        }
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        if self.classTitle.text == "" {
            let alertController = UIAlertController(
                title: "提示",
                message: "請輸入教材標題！",
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
        
        performSegue(withIdentifier: "next2", sender: self)

    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height / 2.0
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height / 2.0
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
