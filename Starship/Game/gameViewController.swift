//
//  gameViewController.swift
//  Starship
//
//  Created by 楊喬宇 on 2017/9/15.
//  Copyright © 2017年 楊喬宇. All rights reserved.
//

import UIKit
import RealmSwift
import MobileCoreServices
import AVFoundation

class gameViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var bottomBar: UIImageView!
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var gameCollectionView2: UICollectionView!
    
    var classes = ["認得正反左右", "找到洞", "捲到襪頭", "撐開", "放入", "拉高"]
    var descs = ["將兩隻襪子擺正，並找出左腳與右腳。", "選一隻襪子，找到襪子的開口處。", "用雙手把襪子的開口處捲到襪頭，並抓住開口處與襪頭。", "輕輕撐開襪子的開口處，讓腳容易放入", "把對應的左右腳伸進襪子裡。", "最後再把襪子開口處沿著腳往上拉到腳踝的地方，就穿好一隻襪子了！另外一隻腳也是一樣喔！"]
    var assistArray = ["完全肢體協助", "部分肢體協助", "示範協助", "口語提示", "手勢提示", "獨立操作"]
    var assistTitle = ["部分肢體協助", "部分肢體協助", "部分肢體協助", "部分肢體協助", "部分肢體協助", "部分肢體協助", "部分肢體協助"]
    
    var isSortViewVisible = false
    var isGuideVisible = false
    var selectNum = -1
    
    var userClasses = [classStep]()
    var isUserClasses = false
    var viewTitle = ""
    
    var videoUrl = NSURL()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gameViewController.doneClicked))
        //self.view.addGestureRecognizer(tap)
        
        if isUserClasses {
            self.navigationItem.title = viewTitle
        } else {
            self.navigationItem.title = "穿襪子"
        }
        
        recordBtn.layer.cornerRadius = recordBtn.frame.width/2.0
        recordBtn.clipsToBounds = true
        
        // 建立 UICollectionViewFlowLayout
        let layout2 = UICollectionViewFlowLayout()
        
        // 設置 section 的間距 四個數值分別代表 上、左、下、右 的間距
        layout2.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        
        // 設置每一行的間距
        layout2.minimumLineSpacing = 20
        
        // 設置每個 cell 的尺寸
        layout2.itemSize = CGSize(width: 226, height: 170)
        
        gameCollectionView2.setCollectionViewLayout(layout2, animated: true)
        
        // 設置委任對象
        gameCollectionView2.delegate = self
        gameCollectionView2.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !isUserClasses {
            return 6
        } else {
            return self.userClasses.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 依據前面註冊設置的識別名稱 "Cell" 取得目前使用的 cell
        if !isUserClasses {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gameCell2", for: indexPath as IndexPath) as! gameCollectionViewCell2
            
            let backgroundColor = UIColor(red: 0.9804, green: 0.9843, blue: 1.0, alpha: 1.0)
            cell.contentView.backgroundColor = backgroundColor
            cell.contentView.layer.cornerRadius = 10
            cell.contentView.layer.borderWidth = 1.0
            cell.contentView.layer.borderColor = UIColor.clear.cgColor
            cell.contentView.layer.masksToBounds = true
            
            cell.bgImage.layer.shadowColor = UIColor.lightGray.cgColor
            cell.bgImage.layer.shadowOffset = CGSize(width: 0, height: 2.0)
            cell.bgImage.layer.shadowRadius = 2.0
            cell.bgImage.layer.shadowOpacity = 1.0
            cell.bgImage.layer.masksToBounds = false
            cell.bgImage.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
            
            cell.bgImage.layer.cornerRadius = 10
            cell.bgImage.image = UIImage(named: "穿襪子0\(indexPath.item+1)")
            cell.bgImage.contentMode = .scaleAspectFill
            cell.bgImage.clipsToBounds = true
            
            let borderColor = UIColor(red: 1.0, green: 0.4784, blue: 0.67058, alpha: 1.0)
            cell.classNum.layer.cornerRadius = cell.classNum.frame.width/2.0
            cell.classNum.clipsToBounds = true
            cell.classNum.layer.borderColor = borderColor.withAlphaComponent(0.2).cgColor
            cell.classNum.layer.borderWidth = 4.0
            cell.classNum.text = "\(indexPath.item+1)"
            
            cell.classTitle.text = classes[indexPath.item]
            cell.stickerBtn.tag = indexPath.item
            cell.stickerBtn.addTarget(self, action: #selector(self.popUpSticker), for: UIControlEvents.touchUpInside)
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gameCell2", for: indexPath as IndexPath) as! gameCollectionViewCell2
            
            let backgroundColor = UIColor(red: 0.9804, green: 0.9843, blue: 1.0, alpha: 1.0)
            cell.contentView.backgroundColor = backgroundColor
            cell.contentView.layer.cornerRadius = 10
            cell.contentView.layer.borderWidth = 1.0
            cell.contentView.layer.borderColor = UIColor.clear.cgColor
            cell.contentView.layer.masksToBounds = true
            
            cell.bgImage.layer.shadowColor = UIColor.lightGray.cgColor
            cell.bgImage.layer.shadowOffset = CGSize(width: 0, height: 2.0)
            cell.bgImage.layer.shadowRadius = 2.0
            cell.bgImage.layer.shadowOpacity = 1.0
            cell.bgImage.layer.masksToBounds = false
            cell.bgImage.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
            
            cell.bgImage.layer.cornerRadius = 10
            cell.bgImage.image = UIImage(data: self.userClasses[indexPath.item]["stepImg"] as! Data)
            cell.bgImage.contentMode = .scaleAspectFill
            cell.bgImage.clipsToBounds = true
            
            let borderColor = UIColor(red: 1.0, green: 0.4784, blue: 0.67058, alpha: 1.0)
            cell.classNum.layer.cornerRadius = cell.classNum.frame.width/2.0
            cell.classNum.clipsToBounds = true
            cell.classNum.layer.borderColor = borderColor.withAlphaComponent(0.2).cgColor
            cell.classNum.layer.borderWidth = 4.0
            cell.classNum.text = "\(indexPath.item+1)"
            
            cell.classTitle.text = self.userClasses[indexPath.item]["stepTitle"] as? String
            cell.stickerBtn.tag = indexPath.item
            cell.stickerBtn.addTarget(self, action: #selector(self.popUpSticker), for: UIControlEvents.touchUpInside)
            
            return cell
        }
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /*
        if !isUserClasses {
            let popVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "gameDetail") as! gameDetailViewController
            popVC.num = indexPath.item+1
            popVC.name = classes[indexPath.item]
            popVC.img = UIImage(named: "穿襪子0\(indexPath.item+1).jpg")
            popVC.isUserClasses = false
            self.addChildViewController(popVC)
            popVC.view.frame = self.view.frame
            popVC.view.tag = 100
            self.view.addSubview(popVC.view)
            popVC.didMove(toParentViewController: self)
        } else {
            let popVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "gameDetail") as! gameDetailViewController
            popVC.num = indexPath.item+1
            popVC.name = (self.userClasses[indexPath.item]["stepTitle"] as? String)!
            popVC.img = UIImage(data: self.userClasses[indexPath.item]["stepImg"] as! Data)
            popVC.isUserClasses = true
            popVC.userClasses = self.userClasses
            self.addChildViewController(popVC)
            popVC.view.frame = self.view.frame
            popVC.view.tag = 100
            self.view.addSubview(popVC.view)
            popVC.didMove(toParentViewController: self)
        }
*/
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func recordTapped(_ sender: Any) {
        let success = startCameraFromViewController(viewController: self, withDelegate: self)
        print(success)
    }
    
    func startCameraFromViewController(viewController: UIViewController, withDelegate delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate) -> Bool {
        if UIImagePickerController.isSourceTypeAvailable(.camera) == false {
            return false
        }
        
        let cameraController = UIImagePickerController()
        cameraController.sourceType = .camera
        cameraController.mediaTypes = [kUTTypeMovie as NSString as String]
        cameraController.allowsEditing = false
        cameraController.delegate = delegate
        
        present(cameraController, animated: true, completion: nil)
        return true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        dismiss(animated: true, completion: nil)
        // Handle a movie capture
        if mediaType == kUTTypeMovie {
            guard let path = (info[UIImagePickerControllerMediaURL] as! NSURL).path else { return }
            self.videoUrl = info[UIImagePickerControllerMediaURL] as! NSURL
            if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path) {
                UISaveVideoAtPathToSavedPhotosAlbum(path, self, #selector(self.video(videoPath:didFinishSavingWithError:contextInfo:)), nil)
            }
        }
    }
    
    func video(videoPath: NSString, didFinishSavingWithError error: NSError?, contextInfo info: AnyObject) {
        var title = "成功"
        var message = "影片已儲存"
        if let _ = error {
            title = "錯誤"
            message = "影片儲存失敗"
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func popUpSticker(sender: UIButton) {
        let popVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popSticker") as! stickerViewController
        if isUserClasses {
            popVC.isUserClasses = true
            popVC.userClasses = self.userClasses
        } else {
            popVC.isUserClasses = false
        }
        popVC.num = sender.tag
        self.addChildViewController(popVC)
        popVC.view.frame = self.view.frame
        self.view.addSubview(popVC.view)
        popVC.didMove(toParentViewController: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAnimate1" {
            if let nav = segue.destination as? UINavigationController {
                let vc = nav.viewControllers.first as! animate1ViewController
                vc.isUserClasses = self.isUserClasses
                vc.userClasses = self.userClasses
                vc.videoUrl = self.videoUrl
            }
        }
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
