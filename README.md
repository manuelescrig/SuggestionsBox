<p align="center"><img src="https://cloud.githubusercontent.com/assets/1849990/15174018/cfd2f16c-175f-11e6-9a15-4708166834db.png"></p>

# SuggestionsBox
[![Build Status](https://travis-ci.org/manuelescrig/SuggestionsBox.svg?branch=master)](https://travis-ci.org/manuelescrig/SuggestionsBox)
[![Version](https://img.shields.io/cocoapods/v/SuggestionsBox.svg?style=flat)](http://cocoapods.org/pods/SuggestionsBox)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/SuggestionsBox.svg?style=flat)](http://cocoapods.org/pods/SuggestionsBox)
[![Platform](https://img.shields.io/cocoapods/p/SuggestionsBox.svg?style=flat)](http://cocoapods.org/pods/SuggestionsBox)
[![Language](https://img.shields.io/badge/language-swift-oragne.svg?style=flat)](https://developer.apple.com/swift)

An **iOS library** to aggregate **users feedback** about suggestions, features or comments in order to help you build a **better product**. 

#### Swift Versions
- [Version 1.5 is compatible with Swift 3](https://github.com/manuelescrig/SuggestionsBox/releases/tag/1.5)
- [Version 1.2.6 is compatible Swift 2.2](https://github.com/manuelescrig/SuggestionsBox/releases/tag/1.2.6)

## Why SuggestionsBox?
- [x] Aggregates customer feedback
- [x] Let your customer decide 
- [x] Build the most voted suggestion
- [x] Build a better product

## Features
- [x] List and add new suggestions
- [x] Comment and vote other suggestions
- [x] Search inside Titles and Descriptions
- [x] Customizable colors and strings
- [x] Localizable

<p align="center"><img src="https://cloud.githubusercontent.com/assets/1849990/15703910/2b646d9c-27e8-11e6-889c-0eee15ede7e3.jpg"></p>

## Demo App

Run the demo app and play with it!
[Demo App](https://appetize.io/app/6e14g9b61qd10dh4jq698vz44m?device=iphone6splus&scale=50&orientation=portrait&osVersion=9.3&deviceColor=white)

## Demo Project

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Getting Started

### Requirements

Requires iOS SDK version > 8.0

Requires Swift 3.0

### Installation with CocoaPods

[CocoaPods](cocoapods.org) is a 3rd-party dependency manager for Swift and Objective-C projects. For more information, refer to the [CocoaPods Getting Started Guide](https://guides.cocoapods.org/using/getting-started.html). Otherwise, you can install CocoaPods with the following command:

```bash
$ gem install cocoapods
```

#### Podfile
To integrate MEVHorizontalContacts into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
pod 'SuggestionsBox'
```

Then, run the following command:

```bash
$ pod install
```

###  Installation Manually
To integrate SuggestionsBox into your Xcode project manually, just include the filest from [/Pod/Classes/](https://github.com/manuelescrig/MEVHorizontalContacts/tree/master/SuggestionsBox/Classes) folder in your App’s Xcode project.

Then, import the following file your classes:
```swift
import SuggestionsBox
```

## Quick Guide

### Usage

###### 1. Import class

```swift
import SuggestionsBox
```

###### 2. Add Delegate protocol.

```swift
class ViewController: UIViewController, SuggestionsBoxDelegate {
}
```

###### 3. Create, initialize and add SuggestionsBox.

```swift
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

```

###### 4. Implement Delegate Methods

```swift
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

```

## Roadmap
- [x] CocoaPods support
- [x] Carthage support
- [ ] Tests


## Apps using this library

- [People Tracker App](http://itunes.apple.com/us/app/people-tracker-pro/id539205975?ls=1&mt=8), [www.peopletrackerapp.com](http://www.peopletrackerapp.com)


## Author

- Created and maintained by Manuel Escrig Ventura, [@manuelescrig](https://www.twitter.com/manuelescrig/)
- Email [manuel@ventura.media](mailto:manuel@ventura.media)
- Portfolio [http://ventura.media](http://ventura.media)

## License

SuggestionsBox is available under the MIT license. See the [LICENSE.md](https://github.com/manuelescrig/SuggestionsBox/blob/master/LICENSE.md) file for more info.
