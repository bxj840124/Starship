//
//  createClassViewController2.swift
//  Starship
//
//  Created by 楊喬宇 on 2017/9/10.
//  Copyright © 2017年 楊喬宇. All rights reserved.
//

import UIKit

class createClassViewController2: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var coverImg: UIImageView!
    @IBOutlet weak var editImgBtn: UIButton!
    @IBOutlet weak var classTitle: UITextField!
    @IBOutlet weak var classCollectionView: UICollectionView!
    
    var cover = UIImage()
    var className = ""
    
    var imagePicker = UIImagePickerController()
    var cellInSection = [1, 1]
    var editNum = -1
    
    var imgList = [Int: UIImage]()
    var titleList = [Int: String]()
    var descList = [Int: String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.tintColor = UIColor.darkGray
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        
        let img1 = UIImagePNGRepresentation(cover)! as NSData
        let img2 = UIImagePNGRepresentation(UIImage(named: "image-add-button.png")!)! as NSData
        if img1.isEqual(to: img2 as Data) {
            coverImg.backgroundColor = UIColor.darkGray
            coverImg.contentMode = .center
            coverImg.clipsToBounds = true
        } else {
            coverImg.image = cover
            coverImg.contentMode = .scaleAspectFill
            coverImg.clipsToBounds = true
        }
        
        coverImg.layer.cornerRadius = 10
        coverImg.clipsToBounds = true
        
        classTitle.text = className
        
        editImgBtn.layer.cornerRadius = editImgBtn.frame.width/2.0
        editImgBtn.clipsToBounds = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // 建立 UICollectionViewFlowLayout
        let layout = UICollectionViewFlowLayout()
        
        // 設置 section 的間距 四個數值分別代表 上、左、下、右 的間距
        layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        
        layout.scrollDirection = .horizontal
        
        // 設置每一行的間距
        layout.minimumLineSpacing = 20
        
        // 設置每個 cell 的尺寸
        layout.itemSize = CGSize(width: 246, height: 531)
        
        self.classCollectionView.setCollectionViewLayout(layout, animated: true)
        self.classCollectionView.backgroundColor = UIColor.white
        
        // 設置委任對象
        self.classCollectionView.delegate = self
        self.classCollectionView.dataSource = self
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

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellInSection[section]
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 依據前面註冊設置的識別名稱 "Cell" 取得目前使用的 cell
        if indexPath.section == 0 {
            let currentCell = collectionView.dequeueReusableCell(withReuseIdentifier: "currentCell", for: indexPath as IndexPath) as! currentClassCollectionViewCell
            
            currentCell.contentView.backgroundColor = UIColor.white
            currentCell.contentView.layer.cornerRadius = 10
            currentCell.contentView.layer.borderWidth = 1.0
            currentCell.contentView.layer.borderColor = UIColor.lightGray.cgColor
            currentCell.contentView.layer.masksToBounds = true
            
            currentCell.layer.backgroundColor = UIColor.clear.cgColor
            currentCell.layer.shadowColor = UIColor.lightGray.cgColor
            currentCell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
            currentCell.layer.shadowRadius = 2.0
            currentCell.layer.shadowOpacity = 1.0
            currentCell.layer.masksToBounds = false
            currentCell.layer.shadowPath = UIBezierPath(roundedRect: currentCell.bounds, cornerRadius: currentCell.contentView.layer.cornerRadius).cgPath
            
            currentCell.stepDesc.layer.cornerRadius = 10
            currentCell.stepDesc.clipsToBounds = true
            
            let borderColor = UIColor(red: 1.0, green: 0.9, blue: 0.93725, alpha: 1.0)
            currentCell.stepNum.layer.cornerRadius = currentCell.stepNum.frame.width/2.0
            currentCell.stepNum.clipsToBounds = true
            currentCell.stepNum.layer.borderColor = borderColor.cgColor
            currentCell.stepNum.layer.borderWidth = 4.0
            currentCell.stepNum.text = "\(indexPath.item+1)"
            
            currentCell.addImg.tag = indexPath.item
            currentCell.addImg.addTarget(self, action: #selector(createClassViewController2.addImgTapped(sender:)), for: UIControlEvents.touchUpInside)
            
            currentCell.stepImg.image = imgList[indexPath.item]
            currentCell.stepImg.contentMode = .scaleAspectFill
            currentCell.stepImg.clipsToBounds = true
            currentCell.stepName.text = titleList[indexPath.item]
            currentCell.stepDesc.text = descList[indexPath.item]
            
            return currentCell
            
        } else {
            let createCell = collectionView.dequeueReusableCell(withReuseIdentifier: "createCell", for: indexPath as IndexPath) as! createClassCollectionViewCell
            
            createCell.contentView.backgroundColor = UIColor.lightGray
            createCell.contentView.layer.cornerRadius = 10
            createCell.contentView.layer.borderWidth = 1.0
            createCell.contentView.layer.borderColor = UIColor.lightGray.cgColor
            createCell.contentView.layer.masksToBounds = true
            
            createCell.layer.backgroundColor = UIColor.clear.cgColor
            createCell.layer.shadowColor = UIColor.lightGray.cgColor
            createCell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
            createCell.layer.shadowRadius = 2.0
            createCell.layer.shadowOpacity = 1.0
            createCell.layer.masksToBounds = false
            createCell.layer.shadowPath = UIBezierPath(roundedRect: createCell.bounds, cornerRadius: createCell.contentView.layer.cornerRadius).cgPath
            
            createCell.addStepBtn.layer.cornerRadius = 10
            createCell.addStepBtn.clipsToBounds = true
            
            createCell.addStepBtn.addTarget(self, action: #selector(createClassViewController2.addStep), for: UIControlEvents.touchUpInside)
            
            return createCell   
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item+1)
    }
    
    @IBAction func finishTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func editImgTapped(_ sender: Any) {
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
    
    func addImgTapped(sender: UIButton) {
        editNum = sender.tag
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
            if editNum == -1 {
                self.coverImg.contentMode = .scaleAspectFill
                self.coverImg.image = pickedImage
            } else {
                if let cell = classCollectionView.cellForItem(at: [0, editNum]) as? currentClassCollectionViewCell {
                    cell.stepImg.image = pickedImage
                    cell.stepImg.contentMode = .scaleAspectFill
                    cell.stepImg.clipsToBounds = true
                    editNum = -1
                }
            }
        }
        let max = classCollectionView.numberOfItems(inSection: 0)
        for i in 0...max {
            if let cell = classCollectionView.cellForItem(at: [0, i]) as? currentClassCollectionViewCell {
                imgList[i] = cell.stepImg.image
                titleList[i] = cell.stepName.text
                descList[i] = cell.stepDesc.text
            }
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
    
    func addStep() {
        cellInSection[0] += 1
        classCollectionView.reloadData()
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
        let max = classCollectionView.numberOfItems(inSection: 0)
        for i in 0...max {
            if let cell = classCollectionView.cellForItem(at: [0, i]) as? currentClassCollectionViewCell {
                imgList[i] = cell.stepImg.image
                titleList[i] = cell.stepName.text
                descList[i] = cell.stepDesc.text
            }
        }
    }
    
    @IBAction func previewTapped(_ sender: Any) {
        let preview = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "preview")
        self.present(preview, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
