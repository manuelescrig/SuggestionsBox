//
//  ViewController.swift
//  Example
//
//  Created by Manuel Escrig Ventura on 12/05/16.
//  Copyright © 2016 Manuel Escrig Ventura. All rights reserved.
//

import UIKit
import SuggestionsBox

class ViewController: UIViewController {

    var label : UILabel = UILabel.init()
    var imageView : UIImageView = UIImageView.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("viewDidLoad")
        
        // Title
        self.title = "SuggestionsBox"
        
        // Label
        label.frame = CGRectMake(0, 0, 300, 300)
        label.numberOfLines = 0
        label.textAlignment = NSTextAlignment.Center
        label.textColor = UIColor.lightGrayColor()
        label.font = UIFont.systemFontOfSize(20)
        label.text = "SuggestionsBox helps your build better a product trough your user suggestions."
        self.view.addSubview(label)
        
        // Image
        imageView.frame = CGRectMake(0, 0, 100, 100)
        imageView.alpha = 0.5
        imageView.image = UIImage(named:"ImageGray")
        self.view.addSubview(imageView);
        
        // Bar buttons
        let questionIcon = UIBarButtonItem(image: UIImage(named:"IconQuestions"), style: .Plain, target: self, action: #selector(rightBarButtonItemClicked))
        self.navigationItem.setRightBarButtonItem(questionIcon, animated: true)
    }
    
    // MARK: StatusBar

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    
    // MARK: Layout Methods
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // Center Point
        let center = self.view.center
        self.label.center = CGPointMake(center.x, center.y + 60)
        self.imageView.center = CGPointMake(center.x, center.y - 70)
    }
    
    
    // MARK: UI Actions
    
    func rightBarButtonItemClicked(sender:UIBarButtonItem) {
        
        print("rightBarButtonItemClicked")
        
        let suggestionsBox = SuggestionsBox()
        SuggestionsBoxTheme.name = "SuggestionsBox"
        SuggestionsBoxTheme.headerText = "Suggest a new feature, tweak, improvement... We'd love to hear your sugestions!"
        SuggestionsBoxTheme.footerText = "Powered by SuggestionsBox"
        SuggestionsBoxTheme.newSuggestionFooterText = "Powered by SuggestionsBox"
        SuggestionsBoxTheme.newCommentFooterText = "Powered by SuggestionsBox"
        SuggestionsBoxTheme.navigationBarHeartColor = UIColor.redColor()
        SuggestionsBoxTheme.tableSeparatorColor = UIColor.groupTableViewBackgroundColor()
        SuggestionsBoxTheme.tableCellBackgroundColor = UIColor.whiteColor()
        SuggestionsBoxTheme.tableCellTitleTextColor = UIColor.blackColor()
        SuggestionsBoxTheme.tableCellDescriptionTextColor = UIColor.lightGrayColor()
        SuggestionsBoxConfig.author = "Manuel"
        SuggestionsBoxConfig.title = "SuggestionsBox"
        
        let navigationBar = UINavigationController.init(rootViewController: suggestionsBox)
        self.presentViewController(navigationBar, animated: true, completion: nil)
        
    }

}

