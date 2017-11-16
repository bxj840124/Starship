//
//  recordViewController.swift
//  Starship
//
//  Created by 楊喬宇 on 2017/11/16.
//  Copyright © 2017年 楊喬宇. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import MobileCoreServices
import AVKit

class recordViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, AVPlayerViewControllerDelegate {

    @IBOutlet weak var videoBtn: UIButton!
    @IBOutlet weak var recordVideo: UIImageView!
    @IBOutlet weak var recordCollectionView: UICollectionView!
    
    var isUserClasses = false
    var userClasses = [classStep]()
    var evaluation = [Int]()
    var videoUrl = NSURL()
    
    var classes = ["認得正反左右", "找到洞", "捲到襪頭", "撐開", "放入", "拉高"]
    var descs = ["將兩隻襪子擺正，並找出左腳與右腳。", "選一隻襪子，找到襪子的開口處。", "用雙手把襪子的開口處捲到襪頭，並抓住開口處與襪頭。", "輕輕撐開襪子的開口處，讓腳容易放入", "把對應的左右腳伸進襪子裡。", "最後再把襪子開口處沿著腳往上拉到腳踝的地方，就穿好一隻襪子了！另外一隻腳也是一樣喔！"]
    var assistTitle = ["獨立操作", "口語提示", "手勢提示", "示範協助", "部分肢體協助", "完全肢體協助"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        recordVideo.layer.cornerRadius = 10
        recordVideo.clipsToBounds = true
        videoBtn.layer.cornerRadius = 10
        videoBtn.clipsToBounds = true
        
        let emptyUrl = NSURL()
        if videoUrl == emptyUrl {
            videoBtn.setTitle("無影片紀錄", for: .normal)
            videoBtn.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            videoBtn.isEnabled = false
        } else {
            videoBtn.setTitle("影片紀錄", for: .normal)
            videoBtn.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            videoBtn.isEnabled = true
            let asset = AVURLAsset(url: videoUrl as URL , options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            do {
                let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
                let thumbnail = UIImage(cgImage: cgImage)
                recordVideo.image = thumbnail
            } catch let error as NSError {
                print("Error generating thumbnail: \(error.localizedDescription)")
            }
        }
        // 建立 UICollectionViewFlowLayout
        let layout = UICollectionViewFlowLayout()
        
        // 設置 section 的間距 四個數值分別代表 上、左、下、右 的間距
        layout.sectionInset = UIEdgeInsetsMake(-30, 10, 0, 10);
        layout.scrollDirection = .horizontal
        
        // 設置每一行的間距
        layout.minimumLineSpacing = 20
        
        // 設置每個 cell 的尺寸
        layout.itemSize = CGSize(width: 246, height: 405)
        
        recordCollectionView.setCollectionViewLayout(layout, animated: true)
        
        // 設置委任對象
        recordCollectionView.delegate = self
        recordCollectionView.dataSource = self
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gameCell", for: indexPath as IndexPath) as! gameCollectionViewCell
            
            cell.contentView.backgroundColor = UIColor.white
            cell.contentView.layer.cornerRadius = 10
            cell.contentView.layer.borderWidth = 1.0
            cell.contentView.layer.borderColor = UIColor.clear.cgColor
            cell.contentView.layer.masksToBounds = true
            
            cell.layer.shadowColor = UIColor.lightGray.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
            cell.layer.shadowRadius = 2.0
            cell.layer.shadowOpacity = 1.0
            cell.layer.masksToBounds = false
            cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
            
            cell.stepImg.image = UIImage(named: "穿襪子0\(indexPath.item+1)")
            cell.stepImg.contentMode = .scaleAspectFill
            
            let borderColor = UIColor(red: 1.0, green: 0.4784, blue: 0.67058, alpha: 1.0)
            cell.stepNum.layer.cornerRadius = cell.stepNum.frame.width/2.0
            cell.stepNum.clipsToBounds = true
            cell.stepNum.layer.borderColor = borderColor.withAlphaComponent(0.2).cgColor
            cell.stepNum.layer.borderWidth = 4.0
            cell.stepNum.text = "\(indexPath.item+1)"
            
            cell.stepName.text = classes[indexPath.item]
            cell.stepDesc.text = descs[indexPath.item]
            if evaluation[indexPath.item] == -1 {
                cell.assistTitle.text = "尚未選擇"
            } else {
                cell.assistTitle.text = assistTitle[evaluation[indexPath.item]]
            }
            cell.assistTitle.layer.borderColor = UIColor.darkGray.cgColor
            cell.assistTitle.layer.borderWidth = 1.0
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gameCell", for: indexPath as IndexPath) as! gameCollectionViewCell
            
            cell.contentView.backgroundColor = UIColor.white
            cell.contentView.layer.cornerRadius = 10
            cell.contentView.layer.borderWidth = 1.0
            cell.contentView.layer.borderColor = UIColor.clear.cgColor
            cell.contentView.layer.masksToBounds = true
            
            cell.layer.shadowColor = UIColor.lightGray.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
            cell.layer.shadowRadius = 2.0
            cell.layer.shadowOpacity = 1.0
            cell.layer.masksToBounds = false
            cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
            
            cell.stepImg.image = UIImage(data: self.userClasses[indexPath.item]["stepImg"] as! Data)
            cell.stepImg.contentMode = .scaleAspectFill
            
            let borderColor = UIColor(red: 1.0, green: 0.4784, blue: 0.67058, alpha: 1.0)
            cell.stepNum.layer.cornerRadius = cell.stepNum.frame.width/2.0
            cell.stepNum.clipsToBounds = true
            cell.stepNum.layer.borderColor = borderColor.withAlphaComponent(0.2).cgColor
            cell.stepNum.layer.borderWidth = 4.0
            cell.stepNum.text = "\(indexPath.item+1)"
            
            cell.stepName.text = self.userClasses[indexPath.item]["stepTitle"] as? String
            cell.stepDesc.text = self.userClasses[indexPath.item]["stepContent"] as? String
            if evaluation[indexPath.item] == -1 {
                cell.assistTitle.text = "尚未選擇"
            } else {
                cell.assistTitle.text = assistTitle[evaluation[indexPath.item]]
            }
            cell.assistTitle.layer.borderColor = UIColor.darkGray.cgColor
            cell.assistTitle.layer.borderWidth = 1.0
            
            return cell
        }
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func videoTapped(_ sender: Any) {
        let playerController = AVPlayerViewController()
        playerController.delegate = self
        
        let player = AVPlayer(url: videoUrl as URL)
        playerController.player = player
        self.showDetailViewController(playerController, sender: self)
    }
    
    @IBAction func finishTapped(_ sender: Any) {
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
