//
//  ViewController.swift
//  SuggestionsBox
//
//  Created by Manuel Escrig Ventura on 04/29/2016.
//  Copyright (c) 2016 Manuel Escrig Ventura. All rights reserved.
//

import UIKit
import SuggestionsBox

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Title
        self.title = "SuggestionsBox"
        
        // Center Point
        let center = self.view.center

        // Label
        let label = UILabel(frame: CGRectMake(0, 0, 300, 300))
        label.center = CGPointMake(center.x, center.y + 60)
        label.numberOfLines = 0
        label.textAlignment = NSTextAlignment.Center
        label.textColor = UIColor.lightGrayColor()
        label.font = UIFont.systemFontOfSize(20)
        label.text = "SuggestionsBox helps your build better a product trough your user suggestions."
        self.view.addSubview(label)
   
        // Image
        let imageView = UIImageView(frame: CGRectMake(0, 0, 100, 100))
        imageView.alpha = 0.5
        imageView.image = UIImage(named:"ImageGray")
        imageView.center = CGPointMake(center.x, center.y - 70)
        self.view.addSubview(imageView);
        
        // Bar buttons
        let questionIcon = UIBarButtonItem(image: UIImage(named:"IconQuestions"), style: .Plain, target: self, action: #selector(rightBarButtonItemClicked))
        self.navigationItem.setRightBarButtonItem(questionIcon, animated: true)
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    
    /// MARK:
    
    func rightBarButtonItemClicked(sender:UIBarButtonItem) {
        
        let suggestionsBox = SuggestionsBox()
        let navigationController = UINavigationController(rootViewController: suggestionsBox)
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    

    func leftBarButtonItemClicked(sender:UIBarButtonItem) {
        
        
//        let settingsViewController = SettingsViewController()
//        settingsViewController.modalTransitionStyle = .FlipHorizontal
//        let navigationController = UINavigationController(rootViewController: settingsViewController)
//        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
}

