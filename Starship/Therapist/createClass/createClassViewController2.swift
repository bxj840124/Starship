//
//  createClassViewController2.swift
//  Starship
//
//  Created by 楊喬宇 on 2017/9/10.
//  Copyright © 2017年 楊喬宇. All rights reserved.
//

import UIKit
import RealmSwift

class createClassViewController2: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var classTitle: UITextField!
    @IBOutlet weak var classCollectionView: UICollectionView!
    @IBOutlet weak var editViewBottomC: NSLayoutConstraint!
    
    var cover = UIImage()
    var className = ""
    
    var imagePicker = UIImagePickerController()
    var cellInSection = [1, 1]
    var editNum = -1
    var selectedIndex:IndexPath = IndexPath()
    var isEditMode = false
    var isKeyboardInTitle = false
    var isEditClass = false
    var cellNum = 0
    var oldTitle = ""
    var uuid = ""
    
    var imgList = [UIImage]()
    var titleList = [String]()
    var descList = [String]()
    var isCoverSet = false
    var coverIndex:IndexPath = IndexPath()
    var coverImg:UIImage = UIImage()
    
    let newClass = classData()
    var saveCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        editViewBottomC.constant = -80
        if !isEditClass {
            imgList.append(UIImage())
            titleList.append("")
            descList.append("")
        } else {
            cellInSection[0] = cellNum
            classTitle.text = oldTitle
        }
        isCoverSet = false
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressed(sender:)))
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.leaveEditMode))
        self.classCollectionView.addGestureRecognizer(longPressRecognizer)
        self.view.addGestureRecognizer(tap)
        
        self.navigationController?.navigationBar.tintColor = UIColor.darkGray
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.saveClassDone), name: NSNotification.Name("SAVE_DONE"), object: nil)
        
        // 建立 UICollectionViewFlowLayout
        let layout = UICollectionViewFlowLayout()
        
        // 設置 section 的間距 四個數值分別代表 上、左、下、右 的間距
        layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        
        layout.scrollDirection = .horizontal
        
        // 設置每一行的間距
        layout.minimumLineSpacing = 20
        
        // 設置每個 cell 的尺寸
        layout.itemSize = CGSize(width: 246, height: 460)
        
        self.classCollectionView.setCollectionViewLayout(layout, animated: true)
        
        // 設置委任對象
        self.classCollectionView.delegate = self
        self.classCollectionView.dataSource = self
        self.imagePicker.delegate = self
        
        self.classTitle.delegate = self
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
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.isKeyboardInTitle = true
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        let max = classCollectionView.numberOfItems(inSection: 0)
        for i in 0...max {
            if let cell = classCollectionView.cellForItem(at: [0, i]) as? currentClassCollectionViewCell {
                imgList[i] = cell.stepImg.image!
                titleList[i] = cell.stepName.text!
                descList[i] = cell.stepDesc.text!
            }
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            let cell = self.classCollectionView.cellForItem(at: [0, textView.tag]) as! currentClassCollectionViewCell
            cell.stepDesc.text = ""
            cell.stepDesc.textColor = UIColor.black
        }
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text == "" {
            let cell = self.classCollectionView.cellForItem(at: [0, textView.tag]) as! currentClassCollectionViewCell
            cell.stepDesc.text = "輸入步驟說明"
            cell.stepDesc.textColor = UIColor.lightGray
        }
        return true
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
            
            let borderColor = UIColor(red: 0.87058, green: 0.88627, blue: 0.99215, alpha: 1.0)
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
            currentCell.stepDesc.tag = indexPath.item
            currentCell.stepDesc.delegate = self
            if descList[indexPath.item] == "" || descList[indexPath.item] == "輸入步驟說明" {
                currentCell.stepDesc.text = "輸入步驟說明"
                currentCell.stepDesc.textColor = UIColor.lightGray
            } else {
                currentCell.stepDesc.text = descList[indexPath.item]
                currentCell.stepDesc.textColor = UIColor.black
            }
            
            if isCoverSet {
                if coverIndex == indexPath {
                    currentCell.coverIcon.isHidden = false
                } else {
                    currentCell.coverIcon.isHidden = true
                }
            } else {
                currentCell.coverIcon.isHidden = true
            }
            
            if indexPath == self.selectedIndex {
                currentCell.contentView.backgroundColor = UIColor(red: 0.9137, green: 0.9137, blue: 0.9843, alpha: 1.0)
                currentCell.stepImg.backgroundColor = UIColor(red: 0.5764, green: 0.6353, blue: 0.96078, alpha: 1.0)
                currentCell.stepImg.alpha = 0.2
                currentCell.addImg.isEnabled = false
                currentCell.stepName.isEnabled = false
                currentCell.stepDesc.isEditable = false
            } else {
                currentCell.contentView.backgroundColor = UIColor.white
                currentCell.stepImg.backgroundColor = UIColor.lightGray
                currentCell.stepImg.alpha = 1.0
                currentCell.addImg.isEnabled = true
                currentCell.stepName.isEnabled = true
                currentCell.stepDesc.isEditable = true
            }
            
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
        if self.classTitle.text == "" {
            let alertController = UIAlertController(
                title: "提示",
                message: "課程標題為空！",
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
        } else if titleList.contains("") || descList.contains("") {
            let alertController = UIAlertController(
                title: "提示",
                message: "有的文字資料為空！",
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
        } else {
            for img in imgList {
                if img.size.width == 0 {
                    let alertController = UIAlertController(
                        title: "提示",
                        message: "有的圖片為空！",
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
            }
            if !isCoverSet {
                let alertController = UIAlertController(
                    title: "提示",
                    message: "尚未設定封面圖片！",
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
            DispatchQueue.global().async {
                let imgData = NSData(data: UIImageJPEGRepresentation(self.coverImg, 0.5)!)
                DispatchQueue.main.async { 
                    self.newClass.coverImg = imgData
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SAVE_DONE"), object: nil)
                }
            }
            self.newClass.classTitle = self.classTitle.text!
            for i in 0...cellInSection[0]-1 {
                let step = classStep()
                step.stepNum = i+1
                DispatchQueue.global().async {
                    let imgData = NSData(data: UIImageJPEGRepresentation(self.imgList[i], 0.5)!)
                    DispatchQueue.main.async {
                        step.stepImg = imgData
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SAVE_DONE"), object: nil)
                    }
                }
                step.stepTitle = self.titleList[i]
                step.stepContent = self.descList[i]
                self.newClass.classSteps.append(step)
            }
        }
    }
    
    func saveClassDone() {
        self.saveCount += 1
        if (self.saveCount == self.cellInSection[0]+1) {
            let realm = try! Realm()
            if !isEditClass {
                try! realm.write {
                    realm.add(self.newClass)
                }
            } else {
                self.newClass.uuid = self.uuid
                try! realm.write {
                    realm.add(self.newClass, update: true)
                }
            }
            NotificationCenter.default.post(name: NSNotification.Name("CREATE_DONE"), object: nil)
            self.dismiss(animated: true, completion: nil)
        }
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
            if let cell = classCollectionView.cellForItem(at: [0, editNum]) as? currentClassCollectionViewCell {
                cell.stepImg.image = pickedImage
                cell.stepImg.contentMode = .scaleAspectFill
                cell.stepImg.clipsToBounds = true
                editNum = -1
            }
        }
        let max = classCollectionView.numberOfItems(inSection: 0)
        for i in 0...max {
            if let cell = classCollectionView.cellForItem(at: [0, i]) as? currentClassCollectionViewCell {
                imgList[i] = cell.stepImg.image!
                titleList[i] = cell.stepName.text!
                descList[i] = cell.stepDesc.text!
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
        let max = classCollectionView.numberOfItems(inSection: 0)
        for i in 0...max {
            if let cell = classCollectionView.cellForItem(at: [0, i]) as? currentClassCollectionViewCell {
                imgList[i] = cell.stepImg.image!
                titleList[i] = cell.stepName.text!
                descList[i] = cell.stepDesc.text!
            }
        }
        cellInSection[0] += 1
        imgList.append(UIImage())
        titleList.append("")
        descList.append("")
        classCollectionView.reloadData()
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                if !self.isKeyboardInTitle {
                    self.view.frame.origin.y -= keyboardSize.height / 2.0
                }
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height / 2.0
            }
            self.isKeyboardInTitle = false
        }
        let max = classCollectionView.numberOfItems(inSection: 0)
        for i in 0...max {
            if let cell = classCollectionView.cellForItem(at: [0, i]) as? currentClassCollectionViewCell {
                imgList[i] = cell.stepImg.image!
                titleList[i] = cell.stepName.text!
                descList[i] = cell.stepDesc.text!
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPreview" {
            let destViewController = segue.destination as! UINavigationController
            let preview = destViewController.viewControllers.first as! previewViewController
            preview.titleList = self.titleList
            preview.descList = self.descList
            preview.imgList = self.imgList
        }
    }
    
    @IBAction func previewTapped(_ sender: Any) {
        let max = classCollectionView.numberOfItems(inSection: 0)
        for i in 0...max {
            if let cell = classCollectionView.cellForItem(at: [0, i]) as? currentClassCollectionViewCell {
                imgList[i] = cell.stepImg.image!
                titleList[i] = cell.stepName.text!
                descList[i] = cell.stepDesc.text!
            }
        }
        performSegue(withIdentifier: "toPreview", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func longPressed(sender: UILongPressGestureRecognizer) {
        
        struct My {
            static var cellSnapshot : UIView? = nil
        }
        struct Path {
            static var initialIndexPath : IndexPath? = nil
        }
        
        let touchPoint = sender.location(in: self.classCollectionView)
        let state = sender.state
        if let indexPath = self.classCollectionView.indexPathForItem(at: touchPoint) {
            switch state {
            case UIGestureRecognizerState.began:
                if indexPath.section == 0 {
                    if isEditMode {
                        let cell = self.classCollectionView.cellForItem(at: selectedIndex) as! currentClassCollectionViewCell
                        cell.contentView.backgroundColor = UIColor.white
                        cell.stepImg.backgroundColor = UIColor.lightGray
                        cell.stepImg.alpha = 1.0
                        cell.addImg.isEnabled = true
                        cell.stepName.isEnabled = true
                        cell.stepDesc.isEditable = true
                    }
                    self.selectedIndex = indexPath
                    if isCoverSet {
                        self.coverIndex = Path.initialIndexPath!
                    }
                    let editCell = self.classCollectionView.cellForItem(at: indexPath) as! currentClassCollectionViewCell
                    editCell.contentView.backgroundColor = UIColor(red: 0.9137, green: 0.9137, blue: 0.9843, alpha: 1.0)
                    editCell.stepImg.backgroundColor = UIColor(red: 0.5764, green: 0.6353, blue: 0.96078, alpha: 1.0)
                    editCell.stepImg.alpha = 0.2
                    editCell.addImg.isEnabled = false
                    editCell.stepName.isEnabled = false
                    editCell.stepDesc.isEditable = false
                    self.editViewBottomC.constant = 0
                    UIView.animate(withDuration: 0.3, animations: {
                        self.view.layoutIfNeeded()
                    })
                    Path.initialIndexPath = indexPath
                    let cell = self.classCollectionView.cellForItem(at: indexPath) as! currentClassCollectionViewCell
                    My.cellSnapshot  = self.snapshotOfCell(inputView: cell)
                    var center = cell.center
                    My.cellSnapshot!.center = center
                    My.cellSnapshot!.alpha = 0.0
                    self.classCollectionView.addSubview(My.cellSnapshot!)
                    
                    UIView.animate(withDuration: 0.25, animations: { () -> Void in
                        center.y = touchPoint.y
                        My.cellSnapshot!.center = center
                        My.cellSnapshot!.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                        My.cellSnapshot!.alpha = 0.98
                        cell.alpha = 0.0
                    }, completion: { (finished) -> Void in
                        if finished {
                            cell.isHidden = true
                        }
                    })
                    isEditMode = true
                }
            case UIGestureRecognizerState.changed:
                if indexPath.section == 0 && My.cellSnapshot != nil {
                    var center = My.cellSnapshot!.center
                    center.x = touchPoint.x
                    My.cellSnapshot!.center = center
                    if let indexPath = self.classCollectionView.indexPathForItem(at: touchPoint) {
                        if (indexPath != Path.initialIndexPath) {
                            self.classCollectionView.moveItem(at: indexPath, to: Path.initialIndexPath!)
                            Path.initialIndexPath = indexPath
                            self.selectedIndex = indexPath
                            if isCoverSet {
                                self.coverIndex = Path.initialIndexPath!
                            }
                        }
                    }
                }
            case UIGestureRecognizerState.ended:
                if indexPath.section == 0 {
                    if let cell = self.classCollectionView.cellForItem(at: Path.initialIndexPath!) as? currentClassCollectionViewCell {
                        self.selectedIndex = Path.initialIndexPath!
                        if isCoverSet {
                            self.coverIndex = Path.initialIndexPath!
                        }
                        cell.isHidden = false
                        cell.alpha = 0.0
                        UIView.animate(withDuration: 0.25, animations: { () -> Void in
                            My.cellSnapshot!.center = cell.center
                            My.cellSnapshot!.transform = CGAffineTransform.identity
                            My.cellSnapshot!.alpha = 0.0
                            cell.alpha = 1.0
                        }, completion: { (finished) -> Void in
                            if finished {
                                let max = self.classCollectionView.numberOfItems(inSection: 0)
                                for i in 0...max {
                                    if let cell = self.classCollectionView.cellForItem(at: [0, i]) as? currentClassCollectionViewCell {
                                        cell.isHidden = false
                                        cell.alpha = 1.0
                                        self.imgList[i] = cell.stepImg.image!
                                        self.titleList[i] = cell.stepName.text!
                                        self.descList[i] = cell.stepDesc.text!
                                    }
                                }
                                Path.initialIndexPath = nil
                                My.cellSnapshot!.removeFromSuperview()
                                My.cellSnapshot = nil
                                self.classCollectionView.reloadData()
                            }
                        })
                    }
                } else {
                    if let cell = self.classCollectionView.cellForItem(at: selectedIndex) as? currentClassCollectionViewCell {
                        cell.isHidden = false
                        cell.alpha = 0.0
                        UIView.animate(withDuration: 0.25, animations: { () -> Void in
                            My.cellSnapshot!.center = cell.center
                            My.cellSnapshot!.transform = CGAffineTransform.identity
                            My.cellSnapshot!.alpha = 0.0
                            cell.alpha = 1.0
                        }, completion: { (finished) -> Void in
                            if finished {
                                let max = self.classCollectionView.numberOfItems(inSection: 0)
                                for i in 0...max {
                                    if let cell = self.classCollectionView.cellForItem(at: [0, i]) as? currentClassCollectionViewCell {
                                        self.imgList[i] = cell.stepImg.image!
                                        self.titleList[i] = cell.stepName.text!
                                        self.descList[i] = cell.stepDesc.text!
                                    }
                                }
                                if Path.initialIndexPath != nil {
                                    Path.initialIndexPath = nil
                                }
                                if My.cellSnapshot != nil {
                                    My.cellSnapshot!.removeFromSuperview()
                                    My.cellSnapshot = nil
                                }
                                self.classCollectionView.reloadData()
                            }
                        })
                    }
                }
            default:
                return
            }
        } else {
            if sender.state == UIGestureRecognizerState.ended {
                if let cell = self.classCollectionView.cellForItem(at: selectedIndex) as? currentClassCollectionViewCell {
                    cell.isHidden = false
                    cell.alpha = 0.0
                    UIView.animate(withDuration: 0.25, animations: { () -> Void in
                        My.cellSnapshot!.center = cell.center
                        My.cellSnapshot!.transform = CGAffineTransform.identity
                        My.cellSnapshot!.alpha = 0.0
                        cell.alpha = 1.0
                    }, completion: { (finished) -> Void in
                        if finished {
                            let max = self.classCollectionView.numberOfItems(inSection: 0)
                            for i in 0...max {
                                if let cell = self.classCollectionView.cellForItem(at: [0, i]) as? currentClassCollectionViewCell {
                                    self.imgList[i] = cell.stepImg.image!
                                    self.titleList[i] = cell.stepName.text!
                                    self.descList[i] = cell.stepDesc.text!
                                }
                            }
                            if Path.initialIndexPath != nil {
                                Path.initialIndexPath = nil
                            }
                            if My.cellSnapshot != nil {
                                My.cellSnapshot!.removeFromSuperview()
                                My.cellSnapshot = nil
                            }
                            self.classCollectionView.reloadData()
                        }
                    })
                }
            }
        }
    }
    
    func snapshotOfCell(inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext() as! UIImage
        UIGraphicsEndImageContext()
        let cellSnapshot : UIView = UIImageView(image: image)
        cellSnapshot.layer.masksToBounds = false
        cellSnapshot.layer.cornerRadius = 0.0
        cellSnapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
        cellSnapshot.layer.shadowRadius = 5.0
        cellSnapshot.layer.shadowOpacity = 0.4
        return cellSnapshot
    }
    
    @IBAction func addPrevTapped(_ sender: Any) {
        if isCoverSet {
            coverIndex = [0, selectedIndex.item+1]
        }
        self.cellInSection[0] += 1
        self.titleList.insert("", at: self.selectedIndex.item)
        self.descList.insert("", at: self.selectedIndex.item)
        self.imgList.insert(UIImage(), at: self.selectedIndex.item)
        let cell = self.classCollectionView.cellForItem(at: selectedIndex) as! currentClassCollectionViewCell
        cell.contentView.backgroundColor = UIColor.white
        cell.stepImg.backgroundColor = UIColor.lightGray
        cell.stepImg.alpha = 1.0
        cell.addImg.isEnabled = true
        cell.stepName.isEnabled = true
        cell.stepDesc.isEditable = true
        self.editViewBottomC.constant = -80
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
        isEditMode = false
        selectedIndex = [-1, -1]
        self.classCollectionView.reloadData()
    }
    
    @IBAction func addNextTapped(_ sender: Any) {
        self.cellInSection[0] += 1
        self.titleList.insert("", at: self.selectedIndex.item+1)
        self.descList.insert("", at: self.selectedIndex.item+1)
        self.imgList.insert(UIImage(), at: self.selectedIndex.item+1)
        let cell = self.classCollectionView.cellForItem(at: selectedIndex) as! currentClassCollectionViewCell
        cell.contentView.backgroundColor = UIColor.white
        cell.stepImg.backgroundColor = UIColor.lightGray
        cell.stepImg.alpha = 1.0
        cell.addImg.isEnabled = true
        cell.stepName.isEnabled = true
        cell.stepDesc.isEditable = true
        self.editViewBottomC.constant = -80
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
        isEditMode = false
        selectedIndex = [-1, -1]
        self.classCollectionView.reloadData()
    }
    
    @IBAction func setCoverTapped(_ sender: Any) {
        let cell = self.classCollectionView.cellForItem(at: selectedIndex) as! currentClassCollectionViewCell
        cell.contentView.backgroundColor = UIColor.white
        cell.stepImg.backgroundColor = UIColor.lightGray
        cell.stepImg.alpha = 1.0
        cell.addImg.isEnabled = true
        cell.stepName.isEnabled = true
        cell.stepDesc.isEditable = true
        if cell.stepImg.image?.size.width != 0 {
            coverImg = cell.stepImg.image!
            isCoverSet = true
            coverIndex = selectedIndex
        } else {
            let alertController = UIAlertController(
                title: "提示",
                message: "選擇的圖片為空！",
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
        }
        self.editViewBottomC.constant = -80
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
        isEditMode = false
        selectedIndex = [-1, -1]
        self.classCollectionView.reloadData()
    }
    
    @IBAction func deleteTapped(_ sender: Any) {
        if coverIndex == selectedIndex {
            isCoverSet = false
            coverImg = UIImage()
        }
        self.cellInSection[0] -= 1
        self.titleList.remove(at: self.selectedIndex.item)
        self.descList.remove(at: self.selectedIndex.item)
        self.imgList.remove(at: self.selectedIndex.item)
        let cell = self.classCollectionView.cellForItem(at: selectedIndex) as! currentClassCollectionViewCell
        cell.contentView.backgroundColor = UIColor.white
        cell.stepImg.backgroundColor = UIColor.lightGray
        cell.stepImg.alpha = 1.0
        cell.addImg.isEnabled = true
        cell.stepName.isEnabled = true
        cell.stepDesc.isEditable = true
        self.editViewBottomC.constant = -80
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
        isEditMode = false
        selectedIndex = [-1, -1]
        self.classCollectionView.reloadData()
    }
    
    func leaveEditMode() {
        if isEditMode {
            let cell = self.classCollectionView.cellForItem(at: selectedIndex) as! currentClassCollectionViewCell
            cell.contentView.backgroundColor = UIColor.white
            cell.stepImg.backgroundColor = UIColor.lightGray
            cell.stepImg.alpha = 1.0
            cell.addImg.isEnabled = true
            cell.stepName.isEnabled = true
            cell.stepDesc.isEditable = true
            self.editViewBottomC.constant = -80
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
            isEditMode = false
            selectedIndex = [-1, -1]
        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
