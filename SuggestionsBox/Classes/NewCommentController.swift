//
//  NewCommentController.swift
//  SuggestionsBox
//
//  Created by Manuel Escrig Ventura on 30/04/16.
//
//


class NewCommentController: UITableViewController {
    
    var footerLabel : UILabel = UILabel.init()
    
    // MARK: View Lyfe Cylce
    
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
        
        // Title
        self.title = SuggestionsBoxTheme.newCommentTitleText
        
        // Table View
        self.tableView.estimatedRowHeight = 90
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.registerClass(TextViewCell.self, forCellReuseIdentifier: "cellIdentifier")
        self.tableView.separatorColor = SuggestionsBoxTheme.tableSeparatorColor
        self.tableView.backgroundColor = SuggestionsBoxTheme.viewBackgroundColor
        self.tableView.tableFooterView = UIView()

        // Footer Label
        self.footerLabel.text = SuggestionsBoxTheme.newSuggestionFooterText
        self.footerLabel.textAlignment = .Center
        self.footerLabel.numberOfLines = 3
        self.footerLabel.font = UIFont.systemFontOfSize(16)
        self.footerLabel.textColor = SuggestionsBoxTheme.viewTextColor
        self.footerLabel.frame = CGRectMake(SuggestionsBoxTheme.sizeTableViewHeaderViewPadding, 0, self.view.frame.size.width - SuggestionsBoxTheme.sizeTableViewHeaderViewPadding * 2, SuggestionsBoxTheme.sizeTableViewFooterViewHeight)
        self.tableView.tableFooterView = self.footerLabel
        
        // Button
        let saveButton = UIBarButtonItem.init(barButtonSystemItem: .Save, target: self, action: #selector(save(_:)))
        self.navigationItem.setRightBarButtonItem(saveButton, animated: false)
        
        let cancelButton = UIBarButtonItem.init(barButtonSystemItem: .Cancel, target: self, action: #selector(cancel(_:)))
        self.navigationItem.setLeftBarButtonItem(cancelButton, animated: false)
    }
    
    // MARK: UI Actions
    
    func save(sender: UIBarButtonItem)  {
        self.navigationController!.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func cancel(sender: UIBarButtonItem)  {
        self.navigationController!.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: UITableView DataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellIdentifier", forIndexPath: indexPath) as! TextViewCell
        cell.parentTableView = self.tableView
        cell.selectionStyle = .None
        cell.configure("", placeholder: SuggestionsBoxTheme.newCommentCommentPlaceholderText)

        return cell
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return SuggestionsBoxTheme.newCommentCommentSectionText
    }
    
    
}
