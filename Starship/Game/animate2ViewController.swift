//
//  animate2ViewController.swift
//  Starship
//
//  Created by 楊喬宇 on 2017/11/16.
//  Copyright © 2017年 楊喬宇. All rights reserved.
//

import UIKit
import SwiftyGif

class animate2ViewController: UIViewController, SwiftyGifDelegate {
    @IBOutlet weak var animateGif: UIImageView!
    @IBOutlet weak var nextBtn: UIButton!
    
    var isUserClasses = false
    var userClasses = [classStep]()
    var evaluation = [Int]()
    var videoUrl = NSURL()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.nextBtn.isHidden = true
        let img = UIImage(named: "rightBtn.png")
        let tintedImg = img?.withRenderingMode(.alwaysTemplate)
        self.nextBtn.setImage(tintedImg, for: .normal)
        self.nextBtn.tintColor = UIColor.darkGray
        let gifManager = SwiftyGifManager(memoryLimit:20)
        let gif = UIImage(gifName: "動畫2.gif")
        self.animateGif.setGifImage(gif, manager: gifManager, loopCount: 1)
        
        self.animateGif.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gifDidStart(sender: UIImageView) {
        print("gifDidStart")
    }
    
    func gifDidLoop(sender: UIImageView) {
        print("gifDidLoop")
        self.nextBtn.isHidden = false
    }
    
    func gifDidStop(sender: UIImageView) {
        print("gifDidStop")
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRecord" {
            if let vc = segue.destination as? recordViewController {
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
