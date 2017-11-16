//
//  therapistEntryViewController.swift
//  Starship
//
//  Created by 楊喬宇 on 2017/9/8.
//  Copyright © 2017年 楊喬宇. All rights reserved.
//

import UIKit

class therapistEntryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var therapistCollectionView: UICollectionView!
    @IBOutlet weak var leadingC: NSLayoutConstraint!
    @IBOutlet weak var searchLeadingC: NSLayoutConstraint!
    @IBOutlet weak var collectionLeadingC: NSLayoutConstraint!
    @IBOutlet weak var leftMenu: UIView!
    @IBOutlet weak var leftImg: UIImageView!
    @IBOutlet weak var mask: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var leftMenuIsVisible = false
    
    var fullScreenSize :CGSize!
    var names = ["吳東承", "蔡捷安", "Winnie", "邱立全", "莊以琳", "周辰"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        mask.isHidden = true
        
        searchBar.searchBarStyle = .minimal
        
        self.leftMenu.layer.shadowOpacity = 0.5
        self.leftMenu.layer.shadowRadius = 2
        
        self.leadingC.constant = -282
        self.searchLeadingC.constant = 10
        self.collectionLeadingC.constant = 0
        
        leftImg.layer.cornerRadius = leftImg.frame.width/2.0
        leftImg.clipsToBounds = true
        leftImg.layer.borderColor = UIColor.black.cgColor
        leftImg.layer.borderWidth = 1.0
        
        self.fullScreenSize = UIScreen.main.bounds.size
        
        // 建立 UICollectionViewFlowLayout
        let layout = UICollectionViewFlowLayout()
        
        // 設置 section 的間距 四個數值分別代表 上、左、下、右 的間距
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        
        // 設置每一行的間距
        layout.minimumLineSpacing = 20
        
        // 設置每個 cell 的尺寸
        layout.itemSize = CGSize(width: CGFloat(fullScreenSize.width)/4 - 20.0, height: CGFloat(fullScreenSize.height)/4 - 20.0)
        
        self.therapistCollectionView.setCollectionViewLayout(layout, animated: true)
        
        // 設置委任對象
        self.therapistCollectionView.delegate = self
        self.therapistCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 依據前面註冊設置的識別名稱 "Cell" 取得目前使用的 cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! therapistCollectionViewCell
        
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
        
        cell.patientImg.layer.cornerRadius = cell.patientImg.frame.width/2.0
        cell.patientImg.clipsToBounds = true
            
        // 設置 cell 內容 (即自定義元件裡 增加的圖片與文字元件)
        cell.patientImg.image = UIImage(named: "kid\(indexPath.item+1).jpg")
        cell.patientNum.text = "star00\(indexPath.item + 1)"
        cell.patientName.text = names[indexPath.item]
        cell.flag.layer.cornerRadius = 5
        cell.flag.clipsToBounds = true
        
        cell.shareBtn.addTarget(self, action: #selector(therapistEntryViewController.shareToParent), for: UIControlEvents.touchUpInside)
            
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! therapistCollectionViewCell
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "toInfo") as! infoViewController
        vc.img = cell.patientImg.image!
        vc.num = cell.patientNum.text!
        vc.name = cell.patientName.text!
        
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func leftMenuTapped(_ sender: Any) {
        
        if (self.leftMenuIsVisible) {
            self.leadingC.constant = -282
            self.searchLeadingC.constant = 10
            self.collectionLeadingC.constant = 0
            
            UIView.animate(withDuration: 0.3, animations: {
                self.mask.isHidden = true
                self.view.layoutIfNeeded()
            })
        } else {
            self.leadingC.constant = 0
            self.searchLeadingC.constant = 282
            self.collectionLeadingC.constant = 272
            
            UIView.animate(withDuration: 0.3, animations: {
                self.mask.isHidden = false
                self.view.layoutIfNeeded()
            })
        }
        self.leftMenuIsVisible = !self.leftMenuIsVisible
        
    }
    
    @IBAction func createPatientTapped(_ sender: Any) {
        let popVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "createPop") as! createPatientViewController
        self.addChildViewController(popVC)
        popVC.view.frame = self.view.frame
        self.view.addSubview(popVC.view)
        popVC.didMove(toParentViewController: self)
    }
    
    func shareToParent() {
        let popVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "share") as! shareViewController
        self.addChildViewController(popVC)
        popVC.view.frame = self.view.frame
        self.view.addSubview(popVC.view)
        popVC.didMove(toParentViewController: self)
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        self.view.window?.rootViewController?.dismiss(animated: false, completion: nil)
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
