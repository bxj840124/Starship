//
//  moreClassViewController.swift
//  Starship
//
//  Created by 楊喬宇 on 2017/9/16.
//  Copyright © 2017年 楊喬宇. All rights reserved.
//

import UIKit

class moreClassViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var patientImg: UIImageView!
    @IBOutlet weak var patientNum: UILabel!
    @IBOutlet weak var patientName: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var moreClassCollectionView: UICollectionView!

    var classTypes = ["生活技能", "生活技能", "生活技能", "動作訓練", "動作訓練", "動作訓練", "動作訓練", "我的教材庫"]
    var classNames = ["洗手", "刷牙", "洗澡", "用筷子", "爬", "玩黏土", "扣扣子", "洗頭"]
    var recordClassTypes = ["動作訓練", "動作訓練", "動作訓練", "動作訓練"]
    var recordClassNames = ["組積木", "拼拼圖", "串串珠", "握筆塗鴉"]
    
    var img = UIImage()
    var num = ""
    var name = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        searchBar.searchBarStyle = .minimal
        patientImg.image = img
        patientImg.contentMode = .scaleAspectFill
        patientImg.clipsToBounds = true
        patientImg.layer.cornerRadius = patientImg.frame.width/2.0
        patientImg.layer.borderColor = UIColor.black.cgColor
        patientImg.layer.borderWidth = 1.0
        patientNum.text = num
        patientName.text = name
        
        // 建立 UICollectionViewFlowLayout
        let layout = UICollectionViewFlowLayout()
        
        // 設置 section 的間距 四個數值分別代表 上、左、下、右 的間距
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        
        // 設置每一行的間距
        layout.minimumLineSpacing = 20.0
        
        // 設置每個 cell 的尺寸
        layout.itemSize = CGSize(width: 226, height: 150)
        layout.headerReferenceSize = CGSize(width: 984, height: 50)
        
        moreClassCollectionView.setCollectionViewLayout(layout, animated: true)
        
        // 設置委任對象
        moreClassCollectionView.delegate = self
        moreClassCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 8
        } else {
            return 4
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            // 依據前面註冊設置的識別名稱 "Cell" 取得目前使用的 cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "classRecordCell", for: indexPath as IndexPath) as! classRecordCollectionViewCell
            
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
            
            cell.classType.text = classTypes[indexPath.item]
            cell.className.text = classNames[indexPath.item]
            cell.bgImg.image = UIImage(named: "record\(indexPath.item+1).jpg")
            cell.bgImg.contentMode = .scaleAspectFill
            cell.bgImg.clipsToBounds = true
            cell.startBtn.layer.cornerRadius = cell.startBtn.frame.height/2.0
            cell.startBtn.clipsToBounds = true
            cell.recordBtn.layer.cornerRadius = cell.recordBtn.frame.height/2.0
            cell.recordBtn.clipsToBounds = true
            
            cell.startBtn.addTarget(self, action: #selector(moreClassViewController.startTapped), for: UIControlEvents.touchUpInside)
            
            return cell
        } else {
            // 依據前面註冊設置的識別名稱 "Cell" 取得目前使用的 cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "classRecordCell", for: indexPath as IndexPath) as! classRecordCollectionViewCell
            
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
            
            cell.classType.text = recordClassTypes[indexPath.item]
            cell.className.text = recordClassNames[indexPath.item]
            cell.bgImg.image = UIImage(named: "record\(indexPath.item+9).jpg")
            cell.bgImg.contentMode = .scaleAspectFill
            cell.bgImg.clipsToBounds = true
            cell.startBtn.layer.cornerRadius = cell.startBtn.frame.height/2.0
            cell.startBtn.clipsToBounds = true
            cell.recordBtn.layer.cornerRadius = cell.recordBtn.frame.height/2.0
            cell.recordBtn.clipsToBounds = true
            
            cell.startBtn.addTarget(self, action: #selector(moreClassViewController.startTapped), for: UIControlEvents.touchUpInside)
            
            return cell
        }
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "moreHeader", for: indexPath) as! moreCollectionReusableView
            // 設置 header 的內容
        if indexPath.section == 0 {
            reusableView.title.text = "正在學習項目"
        } else {
            reusableView.title.text = "過去學習項目"
        }
    
        return reusableView
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func startTapped() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "toGame")
        present(vc, animated: true, completion: nil)
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
