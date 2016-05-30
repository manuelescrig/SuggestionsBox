//
//  ViewController.swift
//  Example
//
//  Created by Manuel Escrig Ventura on 12/05/16.
//  Copyright © 2016 Manuel Escrig Ventura. All rights reserved.
//

import UIKit
import SuggestionsBox

class ViewController: UIViewController, SuggestionsBoxDelegate {

    var label : UILabel = UILabel.init()
    var imageView : UIImageView = UIImageView.init()
    var featureRequests = [Suggestion]()
    var comments = [Comment]()

    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        self.getData()
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
        suggestionsBox.delegate = self
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
        
        
        print(self.featureRequests)

        let navigationBar = UINavigationController.init(rootViewController: suggestionsBox)
        self.presentViewController(navigationBar, animated: true, completion: nil)
        
    }

    // MARK : SuggestionsBoxDelegate Methods
    
    func suggestions() -> Array<Suggestion> {
        return self.featureRequests
    }
    
    func commentsForSuggestionAtIndex(suggestionIndex: Int) -> Array<Comment> {
        return self.comments
    }
    
    func newSuggestionAdded(newSuggestion: Suggestion) {
        self.featureRequests.append(newSuggestion)
    }
    
    func newCommentForSuggestionAdded(suggestion: Suggestion, newComment: Comment) {
        self.comments.append(newComment)
    }
    
    func suggestionFavoritedAtIndex(index: Int) {
        
    }
    
    func suggestionUnFavoritedAtIndex(index: Int) {
        
    }
    
    // MARK: Data
    
    func getData() {
        
        let suggestion1 = Suggestion.init(suggestionId: 1, title: "TitleTitle", description: "Description", author: "Manuel", favorites: 5, createdAt: NSDate())
        self.featureRequests.append(suggestion1)
        
        let suggestion2 = Suggestion.init(suggestionId: 2, title: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", author: "Manuel Escrig Ventura", favorites: 1, createdAt: NSDate())
        self.featureRequests.append(suggestion2)
        
        let suggestion3 = Suggestion.init(suggestionId: 3, title: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do", author: "Manuel Escrig Ventura", favorites: 1, createdAt: NSDate())
        self.featureRequests.append(suggestion3)
        
        let suggestion4 = Suggestion.init(suggestionId: 1, title: "Title", description: "Description", author: "Manuel", favorites: 5, createdAt: NSDate())
        self.featureRequests.append(suggestion4)
        
        let suggestion5 = Suggestion.init(suggestionId: 2, title: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", author: "Manuel Escrig Ventura", favorites: 1, createdAt: NSDate())
        self.featureRequests.append(suggestion5)
        
        let suggestion6 = Suggestion.init(suggestionId: 3, title: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", author: "Manuel Escrig Ventura", favorites: 1, createdAt: NSDate())
        self.featureRequests.append(suggestion6)
        
        let comment = Comment.init(commentId: 1, description: "Comment Description", author: "Manuel", createdAt: NSDate())
        self.comments.append(comment)
        self.comments.append(comment)
    }
}

