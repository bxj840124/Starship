//
//  gameDetailViewController.swift
//  Starship
//
//  Created by 楊喬宇 on 2017/9/16.
//  Copyright © 2017年 楊喬宇. All rights reserved.
//

import UIKit

class gameDetailViewController: UIViewController {

    @IBOutlet weak var stepNum: UILabel!
    @IBOutlet weak var stepName: UILabel!
    @IBOutlet weak var stepImg: UIImageView!
    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var bear: UIButton!
    
    var num = 0
    var name = ""
    var img = UIImage(named: "穿襪子01.jpg")
    
    var classes = ["認得正反左右", "找到洞", "捲到襪頭", "撐開", "放入", "拉高"]
    var userClasses = [classStep]()
    var isUserClasses = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gameDetailViewController.dismissTapped))
        self.view.addGestureRecognizer(tap)
        
        stepNum.text = String(num)
        stepName.text = name
        stepImg.image = img
        
        stepNum.layer.cornerRadius = stepNum.frame.width/2.0
        stepNum.clipsToBounds = true
        stepNum.layer.borderColor = UIColor(red: 0.9058, green: 0.9176, blue: 0.996, alpha: 1.0).cgColor
        stepNum.layer.borderWidth = 4.0
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        leftBtn.isHidden = false
        rightBtn.isHidden = false
        
        if num == 1 {
            leftBtn.isHidden = true
        }
        if isUserClasses {
            if num == userClasses.count {
                rightBtn.isHidden = true
            }
        } else {
            if num == 6 {
                rightBtn.isHidden = true
            }
        }
        
        self.showAnimate()
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

    @IBAction func leftButtonTapped(_ sender: Any) {
        if num == 2 {
            leftBtn.isHidden = true
        } else {
            leftBtn.isHidden = false
        }
        rightBtn.isHidden = false
        num -= 1
        stepNum.text = String(num)
        if isUserClasses {
            stepName.text = self.userClasses[num-1]["stepTitle"] as? String
        } else {
            stepName.text = classes[num-1]
        }
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        
        stepImg.layer.add(transition, forKey: nil)
        if isUserClasses {
            stepImg.image = UIImage(data: self.userClasses[num-1]["stepImg"] as! Data)
        } else {
            stepImg.image = UIImage(named: "穿襪子0\(num).jpg")
        }
    }
    
    @IBAction func rightBtnTapped(_ sender: Any) {
        if isUserClasses {
            if num == self.userClasses.count-1 {
                rightBtn.isHidden = true
            } else {
                rightBtn.isHidden = false
            }
        } else {
            if num == 5 {
                rightBtn.isHidden = true
            } else {
                rightBtn.isHidden = false
            }
        }
        
        leftBtn.isHidden = false
        num += 1
        stepNum.text = String(num)
        if isUserClasses {
            stepName.text = self.userClasses[num-1]["stepTitle"] as? String
        } else {
            stepName.text = classes[num-1]
        }
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        
        stepImg.layer.add(transition, forKey: nil)
        if isUserClasses {
            stepImg.image = UIImage(data: self.userClasses[num-1]["stepImg"] as! Data)
        } else {
            stepImg.image = UIImage(named: "穿襪子0\(num).jpg")
        }
    }
    
    @IBAction func bearTapped(_ sender: Any) {
        let popVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "highFive") as! highFiveViewController
        self.addChildViewController(popVC)
        popVC.view.frame = self.view.frame
        self.view.addSubview(popVC.view)
        popVC.didMove(toParentViewController: self)
    }
    
    func dismissTapped() {
        self.removeAnimate()
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
