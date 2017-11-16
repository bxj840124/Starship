//
//  carouselViewController.swift
//  Starship
//
//  Created by 楊喬宇 on 2017/11/15.
//  Copyright © 2017年 楊喬宇. All rights reserved.
//

import UIKit
import iCarousel

class carouselViewController: UIViewController, iCarouselDataSource, iCarouselDelegate {
    @IBOutlet weak var carousel: iCarousel!
    @IBOutlet weak var bear: UIButton!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var finishBtn: UIButton!
    
    var isUserClasses = false
    var userClasses = [classStep]()
    var classes = ["認得正反左右", "找到洞", "捲到襪頭", "撐開", "放入", "拉高"]
    var descs = ["將兩隻襪子擺正，並找出左腳與右腳。", "選一隻襪子，找到襪子的開口處。", "用雙手把襪子的開口處捲到襪頭，並抓住開口處與襪頭。", "輕輕撐開襪子的開口處，讓腳容易放入", "把對應的左右腳伸進襪子裡。", "最後再把襪子開口處沿著腳往上拉到腳踝的地方，就穿好一隻襪子了！另外一隻腳也是一樣喔！"]
    
    @IBOutlet weak var eval1: UITextView!
    @IBOutlet weak var eval2: UITextView!
    @IBOutlet weak var eval3: UITextView!
    @IBOutlet weak var eval4: UITextView!
    @IBOutlet weak var eval5: UITextView!
    @IBOutlet weak var eval6: UITextView!
    
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn4: UIButton!
    @IBOutlet weak var btn5: UIButton!
    @IBOutlet weak var btn6: UIButton!
    
    var evaluation = [Int]()
    var evals = [UITextView]()
    var btns = [UIButton]()
    var focusStep = 0
    var videoUrl = NSURL()
    
    let unselectedColor = UIColor(red: 212.0/255, green: 213.0/255, blue: 215.0/255, alpha: 1.0)
    let selectedColor = UIColor(red: 255.0/255, green: 120.0/255, blue: 171.0/255, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        carousel.type = .rotary
        carousel.bounces = true
        
        evals = [eval1, eval2, eval3, eval4, eval5, eval6]
        btns = [btn1, btn2, btn3, btn4, btn5, btn6]
        
        for eval in evals {
            eval.textColor = unselectedColor
        }
        
        for btn in btns {
            btn.layer.cornerRadius = 10
            btn.layer.borderColor = unselectedColor.cgColor
            btn.layer.borderWidth = 2.0
            btn.clipsToBounds = true
        }
        
        if isUserClasses {
            for _ in 0...(userClasses.count-1) {
                evaluation.append(-1)
            }
        } else {
            for _ in 0...(classes.count-1) {
                evaluation.append(-1)
            }
        }
        
        finishBtn.layer.cornerRadius = finishBtn.frame.height/2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        if isUserClasses {
            return userClasses.count
        } else {
            return classes.count
        }
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        var background: UIView
        var label: UILabel
        var content: UITextView
        var itemView: UIImageView
        
        //reuse view if available, otherwise create a new view
        if let view = view as? UIImageView {
            itemView = view
            //get a reference to the label in the recycled view
            background = itemView.viewWithTag(1)!
            label = itemView.viewWithTag(2) as! UILabel
            content = itemView.viewWithTag(3) as! UITextView
        } else {
            //don't do anything specific to the index within
            //this `if ... else` statement because the view will be
            //recycled and used with other index values later
            itemView = UIImageView(frame: CGRect(x: 0, y: 0, width: 600, height: 500))
            if isUserClasses {
                itemView.image = UIImage(data: self.userClasses[index]["stepImg"] as! Data)
                itemView.contentMode = .scaleAspectFill
                itemView.clipsToBounds = true
                
                background = UIView(frame: CGRect(x: 0, y: 350, width: itemView.frame.width, height: itemView.frame.height/3))
                background.backgroundColor = UIColor.black.withAlphaComponent(0.3)
                background.tag = 1
                itemView.addSubview(background)
                
                label = UILabel(frame: CGRect(x: 20, y: 350, width: itemView.frame.width-20, height: itemView.frame.height/9))
                label.backgroundColor = UIColor.clear
                label.text = self.userClasses[index]["stepTitle"] as? String
                label.textAlignment = .left
                label.font = UIFont.boldSystemFont(ofSize: 20)
                label.textColor = UIColor.white
                label.tag = 2
                itemView.addSubview(label)
                
                content = UITextView(frame: CGRect(x: 20, y: 350 + itemView.frame.height/9, width: itemView.frame.width-20, height: itemView.frame.height*2/9))
                content.backgroundColor = UIColor.clear
                content.text = self.userClasses[index]["stepContent"] as? String
                content.font = UIFont.systemFont(ofSize: 17)
                content.textColor = UIColor.white
                content.isEditable = false
                content.isScrollEnabled = false
                content.tag = 3
                itemView.addSubview(content)
            } else {
                itemView.image = UIImage(named: "穿襪子0\(index+1).jpg")
                itemView.contentMode = .scaleAspectFill
                itemView.clipsToBounds = true
                
                background = UIView(frame: CGRect(x: 0, y: 350, width: itemView.frame.width, height: itemView.frame.height/3))
                background.backgroundColor = UIColor.black.withAlphaComponent(0.3)
                background.tag = 1
                itemView.addSubview(background)
                
                label = UILabel(frame: CGRect(x: 20, y: 350, width: itemView.frame.width-20, height: itemView.frame.height/9))
                label.backgroundColor = UIColor.clear
                label.text = classes[index]
                label.textAlignment = .left
                label.font = UIFont.boldSystemFont(ofSize: 20)
                label.textColor = UIColor.white
                label.tag = 2
                itemView.addSubview(label)
                
                content = UITextView(frame: CGRect(x: 20, y: 350 + itemView.frame.height/9, width: itemView.frame.width-20, height: itemView.frame.height*2/9))
                content.backgroundColor = UIColor.clear
                content.text = descs[index]
                content.font = UIFont.systemFont(ofSize: 17)
                content.textColor = UIColor.white
                content.isEditable = false
                content.isScrollEnabled = false
                content.tag = 3
                itemView.addSubview(content)
            }
        }
        
        //set item label
        //remember to always set any properties of your carousel item
        //views outside of the `if (view == nil) {...}` check otherwise
        //you'll get weird issues with carousel item content appearing
        //in the wrong place in the carousel
        
        return itemView
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        switch option {
        case .spacing:
            return value * 1.1
        case .wrap:
            return 0
        case .fadeMin:
            return 0
        case .fadeMax:
            return 1
        case .fadeRange:
            return 3
        default:
            return value
        }
    }
    
