//
//  SuggestionsBox.swift
//  SuggestionsBox
//  An iOS library to aggregate users feedback about suggestions,
//  features or comments in order to help you build a better product.
//
//  https://github.com/manuelescrig/SuggestionsBox
//
//  Created by Manuel Escrig Ventura on 30/04/16.
//  Licence: MIT-Licence

/**
 * SuggestionsBoxTheme public class that represents the style of the library.
 */
open class SuggestionsBoxTheme {

    /// Name of the app
    open static var appName: String = "SuggestionsBox Example"

    /// Name of the SuggestionsBox module
    open static var title: String = "SuggestionsBox"
    
    /// Header text in the list of suggestions
    open static var headerText: String = ""
    
    /// Footer text in the list of suggestions
    open static var footerText: String = ""

    open static var detailSuggestionSectionText: String = "Suggestion Info"
    open static var detailCommentsSectionText: String = "Comments"
    open static var detailAdminSectionText: String = "Admin Options"
    open static var detailNewCommentText: String = "Leave a Comment"
    open static var detailDeleteText: String = "Delete"
    open static var detailFavoriteText: String = "Favorite"
    open static var detailFavoritesText: String = "Favorites"
    open static var detailDateFormat: String = "yyyy-MM-dd"

    open static var newSuggestionTitleText: String = "New Suggestion"
    open static var newSuggestionSuggestionSectionText: String = "Suggestion Info"
    open static var newSuggestionDeviceSectionText: String = "Device Info"
    open static var newSuggestionTitlePlaceholderText: String = "Enter Title"
    open static var newSuggestionDescriptionPlaceholderText: String = "Enter Description"
    open static var newSuggestionVersionText: String = "iOS Version"
    open static var newSuggestionModelText: String = "Model Name"
    open static var newSuggestionSystemText: String = "System Name"
    open static var newSuggestionFooterText: String = "Powered by SuggestionsBox"

    open static var newCommentTitleText: String = "New Comment"
    open static var newCommentCommentSectionText: String = "Comment Info"
    open static var newCommentCommentPlaceholderText: String = "Enter Comment"
    open static var newCommentFooterText: String = "Powered by SuggestionsBox"

    // Colors
    open static var navigationBarBackgroundColor: UIColor = UINavigationBar.appearance().barTintColor!
    open static var navigationBarTexColor: UIColor = UIColor.white
    open static var navigationBarButtonColor: UIColor = UIColor.white
    open static var navigationBarHeartColor: UIColor = UIColor.red
    open static var viewBackgroundColor: UIColor = UIColor.groupTableViewBackground
    open static var viewTextColor: UIColor = UIColor.lightGray
    open static var tableSeparatorColor: UIColor = UIColor.groupTableViewBackground
    open static var tableCellBackgroundColor: UIColor = UIColor.white
    open static var tableCellTitleTextColor: UIColor = UIColor.black
    open static var tableCellDescriptionTextColor: UIColor = UIColor.lightGray

    // Sizes
    open static var sizeSearchViewHeight: CGFloat = 44
    open static var sizeTableViewHeaderViewPadding: CGFloat = 10
    open static var sizeTableViewHeaderViewHeight: CGFloat = 80
    open static var sizeTableViewFooterViewPadding: CGFloat = 10
    open static var sizeTableViewFooterViewHeight: CGFloat = 80
    open static var sizeTableViewCellDefaultHeight: CGFloat = 44
    open static var sizeTableViewCommentButtonViewPadding: CGFloat = 20

    // User
    open static var user: String = "Anonymous"
    open static var userId: String = ""
    open static var admin: Bool = false

}

/**
 * SuggestionsBoxDelegate public protocol to be implemented in your ViewController 
 * in order to add the data and receive call-backs.
 */
public protocol SuggestionsBoxDelegate: NSObjectProtocol {

    func suggestions() -> Array<Suggestion>

    func commentsForSuggestion(_ suggestion: Suggestion) -> Array<Comment>

    func newSuggestionAdded(_ newSuggestion: Suggestion)

    func newCommentForSuggestionAdded(_ suggestion: Suggestion, newComment: Comment)

    func suggestionFavorited(_ suggestion: Suggestion)

    func suggestionUnFavorited(_ suggestion: Suggestion)

}

/**
 * SuggestionsBox public class that represents the main TableViewController.
 */
