//
//  popEditTableViewController.swift
//  Starship
//
//  Created by 楊喬宇 on 2017/10/24.
//  Copyright © 2017年 楊喬宇. All rights reserved.
//

import UIKit
import RealmSwift

class popEditTableViewController: UITableViewController {
    @IBOutlet var popEditTableView: UITableView!
    
    var editTitle = ["加入我的收藏", "編輯", "刪除項目"]
    var editTitle2 = ["編輯", "從我的收藏移除"]
    var classTitle = ""
    var type = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        let cell = UINib.init(nibName: "EditCell", bundle: nil)
        self.tableView.register(cell, forCellReuseIdentifier: "editCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if self.type == 0 {
            return self.editTitle.count
        } else {
            return self.editTitle2.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.type == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "editCell", for: indexPath) as! popEditTableViewCell
            
            // Configure the cell...
            cell.editTitle.text = self.editTitle[indexPath.item]
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "editCell", for: indexPath) as! popEditTableViewCell
            
            // Configure the cell...
            cell.editTitle.text = self.editTitle2[indexPath.item]
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.type == 0 {
            switch indexPath.item {
            case 0:
                NotificationCenter.default.post(name: NSNotification.Name("ADD_SELECTED"), object: nil)
            case 1:
                NotificationCenter.default.post(name: NSNotification.Name("EDIT_SELECTED"), object: nil)
            case 2:
                let alertController = UIAlertController(
                    title: "提示",
                    message: "確定要刪除課程嗎？",
                    preferredStyle: .alert)
                let okAction = UIAlertAction(title: "確認", style: .default, handler: {(action) -> Void in
                    let realm = try! Realm()
                    let predicate = NSPredicate(format: "classTitle == '\(self.classTitle)'")
                    let cls = realm.objects(classData.self).filter(predicate)
                    try! realm.write {
                        realm.delete(cls)
                    }
                    NotificationCenter.default.post(name: NSNotification.Name("DELETE_SELECTED"), object: nil)
                })
                let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: {(action) -> Void in
                    NotificationCenter.default.post(name: NSNotification.Name("DELETE_SELECTED"), object: nil)
                })
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            default:
                return
            }
        } else {
            switch indexPath.item {
            case 0:
                NotificationCenter.default.post(name: NSNotification.Name("EDIT_SELECTED"), object: nil)
            case 1:
                let realm = try! Realm()
                let cls = realm.objects(collectionData.self).last!
                let predicate = NSPredicate(format: "classTitle == '\(self.classTitle)'")
                if let c = cls.classes.filter(predicate).first {
                    try! realm.write {
                        let id = cls.classes.index(of: c)
                        cls.classes.remove(objectAtIndex: id!)
                        realm.add(cls, update: true)
                    }
                }
                NotificationCenter.default.post(name: NSNotification.Name("REMOVE_SELECTED"), object: nil)
            default:
                return
            }
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
