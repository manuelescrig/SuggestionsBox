//
//  SuggestionsBox.swift
//  SuggestionsBox
//
//  Created by Manuel Escrig Ventura on 30/04/16.
//
//


public struct SuggestionsBoxTheme {

    // Strings
    public static var name: String = ""
    public static var headerText: String = ""
    public static var footerText: String = ""

    public static var detailSuggestionSectionText: String = "Suggestion Info"
    public static var detailCommentsSectionText: String = "Comments"
    public static var detailAdminSectionText: String = "Admin Options"
    public static var detailNewCommentText: String = "Leave a Comment"
    public static var detailDeleteText: String = "Delete"
    public static var detailFavoriteText: String = "Favorite"
    public static var detailFavoritesText: String = "Favorites"
    public static var detailDateFormat: String = "yyyy-MM-dd"

    public static var newSuggestionTitleText: String = "New Suggestion"
    public static var newSuggestionSuggestionSectionText: String = "Suggestion Info"
    public static var newSuggestionDeviceSectionText: String = "Device Info"
    public static var newSuggestionTitlePlaceholderText: String = "Enter Title"
    public static var newSuggestionDescriptionPlaceholderText: String = "Enter Description"
    public static var newSuggestionVersionText: String = "iOS Version"
    public static var newSuggestionModelText: String = "Model Name"
    public static var newSuggestionSystemText: String = "System Name"
    public static var newSuggestionFooterText: String = "Powered by SuggestionsBox"

    public static var newCommentTitleText: String = "New Comment"
    public static var newCommentCommentSectionText: String = "Comment Info"
    public static var newCommentCommentPlaceholderText: String = "Enter Comment"
    public static var newCommentFooterText: String = "Powered by SuggestionsBox"

    // Colors
    public static var navigationBarBackgroundColor: UIColor = UIColor.grayColor()
    public static var navigationBarTexColor: UIColor = UIColor.whiteColor()
    public static var navigationBarButtonColor: UIColor = UIColor.whiteColor()
    public static var navigationBarHeartColor: UIColor = UIColor.redColor()
    public static var viewBackgroundColor: UIColor = UIColor.groupTableViewBackgroundColor()
    public static var viewTextColor: UIColor = UIColor.lightGrayColor()
    public static var tableSeparatorColor: UIColor = UIColor.groupTableViewBackgroundColor()
    public static var tableCellBackgroundColor: UIColor = UIColor.whiteColor()
    public static var tableCellTitleTextColor: UIColor = UIColor.blackColor()
    public static var tableCellDescriptionTextColor: UIColor = UIColor.lightGrayColor()

    // Sizes
    public static var sizeSearchViewHeight: CGFloat = 44
    public static var sizeTableViewHeaderViewPadding: CGFloat = 10
    public static var sizeTableViewHeaderViewHeight: CGFloat = 80
    public static var sizeTableViewFooterViewPadding: CGFloat = 10
    public static var sizeTableViewFooterViewHeight: CGFloat = 80
    public static var sizeTableViewCellDefaultHeight: CGFloat = 44
    public static var sizeTableViewCommentButtonViewPadding: CGFloat = 20
}

public struct SuggestionsBoxConfig {

    public static var title: String = "SuggestionsBox"
    public static var appName: String = "SuggestionsBox Example"
    public static var author: String = "Anonymous"
    public static var admin: Bool = false

}

public protocol SuggestionsBoxDelegate: NSObjectProtocol {

    func suggestions() -> Array<Suggestion>

    func commentsForSuggestion(suggestion: Suggestion) -> Array<Comment>

    func newSuggestionAdded(newSuggestion: Suggestion)

    func newCommentForSuggestionAdded(suggestion: Suggestion, newComment: Comment)

    func suggestionFavorited(suggestion: Suggestion)

    func suggestionUnFavorited(suggestion: Suggestion)

}