open class SuggestionsBox: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    open weak var delegate: SuggestionsBoxDelegate?

    var tableView: UITableView = UITableView.init()
    var searchBar: UISearchBar = UISearchBar.init()
    var headerView: UIView = UIView.init()
    var headerLabel: UILabel = UILabel.init()
    var footerLabel: UILabel = UILabel.init()

    var featureRequests = [Suggestion]()
    var searchResults = [Suggestion]()

    let cellIdentifier = "TextViewCell"

    // MARK: View Lyfe Cylce

    required public convenience init(coder aDecoder: NSCoder) {
        self.init(nibName: nil, bundle: nil)
    }

    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    override open func viewDidLoad() {
        super.viewDidLoad()

        // Content View
        self.view.backgroundColor = SuggestionsBoxTheme.viewBackgroundColor

        // NavigationBar
        self.navigationController!.navigationBar.barTintColor = SuggestionsBoxTheme.navigationBarBackgroundColor
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: SuggestionsBoxTheme.navigationBarTexColor]
        self.navigationController!.navigationBar.tintColor = SuggestionsBoxTheme.navigationBarButtonColor

        // Title
        self.title = SuggestionsBoxTheme.title

        // Button
        let addButton = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(add(_:)))
        self.navigationItem.setRightBarButton(addButton, animated: false)

        let cancelButton = UIBarButtonItem.init(barButtonSystemItem: .done, target: self, action: #selector(done(_:)))
        self.navigationItem.setLeftBarButton(cancelButton, animated: false)

        // TableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.isMultipleTouchEnabled = false
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.separatorColor = SuggestionsBoxTheme.tableSeparatorColor
        self.tableView.backgroundColor = SuggestionsBoxTheme.viewBackgroundColor
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        self.view.addSubview(self.tableView)

        // SearchBar
        self.searchBar.delegate = self
        self.searchBar.text = ""

        // Header Label
        headerLabel.text = SuggestionsBoxTheme.headerText
        headerLabel.textAlignment = .center
        headerLabel.numberOfLines = 3
        headerLabel.font = UIFont.systemFont(ofSize: 16)
        headerLabel.textColor = SuggestionsBoxTheme.viewTextColor
        headerView.addSubview(headerLabel)
        headerView.addSubview(searchBar)

        footerLabel.text = SuggestionsBoxTheme.footerText
        footerLabel.textAlignment = .center
        footerLabel.numberOfLines = 3
        footerLabel.font = UIFont.systemFont(ofSize: 16)
        footerLabel.textColor = SuggestionsBoxTheme.viewTextColor

    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Get Data
        self.getData()
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }

    // MARK: Layout Methods

    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        self.searchBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: SuggestionsBoxTheme.sizeSearchViewHeight)
        self.tableView.frame = self.view.bounds

        self.headerLabel.frame = CGRect(x: SuggestionsBoxTheme.sizeTableViewHeaderViewPadding, y: SuggestionsBoxTheme.sizeSearchViewHeight, width: self.view.frame.size.width - SuggestionsBoxTheme.sizeTableViewHeaderViewPadding * 2, height: SuggestionsBoxTheme.sizeTableViewHeaderViewHeight)
        self.headerView.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: SuggestionsBoxTheme.sizeTableViewHeaderViewHeight + SuggestionsBoxTheme.sizeSearchViewHeight)
        self.tableView.tableHeaderView = self.headerView

        self.footerLabel.frame = CGRect(x: SuggestionsBoxTheme.sizeTableViewHeaderViewPadding, y: 0, width: self.view.frame.size.width - SuggestionsBoxTheme.sizeTableViewHeaderViewPadding * 2, height: SuggestionsBoxTheme.sizeTableViewFooterViewHeight)
        self.tableView.tableFooterView = footerLabel
    }


    // MARK: DataSource

    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResults.count
    }

    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let suggestion = searchResults[(indexPath as NSIndexPath).row]
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as UITableViewCell?
        if (cell != nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellIdentifier)
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

    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        self.searchBar.resignFirstResponder()

        let detailController = DetailController()
        detailController.delegate = delegate
        detailController.suggestion = searchResults[(indexPath as NSIndexPath).row]
        self.navigationController?.pushViewController(detailController, animated: true)
    }


    // MARK: UI Actions

    func done(_ sender: UIBarButtonItem) {
        self.navigationController!.dismiss(animated: true, completion: nil)
    }

    func add(_ sender: UIBarButtonItem) {
        let newSuggestionController = NewSuggestionController(nibName: nil, bundle: nil)
        newSuggestionController.delegate = delegate
        let navigationBar = UINavigationController.init(rootViewController: newSuggestionController)
        self.present(navigationBar, animated: true, completion: nil)
    }


    // MARK: UISearchBar

    open func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchText.characters.count > 0 {
            self.searchResults = self.featureRequests.filter {$0.title.lowercased().contains(searchText) || $0.description.lowercased().contains(searchText.lowercased()) }
        } else {
            self.searchResults = self.featureRequests
        }
        self.tableView.reloadData()
    }


    // MARK: Data

    open func reloadData() {
        self.getData()
        self.tableView.reloadData()
    }
    
    func getData() {

        if let delegate = delegate {
            let suggestions = delegate.suggestions()
            self.featureRequests = suggestions
            self.searchResults = self.featureRequests.sorted(by: { $0.createdAt.timeIntervalSinceNow > $1.createdAt.timeIntervalSinceNow })
            self.tableView.reloadData()
        }
    }
}
