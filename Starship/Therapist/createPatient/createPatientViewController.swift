//
//  createPatientViewController.swift
//  Starship
//
//  Created by 楊喬宇 on 2017/9/9.
//  Copyright © 2017年 楊喬宇. All rights reserved.
//

import UIKit

class createPatientViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var patientImg: UIImageView!
    @IBOutlet weak var patientName: UITextField!
    @IBOutlet weak var patientSex: UISegmentedControl!
    @IBOutlet weak var patientBD: UITextField!
    @IBOutlet weak var patientPhone: UITextField!
    @IBOutlet weak var patientID: UITextField!
    @IBOutlet weak var patientAddress: UITextField!
    @IBOutlet weak var changeImgBtn: UIButton!
    @IBOutlet weak var createBtn: UIButton!
    
    var imagePicker = UIImagePickerController()
    var isPickingDate = false
    var keyboardHeight:CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(createPatientViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        self.patientImg.layer.cornerRadius = self.patientImg.frame.width / 2.0
        self.patientImg.clipsToBounds = true
        self.changeImgBtn.layer.cornerRadius = self.changeImgBtn.frame.width / 2.0
        self.changeImgBtn.clipsToBounds = true
        
        let toolBar = UIToolbar().ToolbarPiker(mySelect: #selector(createPatientViewController.dismissPicker))
        
        patientBD.inputAccessoryView = toolBar
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        self.imagePicker.delegate = self
        
        self.createBtn.layer.cornerRadius = 15
        self.createBtn.clipsToBounds = true
        self.createBtn.layer.borderWidth = 1
        self.createBtn.layer.borderColor = UIColor.clear.cgColor
        
        self.showAnimate()
    }
    
    @IBAction func pickBDTapped(_ sender: UITextField) {
        isPickingDate = true
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
    }
    
    func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MMM dd"
        self.patientBD.text = dateFormatter.string(from: sender.date)
    }
    
    func dismissPicker() {
        view.endEditing(true)
        isPickingDate = false
        if self.view.frame.origin.y != 0 {
            UIView.animate(withDuration: 0.25, animations: {
              self.view.frame.origin.y += self.keyboardHeight / 2.0  
            })
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 && !isPickingDate {
                self.view.frame.origin.y -= keyboardSize.height / 2.0
                self.keyboardHeight = keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0 && !isPickingDate {
                self.view.frame.origin.y += keyboardSize.height / 2.0
            }
        }
    }

    @IBAction func closePop(_ sender: Any) {
        self.removeAnimate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAnimate() {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25) { 
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    func removeAnimate() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0
        }) { (finished) in
            if (finished) {
                self.view.removeFromSuperview()
            }
        }
    }
    
    @IBAction func changeImgTapped(_ sender: Any) {
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
            self.patientImg.contentMode = .scaleAspectFill
            self.patientImg.image = pickedImage
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
    
    @IBAction func createTapped(_ sender: Any) {
        if self.patientName.text == "" {
            let alertController = UIAlertController(
                title: "提示",
                message: "請輸入病患姓名！",
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
        } else if self.patientBD.text == "" {
            let alertController = UIAlertController(
                title: "提示",
                message: "請輸入病患生日！",
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
        } else if self.patientPhone.text == "" {
            let alertController = UIAlertController(
                title: "提示",
                message: "請輸入病患電話！",
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
        } else if self.patientID.text == "" {
            let alertController = UIAlertController(
                title: "提示",
                message: "請輸入病患身份證字號！",
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
        } else if self.patientAddress.text == "" {
            let alertController = UIAlertController(
                title: "提示",
                message: "請輸入病患地址！",
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
        self.removeAnimate()
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.view.endEditing(true)
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

extension UIToolbar {
    
    func ToolbarPiker(mySelect : Selector) -> UIToolbar {
        
        let toolBar = UIToolbar()
        
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: mySelect)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([ spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
    
}
