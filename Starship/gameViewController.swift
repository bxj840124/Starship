//
//  gameViewController.swift
//  Starship
//
//  Created by 楊喬宇 on 2017/9/15.
//  Copyright © 2017年 楊喬宇. All rights reserved.
//

import UIKit

class gameViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var gameSegment: UISegmentedControl!
    @IBOutlet weak var gameCollectionView: UICollectionView!
    @IBOutlet weak var bottomBar: UIImageView!
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var assistPicker: UIPickerView!
    @IBOutlet weak var pickerBottom: NSLayoutConstraint!
    @IBOutlet weak var labelBottom: NSLayoutConstraint!
    @IBOutlet weak var barBottom: NSLayoutConstraint!
    @IBOutlet weak var btnBottom: NSLayoutConstraint!
    
    var classes = ["打開水龍頭", "沖濕雙手", "抹肥皂", "仔細搓揉雙手", "沖洗泡沫", "關起水龍頭", "擦乾雙手"]
    var descs = ["向上扳起或逆時針方向轉開水龍頭。", "將雙手用水徹底沖濕。", "抹上肥皂或擠一點洗手乳，並搓揉雙手讓它起泡。", "將雙手的每根手指、手心、手背、指尖、指縫等都搓洗乾淨，這個動作要持續至少20秒喔！", "再次打開水龍頭，將雙手上的泡沫清洗乾淨。", "清洗完畢後，用一點水沖掉水龍頭上的殘留泡沫，再把水龍頭關上，記得要關緊！", "用乾淨的毛巾擦拭雙手，你就學會洗手了！"]
    var assistArray = ["完全肢體協助", "部分肢體協助", "示範協助", "口語提示", "手勢提示", "獨立操作"]
    var assistTitle = ["部分肢體協助", "部分肢體協助", "部分肢體協助", "部分肢體協助", "部分肢體協助", "部分肢體協助", "部分肢體協助"]
    
    var isSortViewVisible = false
    var isGuideVisible = false
    var selectNum = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gameViewController.doneClicked))
        self.view.addGestureRecognizer(tap)
        
        gameSegment.selectedSegmentIndex = 1
        
        pickerBottom.constant = -175
        recordBtn.layer.cornerRadius = recordBtn.frame.width/2.0
        recordBtn.clipsToBounds = true
        
        // 建立 UICollectionViewFlowLayout
        let layout = UICollectionViewFlowLayout()
        
        // 設置 section 的間距 四個數值分別代表 上、左、下、右 的間距
        layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        layout.scrollDirection = .horizontal
        
        // 設置每一行的間距
        layout.minimumLineSpacing = 20
        
        // 設置每個 cell 的尺寸
        layout.itemSize = CGSize(width: 246, height: 405)
        
        gameCollectionView.setCollectionViewLayout(layout, animated: true)
        
        // 設置委任對象
        gameCollectionView.delegate = self
        gameCollectionView.dataSource = self
        
        assistPicker.backgroundColor = UIColor.lightGray
        
        assistPicker.showsSelectionIndicator = true
        assistPicker.delegate = self
        assistPicker.dataSource = self
        
        if !isGuideVisible {
            self.runGuide()
        }
    }
    
    func runGuide() {
        isGuideVisible = true
        let popVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "guide") as! guideViewController
        self.addChildViewController(popVC)
        popVC.view.frame = self.view.frame
        self.view.addSubview(popVC.view)
        popVC.didMove(toParentViewController: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 依據前面註冊設置的識別名稱 "Cell" 取得目前使用的 cell
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
        
        cell.stepImg.image = UIImage(named: "洗手0\(indexPath.item+1)")
        cell.stepImg.contentMode = .scaleAspectFill
        cell.stepImg.clipsToBounds = true
            
        let borderColor = UIColor(red: 0.9058, green: 0.9176, blue: 0.996, alpha: 1.0).cgColor
        cell.stepNum.layer.cornerRadius = cell.stepNum.frame.width/2.0
        cell.stepNum.clipsToBounds = true
        cell.stepNum.layer.borderColor = borderColor
        cell.stepNum.layer.borderWidth = 4.0
        cell.stepNum.text = "\(indexPath.item+1)"
            
        cell.stepName.text = classes[indexPath.item]
        cell.stepDesc.text = descs[indexPath.item]
        
        cell.assistBtn.layer.borderColor = UIColor.lightGray.cgColor
        cell.assistBtn.setTitle(assistTitle[indexPath.item], for: .normal)
        cell.assistBtn.layer.borderWidth = 1
        cell.assistBtn.tag = indexPath.item
        cell.assistBtn.addTarget(self, action: #selector(gameViewController.showPicker(sender:)), for: UIControlEvents.touchUpInside)
            
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let popVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "gameDetail") as! gameDetailViewController
        popVC.num = indexPath.item+1
        popVC.name = classes[indexPath.item]
        popVC.img = UIImage(named: "洗手0\(indexPath.item+1).jpg")
        self.addChildViewController(popVC)
        popVC.view.frame = self.view.frame
        popVC.view.tag = 100
        self.view.addSubview(popVC.view)
        popVC.didMove(toParentViewController: self)
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func showPicker(sender: UIButton) {
        selectNum = sender.tag
        
        pickerBottom.constant = 0
        labelBottom.constant = 183
        barBottom.constant = 175
        btnBottom.constant = 175
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
        
        self.isSortViewVisible = true
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return assistArray.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return assistArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.assistTitle[selectNum] = self.assistArray[row]
        gameCollectionView.reloadItems(at: [[0, selectNum]])
    }
    
    @IBAction func recordTapped(_ sender: Any) {
        if (UIImagePickerController.availableMediaTypes(for: UIImagePickerControllerSourceType.camera) != nil) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
    }
    
    func doneClicked() {
        if isSortViewVisible {
            pickerBottom.constant = -175
            labelBottom.constant = 8
            barBottom.constant = 0
            btnBottom.constant = 0
            isSortViewVisible = false
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @IBAction func finishTapped(_ sender: Any) {
        for view in self.view.subviews {
            if view.tag == 100 {
                view.removeFromSuperview()
            }
        }
        let popVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "endGame") as! endGameViewController
        self.addChildViewController(popVC)
        popVC.view.frame = self.view.frame
        self.view.addSubview(popVC.view)
        popVC.didMove(toParentViewController: self)
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
