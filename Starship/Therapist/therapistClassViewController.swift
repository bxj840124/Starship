//
//  therapistClassViewController.swift
//  Starship
//
//  Created by 楊喬宇 on 2017/9/9.
//  Copyright © 2017年 楊喬宇. All rights reserved.
//

import UIKit
import RealmSwift

class therapistClassViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var classCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedSegment = 0
    var classTitles = [[["上廁所", "洗臉", "刷牙", "更多生活技能"], ["拉拉鍊", "扣扣子", "穿鞋", "更多生活技能"], ["用湯匙", "喝水", "用筷子", "更多生活技能"]], [["串珠子", "夾夾子", "捏黏土", "更多動作訓練"], ["用湯匙", "拿水杯", "用筷子", "更多動作訓練"]], [["摺襪子", "上廁所"], ["拉拉鍊", "穿鞋", "用叉子"]]]
    var headerTitles = [["廁所", "玄關", "餐廳"], ["手部動作訓練一", "手部動作訓練二"], ["我的創建列表", "收藏一號"]]
    var userClasses = [classData]()
    var collectionClasses = [classData]()
    var longPressedCell = IndexPath()
    var collectionUUID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadDone), name: NSNotification.Name("LOAD_DONE"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadData), name: NSNotification.Name("CREATE_DONE"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.popoverAddToFavorite), name: NSNotification.Name("ADD_SELECTED"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.popoverEdit), name: NSNotification.Name("EDIT_SELECTED"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.popoverDelete), name: NSNotification.Name("DELETE_SELECTED"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.popoverRemove), name: NSNotification.Name("REMOVE_SELECTED"), object: nil)
        
        searchBar.searchBarStyle = .minimal
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressed(sender:)))
        self.classCollectionView.addGestureRecognizer(longPressRecognizer)
        
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
        
        self.loadData()
    }
    
    func loadData() {
        let realm = try! Realm()
        self.userClasses.removeAll()
        let classes = realm.objects(classData.self)
        if classes.count != 0 {
            for c in classes {
                self.userClasses.append(c)
            }
        }
        self.collectionClasses.removeAll()
        if let collection = realm.objects(collectionData.self).last {
            let array = Array(collection.classes)
            if array.count != 0 {
                for c in array {
                    if self.userClasses.contains(c) {
                        self.collectionClasses.append(c)
                    }
                }
            }
            self.collectionUUID = collection.uuid
            let newCollection = collectionData()
            newCollection.uuid = self.collectionUUID
            for c in self.collectionClasses {
                newCollection.classes.append(c)
            }
            try! realm.write {
                realm.add(newCollection, update: true)
            }
        }
        NotificationCenter.default.post(name: NSNotification.Name("LOAD_DONE"), object: nil)
    }
    
    func loadDone() {
        self.classCollectionView.reloadData()
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
                return self.userClasses.count
            } else {
                return self.collectionClasses.count
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 依據前面註冊設置的識別名稱 "Cell" 取得目前使用的 cell
        if selectedSegment == 2 && indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "classCell", for: indexPath as IndexPath) as! classCollectionViewCell
            
            cell.title.text = ""
            cell.bgImg.image = UIImage()
            
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
            
            let data = self.userClasses[indexPath.item]["coverImg"] as! Data?
            if let img = UIImage(data: data!) {
                cell.bgImg.image = img
            } else {
                cell.bgImg.image = UIImage()
                print("image is nil")
            }
            
            cell.title.text = self.userClasses[indexPath.item]["classTitle"] as? String
            cell.bgImg.contentMode = .scaleAspectFill
            cell.bgImg.clipsToBounds = true
            
            return cell
        } else if selectedSegment == 2 && indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "classCell", for: indexPath as IndexPath) as! classCollectionViewCell
            
            cell.title.text = ""
            cell.bgImg.image = UIImage()
            
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
            
            let data = self.collectionClasses[indexPath.item]["coverImg"] as! Data?
            if let img = UIImage(data: data!) {
                cell.bgImg.image = img
            } else {
                cell.bgImg.image = UIImage()
                print("image is nil")
            }
            
            cell.title.text = self.collectionClasses[indexPath.item]["classTitle"] as? String
            cell.bgImg.contentMode = .scaleAspectFill
            cell.bgImg.clipsToBounds = true
            
            return cell
        } else {
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
        if selectedSegment == 2 {
            if indexPath.section == 0 {
                reusableView.moon.image = UIImage(named: "moon.png")
            } else {
                reusableView.moon.image = UIImage(named: "collection.png")
            }
        }
        reusableView.title.text = headerTitles[selectedSegment][indexPath.section]
        
        return reusableView
    }
    
    @IBAction func createClassTapped(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "toCreateClass")
        self.present(vc, animated: true, completion: nil)
    }
    
    func editClass() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "toCreateClass") as! UINavigationController
        let editView = vc.viewControllers.first as! createClassViewController2
        editView.isEditClass = true
        let steps = Array(self.userClasses[longPressedCell.item]["classSteps"] as! List<classStep>) as [classStep]
        editView.oldTitle = (self.userClasses[longPressedCell.item]["classTitle"]! as? String)!
        editView.uuid = (self.userClasses[longPressedCell.item]["uuid"]! as? String)!
        editView.cellNum = steps.count
        for step in steps {
            editView.titleList.append(step["stepTitle"]! as! String)
            editView.descList.append(step["stepContent"]! as! String)
            editView.imgList.append(UIImage(data: step["stepImg"] as! Data)!)
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    func longPressed(sender: UILongPressGestureRecognizer) {
        
        let touchPoint = sender.location(in: self.classCollectionView)
        if selectedSegment == 2 {
            if let indexPath = self.classCollectionView.indexPathForItem(at: touchPoint) {
                if indexPath.section == 0 {
                    self.longPressedCell = indexPath
                    let popView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popEditView") as! popEditTableViewController
                    popView.modalPresentationStyle = .popover
                    popView.preferredContentSize = CGSize(width: 200, height: 132)
                    popView.classTitle = self.userClasses[indexPath.item]["classTitle"]! as! String
                    popView.type = 0
                    self.present(popView, animated: true, completion: nil)
                    let popover = popView.popoverPresentationController!
                    let cell = self.classCollectionView.cellForItem(at: indexPath) as! classCollectionViewCell
                    popover.delegate = self
                    popover.sourceView = cell
                    popover.sourceRect = CGRect(x: cell.bounds.minX-20, y: cell.bounds.minY+10, width: cell.bounds.width, height: cell.bounds.height)
                    popover.permittedArrowDirections = .left
                } else {
                    self.longPressedCell = indexPath
                    let popView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popEditView") as! popEditTableViewController
                    popView.modalPresentationStyle = .popover
                    popView.preferredContentSize = CGSize(width: 200, height: 88)
                    popView.classTitle = self.collectionClasses[indexPath.item]["classTitle"]! as! String
                    popView.type = 1
                    self.present(popView, animated: true, completion: nil)
                    let popover = popView.popoverPresentationController!
                    let cell = self.classCollectionView.cellForItem(at: indexPath) as! classCollectionViewCell
                    popover.delegate = self
                    popover.sourceView = cell
                    popover.sourceRect = CGRect(x: cell.bounds.minX-20, y: cell.bounds.minY+10, width: cell.bounds.width, height: cell.bounds.height)
                    popover.permittedArrowDirections = .left
                }
            }
        }
    }
    
    func popoverAddToFavorite() {
        self.presentedViewController?.dismiss(animated: true, completion: nil)
        let classTitle = self.userClasses[longPressedCell.item]["classTitle"] as! String
        for c in self.collectionClasses {
            let cTitle = c["classTitle"] as! String
            if cTitle == classTitle {
                let alertController = UIAlertController(
                    title: "提示",
                    message: "已加入的課程！",
                    preferredStyle: .alert)
                let okAction = UIAlertAction(title: "確認", style: .default, handler: {(action) -> Void in
                    return
                })
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                return
            }
        }
        let realm = try! Realm()
        let collection = collectionData()
        collection.uuid = self.collectionUUID
        self.collectionClasses.append(self.userClasses[longPressedCell.item])
        for c in self.collectionClasses {
            collection.classes.append(c)
        }
        try! realm.write {
            realm.add(collection, update: true)
        }
        print(realm.objects(collectionData.self))
        self.loadData()
    }
    
    func popoverEdit() {
        self.presentedViewController?.dismiss(animated: true, completion: nil)
        self.editClass()
    }
    
    func popoverDelete() {
        self.presentedViewController?.dismiss(animated: true, completion: nil)
        self.loadData()
    }
    
    func popoverRemove() {
        self.presentedViewController?.dismiss(animated: true, completion: nil)
        self.loadData()
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
