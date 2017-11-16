//
//  infoViewController.swift
//  Starship
//
//  Created by 楊喬宇 on 2017/9/10.
//  Copyright © 2017年 楊喬宇. All rights reserved.
//

import UIKit

class infoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, LineChartDelegate {

    @IBOutlet weak var patientImg: UIImageView!
    @IBOutlet weak var patientNum: UILabel!
    @IBOutlet weak var patientName: UILabel!
    @IBOutlet weak var rewardCollectionView: UICollectionView!
    @IBOutlet weak var classCollectionView: UICollectionView!
    @IBOutlet weak var chartView: UIView!
    
    var img = UIImage()
    var num = ""
    var name = ""
    
    var evalMetrix = ["完全肢體協助 FP", "部分肢體協助 PP", "示範協助 MP", "口語提示 VP", "手勢提示 GP", "獨立操作 IP"]
    
    var rewardImgs = ["reward1.png", "reward1.png", "reward2.png", "reward2.png", "reward2.png", "reward2.png"]
    var classImgs = ["穿襪子01.jpg", "train2.jpg", "train3.jpg", "train4.jpg", "train5.jpg", "train6.jpg"]
    var classTypes = ["生活自理項目", "生活自理項目", "生活自理項目", "生活自理項目", "生活自理項目", "生活自理項目"]
    var classNames = ["穿襪子", "扣扣子", "上廁所", "洗手", "吃早餐", "刷牙"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        
        patientImg.image = img
        patientNum.text = num
        patientName.text = name
        
        patientImg.layer.cornerRadius = patientImg.frame.width/2.0
        patientImg.clipsToBounds = true
        patientImg.contentMode = .scaleAspectFill
        patientImg.layer.borderWidth = 1.0
        patientImg.layer.borderColor = UIColor.black.cgColor
        
        // 建立 UICollectionViewFlowLayout
        let layout1 = UICollectionViewFlowLayout()
        layout1.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        layout1.scrollDirection = .horizontal
        layout1.minimumLineSpacing = 20
        layout1.itemSize = CGSize(width: 35, height: 35)
        
        let layout2 = UICollectionViewFlowLayout()
        layout2.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        layout2.scrollDirection = .horizontal
        layout2.minimumLineSpacing = 20
        layout2.itemSize = CGSize(width: 240, height: 150)
        
        self.rewardCollectionView.setCollectionViewLayout(layout1, animated: true)
        
        self.rewardCollectionView.layer.cornerRadius = rewardCollectionView.frame.height/2.0
        self.rewardCollectionView.clipsToBounds = true
        self.rewardCollectionView.layer.borderColor = UIColor.lightGray.cgColor
        self.rewardCollectionView.layer.borderWidth = 1
        // 設置委任對象
        self.rewardCollectionView.delegate = self
        self.rewardCollectionView.dataSource = self
        
        self.classCollectionView.setCollectionViewLayout(layout2, animated: true)
        self.classCollectionView.backgroundColor = UIColor.white
        // 設置委任對象
        self.classCollectionView.delegate = self
        self.classCollectionView.dataSource = self
        
        
        // MARK: - Chart
        // simple arrays
        let data1: [CGFloat] = [1, 4, 5, 3, 4, 6]
        let data2: [CGFloat] = [1, 3, 3, 2, 4, 5]
        var views: [String: AnyObject] = [:]
        
        // simple line with custom x axis labels
        let xLabels: [String] = classNames
        let yLabels: [String] = ["0", "1", "2", "3", "4", "5", "6"]
        
        let lineChart = LineChart()
        lineChart.animation.enabled = true
        lineChart.area = true
        lineChart.x.labels.visible = true
        lineChart.x.grid.count = 5
        lineChart.y.grid.count = 5
        lineChart.x.labels.values = xLabels
        lineChart.y.labels.values = yLabels
        lineChart.y.labels.visible = false
        lineChart.addLine(data1)
        lineChart.addLine(data2)
        
        lineChart.translatesAutoresizingMaskIntoConstraints = false
        lineChart.delegate = self
        chartView.addSubview(lineChart)
        views["chart"] = lineChart
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-80-[chart]-|", options: [], metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[chart]-|", options: [], metrics: nil, views: views))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.rewardCollectionView {
            return 6
        } else {
            if section == 0 {
                return 3
            } else {
                return 1
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 依據前面註冊設置的識別名稱 "Cell" 取得目前使用的 cell
        if collectionView == self.rewardCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "rewardCell", for: indexPath as IndexPath) as! rewardCollectionViewCell
            
            cell.contentView.backgroundColor = UIColor.white
            
            // 設置 cell 內容 (即自定義元件裡 增加的圖片與文字元件)
            cell.rewardImg.image = UIImage(named: rewardImgs[indexPath.item])
            return cell
            
        } else {
            
            if indexPath.section == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "infoClassCell", for: indexPath as IndexPath) as! infoClassCollectionViewCell
                
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
                
                // 設置 cell 內容 (即自定義元件裡 增加的圖片與文字元件)
                cell.bgImg.image = UIImage(named: classImgs[indexPath.item])
                cell.bgImg.contentMode = .scaleAspectFill
                cell.bgImg.clipsToBounds = true
                cell.classType.text = classTypes[indexPath.item]
                cell.className.text = classNames[indexPath.item]
                cell.startBtn.layer.cornerRadius = cell.startBtn.frame.height/2.0
                cell.startBtn.clipsToBounds = true
                cell.recordBtn.layer.cornerRadius = cell.recordBtn.frame.height/2.0
                cell.recordBtn.clipsToBounds = true
                
                cell.startBtn.addTarget(self, action: #selector(infoViewController.startGame), for: UIControlEvents.touchUpInside)
                
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "moreClassCell2", for: indexPath as IndexPath) as! moreClassCollectionViewCell
                
                cell.contentView.backgroundColor = UIColor.lightGray
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
                
                cell.moreClassBtn.addTarget(self, action: #selector(infoViewController.checkMore), for: UIControlEvents.touchUpInside)
                
                return cell
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == self.rewardCollectionView {
            return 1
        } else {
            return 2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func didSelectDataPoint(_ x: CGFloat, yValues: Array<CGFloat>) {
        
    }
    
    func startGame() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "toGame")
        present(vc, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func assignTapped(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "assignClass")
        present(vc, animated: true, completion: nil)
    }
    
    func checkMore() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "toMoreClass") as! moreClassViewController
        vc.img = self.patientImg.image!
        vc.num = self.patientNum.text!
        vc.name = self.patientName.text!
        present(vc, animated: true, completion: nil)
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