public class SuggestionsBox: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    public weak var delegate: SuggestionsBoxDelegate?

    var tableView: UITableView = UITableView.init()
    var searchBar: UISearchBar = UISearchBar.init()
    var headerView: UIView = UIView.init()
    var headerLabel: UILabel = UILabel.init()
    var footerLabel: UILabel = UILabel.init()

    var featureRequests = [Suggestion]()
    var searchResults = [Suggestion]()


    // MARK: View Lyfe Cylce

    required public convenience init(coder aDecoder: NSCoder) {
        self.init(nibName: nil, bundle: nil)
    }

    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        // Content View
        self.view.backgroundColor = SuggestionsBoxTheme.viewBackgroundColor

        // NavigationBar
        self.navigationController!.navigationBar.barTintColor = SuggestionsBoxTheme.navigationBarBackgroundColor
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: SuggestionsBoxTheme.navigationBarTexColor]
        self.navigationController!.navigationBar.tintColor = SuggestionsBoxTheme.navigationBarButtonColor

        // Title
        self.title = SuggestionsBoxTheme.name

        // Button
        let addButton = UIBarButtonItem.init(barButtonSystemItem: .Add, target: self, action: #selector(add(_:)))
        self.navigationItem.setRightBarButtonItem(addButton, animated: false)

        let cancelButton = UIBarButtonItem.init(barButtonSystemItem: .Done, target: self, action: #selector(done(_:)))
        self.navigationItem.setLeftBarButtonItem(cancelButton, animated: false)

        // TableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.multipleTouchEnabled = false
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.separatorColor = SuggestionsBoxTheme.tableSeparatorColor
        self.tableView.backgroundColor = SuggestionsBoxTheme.viewBackgroundColor
        self.tableView.tableFooterView = UIView()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
        self.view.addSubview(self.tableView)

        // SearchBar
        self.searchBar.delegate = self
        self.searchBar.text = ""

        // Header Label
        headerLabel.text = SuggestionsBoxTheme.headerText
        headerLabel.textAlignment = .Center
        headerLabel.numberOfLines = 3
        headerLabel.font = UIFont.systemFontOfSize(16)
        headerLabel.textColor = SuggestionsBoxTheme.viewTextColor
        headerView.addSubview(headerLabel)
        headerView.addSubview(searchBar)

        footerLabel.text = SuggestionsBoxTheme.footerText
        footerLabel.textAlignment = .Center
        footerLabel.numberOfLines = 3
        footerLabel.font = UIFont.systemFontOfSize(16)
        footerLabel.textColor = SuggestionsBoxTheme.viewTextColor

    }

    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        // Get Data
        self.getData()
    }

    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

    }

    // MARK: Layout Methods

    override public func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        print("viewWillLayoutSubviews")

        self.searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, SuggestionsBoxTheme.sizeSearchViewHeight)
        self.tableView.frame = self.view.frame

        self.headerLabel.frame = CGRectMake(SuggestionsBoxTheme.sizeTableViewHeaderViewPadding, SuggestionsBoxTheme.sizeSearchViewHeight, self.view.frame.size.width - SuggestionsBoxTheme.sizeTableViewHeaderViewPadding * 2, SuggestionsBoxTheme.sizeTableViewHeaderViewHeight)
        self.headerView.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, SuggestionsBoxTheme.sizeTableViewHeaderViewHeight + SuggestionsBoxTheme.sizeSearchViewHeight)
        self.tableView.tableHeaderView = self.headerView

        self.footerLabel.frame = CGRectMake(SuggestionsBoxTheme.sizeTableViewHeaderViewPadding, 0, self.view.frame.size.width - SuggestionsBoxTheme.sizeTableViewHeaderViewPadding * 2, SuggestionsBoxTheme.sizeTableViewFooterViewHeight)
        self.tableView.tableFooterView = footerLabel
    }


    // MARK: DataSource

    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResults.count
    }

    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let suggestion = searchResults[indexPath.row]
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("cellIdentifier") as UITableViewCell?
        if (cell != nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cellIdentifier")
        }
        cell!.backgroundColor = SuggestionsBoxTheme.tableCellBackgroundColor
        cell!.contentView.backgroundColor = SuggestionsBoxTheme.tableCellBackgroundColor
        cell!.textLabel!.text = suggestion.title
        cell!.textLabel!.textColor = SuggestionsBoxTheme.tableCellTitleTextColor
        cell!.textLabel!.numberOfLines = 0
        cell!.detailTextLabel?.text = suggestion.favoritesString()
        cell!.detailTextLabel?.textColor =  SuggestionsBoxTheme.tableCellDescriptionTextColor
        cell!.detailTextLabel?.numberOfLines = 0
        return cell!
    }


    // MARK: Delegate

    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.searchBar.resignFirstResponder()

        let detailController = DetailController()
        detailController.delegate = delegate
        detailController.suggestion = searchResults[indexPath.row]
        self.navigationController?.pushViewController(detailController, animated: true)
    }


    // MARK: UI Actions

    func done(sender: UIBarButtonItem) {
        self.navigationController!.dismissViewControllerAnimated(true, completion: nil)
    }

    func add(sender: UIBarButtonItem) {
        let newSuggestionController = NewSuggestionController(nibName: nil, bundle: nil)
        newSuggestionController.delegate = delegate
        let navigationBar = UINavigationController.init(rootViewController: newSuggestionController)
        self.presentViewController(navigationBar, animated: true, completion: nil)
    }


    // MARK: UISearchBar

    public func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {

        if searchText.characters.count > 0 {
            self.searchResults = self.featureRequests.filter {$0.title.containsString(searchText) || $0.description.containsString(searchText) }
        } else {
            self.searchResults = self.featureRequests
        }
        self.tableView.reloadData()
    }


    // MARK: Data

    func getData() {

        if let delegate = delegate {
            let suggestions = delegate.suggestions()
            self.featureRequests = suggestions
            self.searchResults = self.featureRequests.sort({ $0.createdAt.timeIntervalSinceNow > $1.createdAt.timeIntervalSinceNow })
            self.tableView.reloadData()
        }
    }
}
