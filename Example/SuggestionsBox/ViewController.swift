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

    var label: UILabel = UILabel.init()
    var imageView: UIImageView = UIImageView.init()
    var featureRequests = [Suggestion]()
    var comments = [Comment]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Title
        self.title = "SuggestionsBox"

        // Label
        label.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        label.numberOfLines = 0
        label.textAlignment = NSTextAlignment.Center
        label.textColor = UIColor.lightGrayColor()
        label.font = UIFont.systemFontOfSize(20)
        label.text = "SuggestionsBox helps your build better a product trough your user suggestions."
        self.view.addSubview(label)

        // Image
        imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        imageView.alpha = 0.5
        imageView.image = UIImage(named:"ImageGray")
        self.view.addSubview(imageView)

        // Bar buttons
        let questionIcon = UIBarButtonItem(image: UIImage(named:"IconQuestions"), style: .Plain, target: self, action: #selector(rightBarButtonItemClicked))
        self.navigationItem.setRightBarButtonItem(questionIcon, animated: true)

        self.getDummyData()
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

    func rightBarButtonItemClicked(sender: UIBarButtonItem) {

        print("rightBarButtonItemClicked")

        let suggestionsBox = SuggestionsBox()
        suggestionsBox.delegate = self
        SuggestionsBoxTheme.user = "Manuel"
        SuggestionsBoxTheme.appName = "SuggestionsBox"
        SuggestionsBoxTheme.title = "SuggestionsBox"
        SuggestionsBoxTheme.headerText = "Suggest a new feature, tweak, improvement... We'd love to hear your sugestions!"
        SuggestionsBoxTheme.footerText = "Powered by SuggestionsBox"
        SuggestionsBoxTheme.newSuggestionFooterText = "Powered by SuggestionsBox"
        SuggestionsBoxTheme.newCommentFooterText = "Powered by SuggestionsBox"
        SuggestionsBoxTheme.navigationBarHeartColor = UIColor.redColor()
        SuggestionsBoxTheme.tableSeparatorColor = UIColor.groupTableViewBackgroundColor()
        SuggestionsBoxTheme.tableCellBackgroundColor = UIColor.whiteColor()
        SuggestionsBoxTheme.tableCellTitleTextColor = UIColor.blackColor()
        SuggestionsBoxTheme.tableCellDescriptionTextColor = UIColor.lightGrayColor()

        let navigationBar = UINavigationController.init(rootViewController: suggestionsBox)
        self.presentViewController(navigationBar, animated: true, completion: nil)

    }

    // MARK : SuggestionsBoxDelegate Methods

    func suggestions() -> Array<Suggestion> {
        return self.featureRequests
    }

    func commentsForSuggestion(suggestion: Suggestion) -> Array<Comment> {
        return self.comments.filter({ $0.suggestionId == suggestion.suggestionId })
    }

    func newSuggestionAdded(newSuggestion: Suggestion) {
        // Refresh online data
        self.featureRequests.append(newSuggestion)
    }

    func newCommentForSuggestionAdded(suggestion: Suggestion, newComment: Comment) {
        // Refresh online data
        self.comments.append(newComment)
    }

    func suggestionFavorited(suggestion: Suggestion) {
        // Refresh online data

        // Refresh local data
        let index = self.featureRequests.indexOf(suggestion)
        self.featureRequests[index!] = suggestion
    }

    func suggestionUnFavorited(suggestion: Suggestion) {
        // Refresh online data

        // Refresh local data
        let index = self.featureRequests.indexOf(suggestion)
        self.featureRequests[index!] = suggestion
    }

    // MARK: Data

    func getDummyData() {

        let suggestion1 = Suggestion.init(suggestionId: "1", title: "TitleTitle", description: "Description", user: "Manuel", favorites: ["4564"], createdAt: NSDate())
        self.featureRequests.append(suggestion1)

        let suggestion2 = Suggestion.init(suggestionId: "2", title: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", user: "Manuel Escrig Ventura", favorites: ["4564"], createdAt: NSDate())
        self.featureRequests.append(suggestion2)

        let suggestion3 = Suggestion.init(suggestionId: "3", title: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do", user: "Manuel Escrig Ventura", favorites: ["4564"], createdAt: NSDate())
        self.featureRequests.append(suggestion3)

        let suggestion4 = Suggestion.init(suggestionId: "4", title: "Title", description: "Description", user: "Manuel", favorites: ["4564"], createdAt: NSDate())
        self.featureRequests.append(suggestion4)

        let suggestion5 = Suggestion.init(suggestionId: "5", title: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", user: "Manuel Escrig Ventura", favorites: ["4564"], createdAt: NSDate())
        self.featureRequests.append(suggestion5)

        let suggestion6 = Suggestion.init(suggestionId: "6", title: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", user: "Manuel Escrig Ventura", favorites: ["4564"], createdAt: NSDate())
        self.featureRequests.append(suggestion6)

        let comment1 = Comment.init(suggestionId: "1", commentId: "1", description: "Comment Description", user: "Manuel", createdAt: NSDate())
        self.comments.append(comment1)

        let comment2 = Comment.init(suggestionId: "2", commentId: "2", description: "Comment Description", user: "Manuel", createdAt: NSDate())
        self.comments.append(comment2)

        let comment3 = Comment.init(suggestionId: "2", commentId: "3", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", user: "Manuel", createdAt: NSDate())
        self.comments.append(comment3)
        
        let comment4 = Comment.init(suggestionId: "3", commentId: "4", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", user: "Manuel", createdAt: NSDate())
        self.comments.append(comment4)
        
        let comment5 = Comment.init(suggestionId: "4", commentId: "5", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", user: "Manuel", createdAt: NSDate())
        self.comments.append(comment5)
        
        let comment6 = Comment.init(suggestionId: "5", commentId: "6", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", user: "Manuel", createdAt: NSDate())
        self.comments.append(comment6)
        
        let comment7 = Comment.init(suggestionId: "6", commentId: "7", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", user: "Manuel", createdAt: NSDate())
        self.comments.append(comment7)
    }
}
