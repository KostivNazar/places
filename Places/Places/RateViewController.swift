//
//  RateViewController.swift
//  Places
//
//  Created by Mac on 31.07.17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class RateViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    
    var rating: String?
    
    @IBOutlet weak var stack: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let scale = CGAffineTransform(scaleX: 0.0, y: 0.0)
        let translation = CGAffineTransform(translationX: 0, y: 500)
        
        stack.transform = scale.concatenating(translation)
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        
        backgroundImageView.addSubview(blurEffectView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 1.0, delay: 0, options: [], animations: {
            self.stack.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    @IBAction func rateSelect(_ sender: UIButton) {
        switch sender.tag {
        case 1: rating = "dislike"
        case 2: rating = "good"
        case 3: rating = "great"
        default: break
        }
        performSegue(withIdentifier: "unwindToDetail", sender: sender)
    }
    
}
