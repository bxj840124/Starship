//
//  guideViewController.swift
//  Starship
//
//  Created by 楊喬宇 on 2017/9/16.
//  Copyright © 2017年 楊喬宇. All rights reserved.
//

import UIKit

class guideViewController: UIViewController {
    @IBOutlet weak var bearImg: UIImageView!
    @IBOutlet weak var guideTxt: UITextView!
    @IBOutlet weak var rocketImg: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(guideViewController.dismissBear))
        self.view.addGestureRecognizer(tap)
        
        guideTxt.centerVertically()
        guideTxt.backgroundColor = UIColor.white
        guideTxt.layer.borderWidth = 4.0
        guideTxt.layer.borderColor = UIColor(red: 1.0, green: 0.4784, blue: 0.6705, alpha: 1.0).cgColor
        guideTxt.layer.cornerRadius = 10
        guideTxt.clipsToBounds = true
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
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
                self.view.superview?.gestureRecognizers?.removeAll()
                self.view.removeFromSuperview()
            }
        }
    }
    
    func dismissBear() {
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

extension UITextView {
    
    func centerVertically() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }
    
}