    func carouselDidEndScrollingAnimation(_ carousel: iCarousel) {
        focusStep = carousel.currentItemIndex
        for i in 0...5 {
            evals[i].textColor = unselectedColor
            btns[i].layer.borderColor = unselectedColor.cgColor
        }
        if evaluation[focusStep] != -1 {
            btns[evaluation[focusStep]].layer.borderColor = selectedColor.cgColor
            evals[evaluation[focusStep]].textColor = UIColor.white
        }
    }
    
    @IBAction func bearTapped(_ sender: Any) {
        let popVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "highFive") as! highFiveViewController
        self.addChildViewController(popVC)
        popVC.view.frame = self.view.frame
        self.view.addSubview(popVC.view)
        popVC.didMove(toParentViewController: self)
    }
    
    @IBAction func btn1Tapped(_ sender: Any) {
        for i in 0...5 {
            evals[i].textColor = unselectedColor
            btns[i].layer.borderColor = unselectedColor.cgColor
        }
        evaluation[focusStep] = 0
        btn1.layer.borderColor = selectedColor.cgColor
        eval1.textColor = UIColor.white
    }
    @IBAction func btn2Tapped(_ sender: Any) {
        for i in 0...5 {
            evals[i].textColor = unselectedColor
            btns[i].layer.borderColor = unselectedColor.cgColor
        }
        evaluation[focusStep] = 1
        btn2.layer.borderColor = selectedColor.cgColor
        eval2.textColor = UIColor.white
    }
    @IBAction func btn3Tapped(_ sender: Any) {
        for i in 0...5 {
            evals[i].textColor = unselectedColor
            btns[i].layer.borderColor = unselectedColor.cgColor
        }
        evaluation[focusStep] = 2
        btn3.layer.borderColor = selectedColor.cgColor
        eval3.textColor = UIColor.white
    }
    @IBAction func btn4Tapped(_ sender: Any) {
        for i in 0...5 {
            evals[i].textColor = unselectedColor
            btns[i].layer.borderColor = unselectedColor.cgColor
        }
        evaluation[focusStep] = 3
        btn4.layer.borderColor = selectedColor.cgColor
        eval4.textColor = UIColor.white
    }
    @IBAction func btn5Tapped(_ sender: Any) {
        for i in 0...5 {
            evals[i].textColor = unselectedColor
            btns[i].layer.borderColor = unselectedColor.cgColor
        }
        evaluation[focusStep] = 4
        btn5.layer.borderColor = selectedColor.cgColor
        eval5.textColor = UIColor.white
    }
    @IBAction func btn6Tapped(_ sender: Any) {
        for i in 0...5 {
            evals[i].textColor = unselectedColor
            btns[i].layer.borderColor = unselectedColor.cgColor
        }
        evaluation[focusStep] = 5
        btn6.layer.borderColor = selectedColor.cgColor
        eval6.textColor = UIColor.white
    }
    
    @IBAction func closeTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAnimate2" {
            if let vc = segue.destination as? animate2ViewController {
                vc.isUserClasses = self.isUserClasses
                vc.userClasses = self.userClasses
                vc.evaluation = self.evaluation
                vc.videoUrl = self.videoUrl
            }
        }
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
