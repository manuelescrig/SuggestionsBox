//
//  NewSuggestionController.swift
//  SuggestionsBox
//  An iOS library to aggregate users feedback about suggestions,
//  features or comments in order to help you build a better product.
//
//  https://github.com/manuelescrig/SuggestionsBox
//
//  Created by Manuel Escrig Ventura on 30/04/16.
//  Licence: MIT-Licence


// MARK: TextViewCell
protocol TextViewCellDelegate: class {
    func textDidChange(sender: TextViewCell)
}

class TextViewCell: UITableViewCell, UITextViewDelegate {

    var textView = UITextView()
    var constraintsList = [NSLayoutConstraint]()
    weak var parentTableView: UITableView?
    weak var delegate: TextViewCellDelegate?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Value1, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = SuggestionsBoxTheme.tableCellBackgroundColor
        self.contentView.backgroundColor = SuggestionsBoxTheme.tableCellBackgroundColor

        self.textLabel?.textColor = SuggestionsBoxTheme.tableCellTitleTextColor
        self.detailTextLabel?.textColor = SuggestionsBoxTheme.tableCellDescriptionTextColor

        textView.contentInset = UIEdgeInsetsMake(0, -3, 0, 0)
        textView.delegate = self
        textView.backgroundColor = UIColor.clearColor()
        textView.textColor = SuggestionsBoxTheme.tableCellTitleTextColor
        textView.opaque = true
        textView.font = UIFont.systemFontOfSize(18)
        textView.scrollEnabled = false
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.hidden = true
        textView.layer.zPosition = 1000
        self.contentView.addSubview(textView)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.contentView.removeConstraints(self.constraintsList)
        let left = self.parentTableView?.separatorInset.left
        let leftConstraint = NSLayoutConstraint(item: self.textView,
                                                attribute:.Left,
                                                relatedBy: .Equal,
                                                toItem: self.contentView,
                                                attribute: .Left,
                                                multiplier: 1.0,
                                                constant: left!)
        let rightConstraint = NSLayoutConstraint(item: self.textView,
                                                 attribute:.Right,
                                                 relatedBy: .Equal,
                                                 toItem: self.contentView,
                                                 attribute: .Right,
                                                 multiplier: 1.0,
                                                 constant: -left!)

        self.contentView.addConstraint(NSLayoutConstraint(item: self.textView,
            attribute:.Top,
            relatedBy: .Equal,
            toItem: self.contentView,
            attribute: .Top,
            multiplier: 1.0,
            constant: 3.5))

        self.contentView.addConstraint(NSLayoutConstraint(item: self.textView,
            attribute:.Bottom,
            relatedBy: .Equal,
            toItem: self.contentView,
            attribute: .Bottom,
            multiplier: 1.0,
            constant: -3.5))

        self.contentView.addConstraint(leftConstraint)
        self.contentView.addConstraint(rightConstraint)
        self.constraintsList.append(leftConstraint)
        self.constraintsList.append(rightConstraint)
    }

    func configure(text: String, placeholder: String) -> String {
        self.textLabel?.text = placeholder
        self.textLabel?.textColor = SuggestionsBoxTheme.tableCellDescriptionTextColor

        self.textView.hidden = false
        self.textView.text = text
        self.textView.accessibilityValue = text
        self.textView.accessibilityLabel = placeholder

        return self.textView.text
    }

    func textViewDidChange(textView: UITextView) {

        if textView.text.characters.count > 0 {
            self.textLabel?.hidden = true
        } else {
            self.textLabel?.hidden = false
        }

        UIView.setAnimationsEnabled(false)
        self.parentTableView?.beginUpdates()
        self.parentTableView?.endUpdates()
        UIView.setAnimationsEnabled(true)
        delegate?.textDidChange(self)
    }
}

// MARK: NewSuggestionController
class NewSuggestionController: UITableViewController, UITextFieldDelegate, TextViewCellDelegate {

    weak var delegate: SuggestionsBoxDelegate?

    var titleText = String()
    var descriptionText = String()
    var footerLabel: UILabel = UILabel.init()

    let cellIdentifier = "TextViewCell"

    // MARK: View Lyfe Cycle

    required convenience init(coder aDecoder: NSCoder) {
        self.init(nibName: nil, bundle: nil)
    }

    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    override  func viewDidLoad() {
        super.viewDidLoad()

        // Content View
        self.view.backgroundColor = SuggestionsBoxTheme.viewBackgroundColor

        // NavigationBar
        self.navigationController!.navigationBar.barTintColor = SuggestionsBoxTheme.navigationBarBackgroundColor
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: SuggestionsBoxTheme.navigationBarTexColor]
        self.navigationController!.navigationBar.tintColor = SuggestionsBoxTheme.navigationBarButtonColor

