//
//  SettingsViewController.swift
//  SuggestionsBox
//
//  Created by Manuel Escrig Ventura on 11/05/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

public class SettingsViewController: UIViewController {

    override public func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()

        // Bar buttons
        let questionIcon = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(rightBarButtonItemClicked))
        self.navigationItem.setRightBarButtonItem(questionIcon, animated: true)
        
    }

 
    /// MARK:
    
    /**
     
     
     - parameter sender: UIBarButtonItem
     */
    func rightBarButtonItemClicked(sender:UIBarButtonItem) {
        
        self.dismissViewControllerAnimated(true) { }
    }
    
}
