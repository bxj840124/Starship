//
//  therapistClassViewController.swift
//  Starship
//
//  Created by 楊喬宇 on 2017/9/9.
//  Copyright © 2017年 楊喬宇. All rights reserved.
//

import UIKit

class therapistClassViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var classCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedSegment = 0
    var classTitles = [[["上廁所", "洗臉", "刷牙", "更多生活技能"], ["拉拉鍊", "扣扣子", "穿鞋", "更多生活技能"], ["用湯匙", "喝水", "用筷子", "更多生活技能"]], [["串珠子", "夾夾子", "捏黏土", "更多動作訓練"], ["用湯匙", "拿水杯", "用筷子", "更多動作訓練"]], [["摺襪子", "上廁所"], ["拉拉鍊", "穿鞋", "用叉子"]]]
    var headerTitles = [["廁所", "玄關", "餐廳"], ["手部動作訓練一", "手部動作訓練二"], ["我的創建列表", "19號的建議"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        searchBar.searchBarStyle = .minimal
        
        self.navigationController?.navigationBar.tintColor = UIColor.darkGray
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        
        // 建立 UICollectionViewFlowLayout
        let layout = UICollectionViewFlowLayout()
        
        // 設置 section 的間距 四個數值分別代表 上、左、下、右 的間距
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        
        // 設置每一行的間距
        layout.minimumLineSpacing = 20.0
        
        // 設置每個 cell 的尺寸
        layout.itemSize = CGSize(width: 226, height: 150)
        layout.headerReferenceSize = CGSize(width: 984, height: 50)
        
        classCollectionView.setCollectionViewLayout(layout, animated: true)
        
        // 設置委任對象
        classCollectionView.delegate = self
        classCollectionView.dataSource = self
    }
    
    @IBAction func segmentTapped(_ sender: UISegmentedControl) {
        selectedSegment = sender.selectedSegmentIndex
        classCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if selectedSegment == 0 {
            return 4
        } else if selectedSegment == 1 {
            return 4
        } else {
            if section == 0 {
                return 2
            } else {
                return 3
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 依據前面註冊設置的識別名稱 "Cell" 取得目前使用的 cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "classCell", for: indexPath as IndexPath) as! classCollectionViewCell
            
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
        
        cell.bgImg.image = UIImage(named: "class\(selectedSegment)\(indexPath.section)\(indexPath.item+1).jpg")
        cell.bgImg.contentMode = .scaleAspectFill
        cell.bgImg.clipsToBounds = true
        cell.title.text = classTitles[selectedSegment][indexPath.section][indexPath.item]
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if selectedSegment == 0 {
            return 3
        } else if selectedSegment == 1 {
            return 2
        } else {
            return 2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "classHeader", for: indexPath) as! classCollectionReusableView
        // 設置 header 的內容
        reusableView.title.text = headerTitles[selectedSegment][indexPath.section]
        
        return reusableView
    }
    
    @IBAction func createClassTapped(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "startCreate")
        self.present(vc, animated: true, completion: nil)
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