        // Table View
        self.tableView.estimatedRowHeight = 34 // Default UITableViewCell Height
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.registerClass(TextViewCell.self, forCellReuseIdentifier: cellIdentifier)
        self.tableView.separatorColor = SuggestionsBoxTheme.tableSeparatorColor
        self.tableView.backgroundColor = SuggestionsBoxTheme.viewBackgroundColor

        // Footer Label
        self.footerLabel.text = SuggestionsBoxTheme.newSuggestionFooterText
        self.footerLabel.textAlignment = .Center
        self.footerLabel.numberOfLines = 3
        self.footerLabel.font = UIFont.systemFontOfSize(16)
        self.footerLabel.textColor = SuggestionsBoxTheme.viewTextColor
        self.footerLabel.frame = CGRectMake(SuggestionsBoxTheme.sizeTableViewHeaderViewPadding, 0, self.view.frame.size.width - SuggestionsBoxTheme.sizeTableViewHeaderViewPadding * 2, SuggestionsBoxTheme.sizeTableViewFooterViewHeight)
        self.tableView.tableFooterView = self.footerLabel

        // Title
        self.title = SuggestionsBoxTheme.newSuggestionTitleText

        // Button
        let saveButton = UIBarButtonItem.init(barButtonSystemItem: .Save, target: self, action: #selector(save(_:)))
        self.navigationItem.setRightBarButtonItem(saveButton, animated: false)
        self.navigationItem.rightBarButtonItem?.enabled = false

        let cancelButton = UIBarButtonItem.init(barButtonSystemItem: .Cancel, target: self, action: #selector(cancel(_:)))
        self.navigationItem.setLeftBarButtonItem(cancelButton, animated: false)
    }


    // MARK: UI Actions

    func save(sender: UIBarButtonItem) {

        if let delegate = delegate {
            let suggestion = Suggestion.init(suggestionId: NewSuggestionController.randomStringWithLength(12), title: titleText, description: descriptionText, user: SuggestionsBoxTheme.user, favorites: [], createdAt: NSDate())
            delegate.newSuggestionAdded(suggestion)
        }

        self.navigationController!.dismissViewControllerAnimated(true, completion: nil)
    }


    func cancel(sender: UIBarButtonItem) {
        self.navigationController!.dismissViewControllerAnimated(true, completion: nil)
    }


    // MARK: UITableView DataSource

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else {
            return 3
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! TextViewCell
        cell.parentTableView = self.tableView
        cell.selectionStyle = .None

        if indexPath.section == 0 {
            cell.delegate = self
            cell.tag = indexPath.row
            if indexPath.row == 0 {
                titleText = cell.configure(titleText, placeholder: SuggestionsBoxTheme.newSuggestionTitlePlaceholderText)
            } else {
                descriptionText = cell.configure(descriptionText, placeholder: SuggestionsBoxTheme.newSuggestionDescriptionPlaceholderText)
            }
        } else {
            if indexPath.row == 0 {
                cell.textLabel!.text = SuggestionsBoxTheme.newSuggestionVersionText
                cell.detailTextLabel?.text = UIDevice.currentDevice().systemVersion
            } else if indexPath.row == 1 {
                cell.textLabel!.text = SuggestionsBoxTheme.newSuggestionModelText
                cell.detailTextLabel?.text = UIDevice.currentDevice().model
            } else if indexPath.row == 2 {
                cell.textLabel!.text = SuggestionsBoxTheme.newSuggestionSystemText
                cell.detailTextLabel?.text = UIDevice.currentDevice().systemName
            } else {
                cell.textLabel!.text = ""
                cell.detailTextLabel?.text = ""
            }
        }
        return cell
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return SuggestionsBoxTheme.newSuggestionSuggestionSectionText
        } else {
            return SuggestionsBoxTheme.newSuggestionDeviceSectionText
        }
    }


    // MARK: TextViewCellDelegate

    func textDidChange(sender: TextViewCell) {

        if sender.tag == 0 {
            titleText = sender.textView.text
        } else {
            descriptionText = sender.textView.text
        }

        if titleText.characters.count > 3 && descriptionText.characters.count > 3 {
            self.navigationItem.rightBarButtonItem?.enabled = true
        } else {
            self.navigationItem.rightBarButtonItem?.enabled = false
        }
    }

    // MARK: Helpers

    static func randomStringWithLength(len: Int) -> String {

        let letters: NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let randomString: NSMutableString = NSMutableString(capacity: len)

        for _ in 1...len {
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }

        return randomString as String
    }
}
