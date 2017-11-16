//
//  stickerViewController.swift
//  Starship
//
//  Created by 楊喬宇 on 2017/11/14.
//  Copyright © 2017年 楊喬宇. All rights reserved.
//

import UIKit

class stickerViewController: UIViewController {
    
    @IBOutlet weak var popView: UIView!
    @IBOutlet weak var stepImg: UIImageView!
    @IBOutlet weak var stepTitle: UILabel!
    @IBOutlet weak var stepDesc: UITextView!
    
    var isUserClasses = false
    var classes = ["認得正反左右", "找到洞", "捲到襪頭", "撐開", "放入", "拉高"]
    var descs = ["將兩隻襪子擺正，並找出左腳與右腳。", "選一隻襪子，找到襪子的開口處。", "用雙手把襪子的開口處捲到襪頭，並抓住開口處與襪頭。", "輕輕撐開襪子的開口處，讓腳容易放入", "把對應的左右腳伸進襪子裡。", "最後再把襪子開口處沿著腳往上拉到腳踝的地方，就穿好一隻襪子了！另外一隻腳也是一樣喔！"]
    var userClasses = [classStep]()
    var num = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.closePop(_:)))
        self.view.addGestureRecognizer(tap)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        self.popView.layer.cornerRadius = 10
        self.popView.clipsToBounds = true
        
        if isUserClasses {
            self.stepImg.image = UIImage(data: self.userClasses[num]["stepImg"] as! Data)
            self.stepImg.contentMode = .scaleAspectFill
            self.stepImg.clipsToBounds = true
            
            self.stepTitle.text = self.userClasses[num]["stepTitle"] as? String
            self.stepDesc.text = self.userClasses[num]["stepContent"] as? String
        } else {
            self.stepImg.image = UIImage(named: "穿襪子0\(num+1).jpg")
            self.stepImg.contentMode = .scaleAspectFill
            self.stepImg.clipsToBounds = true
            
            self.stepTitle.text = self.classes[num]
            self.stepDesc.text = self.descs[num]
        }
        
        self.showAnimate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAnimate() {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25) {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    func removeAnimate() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0
        }) { (finished) in
            if (finished) {
                self.view.removeFromSuperview()
            }
        }
    }
    
    func closePop(_ sender: Any) {
        self.removeAnimate()
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
