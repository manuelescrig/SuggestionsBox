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
    func textDidChange(_ sender: TextViewCell)
}

class TextViewCell: UITableViewCell, UITextViewDelegate {

    var textView = UITextView()
    var constraintsList = [NSLayoutConstraint]()
    weak var parentTableView: UITableView?
    weak var delegate: TextViewCellDelegate?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = SuggestionsBoxTheme.tableCellBackgroundColor
        self.contentView.backgroundColor = SuggestionsBoxTheme.tableCellBackgroundColor

        self.textLabel?.textColor = SuggestionsBoxTheme.tableCellTitleTextColor
        self.detailTextLabel?.textColor = SuggestionsBoxTheme.tableCellDescriptionTextColor

        textView.contentInset = UIEdgeInsetsMake(0, -3, 0, 0)
        textView.delegate = self
        textView.backgroundColor = UIColor.clear
        textView.textColor = SuggestionsBoxTheme.tableCellTitleTextColor
        textView.isOpaque = true
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.isScrollEnabled = false
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isHidden = true
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
                                                attribute:.left,
                                                relatedBy: .equal,
                                                toItem: self.contentView,
                                                attribute: .left,
                                                multiplier: 1.0,
                                                constant: left!)
        let rightConstraint = NSLayoutConstraint(item: self.textView,
                                                 attribute:.right,
                                                 relatedBy: .equal,
                                                 toItem: self.contentView,
                                                 attribute: .right,
                                                 multiplier: 1.0,
                                                 constant: -left!)

        self.contentView.addConstraint(NSLayoutConstraint(item: self.textView,
            attribute:.top,
            relatedBy: .equal,
            toItem: self.contentView,
            attribute: .top,
            multiplier: 1.0,
            constant: 3.5))

        self.contentView.addConstraint(NSLayoutConstraint(item: self.textView,
            attribute:.bottom,
            relatedBy: .equal,
            toItem: self.contentView,
            attribute: .bottom,
            multiplier: 1.0,
            constant: -3.5))

        self.contentView.addConstraint(leftConstraint)
        self.contentView.addConstraint(rightConstraint)
        self.constraintsList.append(leftConstraint)
        self.constraintsList.append(rightConstraint)
    }

    func configure(_ text: String, placeholder: String) -> String {
        self.textLabel?.text = placeholder
        self.textLabel?.textColor = SuggestionsBoxTheme.tableCellDescriptionTextColor

        self.textView.isHidden = false
        self.textView.text = text
        self.textView.accessibilityValue = text
        self.textView.accessibilityLabel = placeholder

        return self.textView.text
    }

    func textViewDidChange(_ textView: UITextView) {

        if textView.text.characters.count > 0 {
            self.textLabel?.isHidden = true
        } else {
            self.textLabel?.isHidden = false
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

    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
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
        self.tableView.register(TextViewCell.self, forCellReuseIdentifier: cellIdentifier)
        self.tableView.separatorColor = SuggestionsBoxTheme.tableSeparatorColor
        self.tableView.backgroundColor = SuggestionsBoxTheme.viewBackgroundColor

        // Footer Label
        self.footerLabel.text = SuggestionsBoxTheme.newSuggestionFooterText
        self.footerLabel.textAlignment = .center
        self.footerLabel.numberOfLines = 3
        self.footerLabel.font = UIFont.systemFont(ofSize: 16)
        self.footerLabel.textColor = SuggestionsBoxTheme.viewTextColor
        self.footerLabel.frame = CGRect(x: SuggestionsBoxTheme.sizeTableViewHeaderViewPadding, y: 0, width: self.view.frame.size.width - SuggestionsBoxTheme.sizeTableViewHeaderViewPadding * 2, height: SuggestionsBoxTheme.sizeTableViewFooterViewHeight)
        self.tableView.tableFooterView = self.footerLabel

        // Title
        self.title = SuggestionsBoxTheme.newSuggestionTitleText

        // Button
        let saveButton = UIBarButtonItem.init(barButtonSystemItem: .save, target: self, action: #selector(save(_:)))
        self.navigationItem.setRightBarButton(saveButton, animated: false)
        self.navigationItem.rightBarButtonItem?.isEnabled = false

        let cancelButton = UIBarButtonItem.init(barButtonSystemItem: .cancel, target: self, action: #selector(cancel(_:)))
        self.navigationItem.setLeftBarButton(cancelButton, animated: false)
    }


    // MARK: UI Actions

    func save(_ sender: UIBarButtonItem) {

        if let delegate = delegate {
            let suggestion = Suggestion.init(suggestionId: NewSuggestionController.randomStringWithLength(12), title: titleText, description: descriptionText, user: SuggestionsBoxTheme.user, favorites: [], createdAt: Date())
            delegate.newSuggestionAdded(suggestion)
        }

        self.navigationController!.dismiss(animated: true, completion: nil)
    }


    func cancel(_ sender: UIBarButtonItem) {
        self.navigationController!.dismiss(animated: true, completion: nil)
    }


    // MARK: UITableView DataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else {
            return 3
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TextViewCell
        cell.parentTableView = self.tableView
        cell.selectionStyle = .none

        if (indexPath as NSIndexPath).section == 0 {
            cell.delegate = self
            cell.tag = (indexPath as NSIndexPath).row
            if (indexPath as NSIndexPath).row == 0 {
                titleText = cell.configure(titleText, placeholder: SuggestionsBoxTheme.newSuggestionTitlePlaceholderText)
            } else {
                descriptionText = cell.configure(descriptionText, placeholder: SuggestionsBoxTheme.newSuggestionDescriptionPlaceholderText)
            }
        } else {
            if (indexPath as NSIndexPath).row == 0 {
                cell.textLabel!.text = SuggestionsBoxTheme.newSuggestionVersionText
                cell.detailTextLabel?.text = UIDevice.current.systemVersion
            } else if (indexPath as NSIndexPath).row == 1 {
                cell.textLabel!.text = SuggestionsBoxTheme.newSuggestionModelText
                cell.detailTextLabel?.text = UIDevice.current.model
            } else if (indexPath as NSIndexPath).row == 2 {
                cell.textLabel!.text = SuggestionsBoxTheme.newSuggestionSystemText
                cell.detailTextLabel?.text = UIDevice.current.systemName
            } else {
                cell.textLabel!.text = ""
                cell.detailTextLabel?.text = ""
            }
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return SuggestionsBoxTheme.newSuggestionSuggestionSectionText
        } else {
            return SuggestionsBoxTheme.newSuggestionDeviceSectionText
        }
    }


    // MARK: TextViewCellDelegate

    func textDidChange(_ sender: TextViewCell) {

        if sender.tag == 0 {
            titleText = sender.textView.text
        } else {
            descriptionText = sender.textView.text
        }

        if titleText.characters.count > 3 && descriptionText.characters.count > 3 {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }

    // MARK: Helpers

    static func randomStringWithLength(_ len: Int) -> String {

        let letters: NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let randomString: NSMutableString = NSMutableString(capacity: len)

        for _ in 1...len {
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.character(at: Int(rand)))
        }

        return randomString as String
    }
}
