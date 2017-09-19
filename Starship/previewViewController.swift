//
//  previewViewController.swift
//  Starship
//
//  Created by 楊喬宇 on 2017/9/14.
//  Copyright © 2017年 楊喬宇. All rights reserved.
//

import UIKit

class previewViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var previewSegmentView: UISegmentedControl!
    @IBOutlet weak var previewCollectionView: UICollectionView!
    @IBOutlet weak var previewSegement: UISegmentedControl!
    @IBOutlet weak var previewCollectionView2: UICollectionView!
    
    var segmentType = 0
    var classes = ["打開水龍頭", "沖濕雙手", "抹肥皂", "仔細搓揉雙手", "沖洗泡沫", "關起水龍頭", "擦乾雙手"]
    var descs = ["向上扳起或逆時針方向轉開水龍頭。", "將雙手用水徹底沖濕。", "抹上肥皂或擠一點洗手乳，並搓揉雙手讓它起泡。", "將雙手的每根手指、手心、手背、指尖、指縫等都搓洗乾淨，這個動作要持續至少20秒喔！", "再次打開水龍頭，將雙手上的泡沫清洗乾淨。", "清洗完畢後，用一點水沖掉水龍頭上的殘留泡沫，再把水龍頭關上，記得要關緊！", "用乾淨的毛巾擦拭雙手，你就學會洗手了！"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // 建立 UICollectionViewFlowLayout
        let layout = UICollectionViewFlowLayout()
        
        // 設置 section 的間距 四個數值分別代表 上、左、下、右 的間距
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        
        // 設置每一行的間距
        layout.minimumLineSpacing = 20
        
        // 設置每個 cell 的尺寸
        layout.itemSize = CGSize(width: 226, height: 125)
        
        previewCollectionView.setCollectionViewLayout(layout, animated: true)
        
        // 設置委任對象
        previewCollectionView.delegate = self
        previewCollectionView.dataSource = self
        
        // 建立 UICollectionViewFlowLayout
        let layout2 = UICollectionViewFlowLayout()
        
        // 設置 section 的間距 四個數值分別代表 上、左、下、右 的間距
        layout2.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        layout2.scrollDirection = .horizontal
        
        // 設置每一行的間距
        layout2.minimumLineSpacing = 20
        
        // 設置每個 cell 的尺寸
        layout2.itemSize = CGSize(width: 246, height: 531)
        
        previewCollectionView2.setCollectionViewLayout(layout2, animated: true)
        
        // 設置委任對象
        previewCollectionView2.delegate = self
        previewCollectionView2.dataSource = self
        
        previewCollectionView2.isHidden = true
        previewCollectionView.isHidden = false
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.previewCollectionView {
            // 依據前面註冊設置的識別名稱 "Cell" 取得目前使用的 cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "previewCell", for: indexPath as IndexPath) as! previewCollectionViewCell
            
            cell.contentView.backgroundColor = UIColor.white
            cell.contentView.layer.cornerRadius = 10
            cell.contentView.layer.borderWidth = 1.0
            cell.contentView.layer.borderColor = UIColor.clear.cgColor
            cell.contentView.layer.masksToBounds = true
            
            cell.bgImage.image = UIImage(named: "洗手0\(indexPath.item+1).jpg")
            cell.bgImage.contentMode = .scaleAspectFill
            
            let borderColor = UIColor(red: 1.0, green: 0.9, blue: 0.93725, alpha: 1.0)
            cell.classNum.layer.cornerRadius = cell.classNum.frame.width/2.0
            cell.classNum.clipsToBounds = true
            cell.classNum.layer.borderColor = borderColor.cgColor
            cell.classNum.layer.borderWidth = 4.0
            cell.classNum.text = "\(indexPath.item+1)"
            
            return cell
        } else {
            // 依據前面註冊設置的識別名稱 "Cell" 取得目前使用的 cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "previewCell2", for: indexPath as IndexPath) as! previewCollectionViewCell2
            
            cell.contentView.backgroundColor = UIColor.white
            cell.contentView.layer.cornerRadius = 10
            cell.contentView.layer.borderWidth = 1.0
            cell.contentView.layer.borderColor = UIColor.clear.cgColor
            cell.contentView.layer.masksToBounds = true
            
            cell.stepImg.image = UIImage(named: "洗手0\(indexPath.item+1)")
            cell.stepImg.contentMode = .scaleAspectFill
            cell.stepImg.clipsToBounds = true
            
            let borderColor = UIColor(red: 1.0, green: 0.9, blue: 0.93725, alpha: 1.0)
            cell.stepNum.layer.cornerRadius = cell.stepNum.frame.width/2.0
            cell.stepNum.clipsToBounds = true
            cell.stepNum.layer.borderColor = borderColor.cgColor
            cell.stepNum.layer.borderWidth = 4.0
            cell.stepNum.text = "\(indexPath.item+1)"
            
            cell.stepName.text = classes[indexPath.item]
            cell.stepDesc.text = descs[indexPath.item]
            
            return cell
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item+1)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segmentTapped(_ sender: UISegmentedControl) {
        self.segmentType = sender.selectedSegmentIndex
        if sender.selectedSegmentIndex == 0 {
            
            previewCollectionView2.isHidden = true
            previewCollectionView.isHidden = false
            
        } else {
            
            previewCollectionView.isHidden = true
            previewCollectionView2.isHidden = false
            
        }
    }
    
    @IBAction func backTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
