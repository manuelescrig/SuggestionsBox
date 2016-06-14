//
//  DetailController.swift
//  SuggestionsBox
//  An iOS library to aggregate users feedback about suggestions,
//  features or comments in order to help you build a better product.
//
//  https://github.com/manuelescrig/SuggestionsBox
//
//  Created by Manuel Escrig Ventura on 30/04/16.
//  Licence: MIT-Licence


class DetailController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    weak var delegate: SuggestionsBoxDelegate?

    var tableView: UITableView = UITableView.init()
    var newCommentButton: UIButton = UIButton.init()
    var suggestion: Suggestion?
    var comments = [Comment]()

    var isFavorite = false

    let cellIdentifier = "TextViewCell"

    // MARK: View Lyfe Cylce

    required convenience init(coder aDecoder: NSCoder) {
        self.init(nibName: nil, bundle: nil)
    }

    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Content View
        self.view.backgroundColor = SuggestionsBoxTheme.viewBackgroundColor

        // NavigationBar
        self.navigationController!.navigationBar.barTintColor = SuggestionsBoxTheme.navigationBarBackgroundColor
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: SuggestionsBoxTheme.navigationBarTexColor]
        self.navigationController!.navigationBar.tintColor = SuggestionsBoxTheme.navigationBarButtonColor

        // Title
        self.title = suggestion?.title

        // Button
        let shapeLayer: CAShapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.clearColor().CGColor
        shapeLayer.strokeColor = SuggestionsBoxTheme.navigationBarHeartColor.CGColor
        shapeLayer.path = self.bezierHeartShapePathWithWidth(26, atPoint: CGPoint(x: 14, y: 15)).CGPath
        let heart: UIButton = UIButton(type: .Custom)
        heart.showsTouchWhenHighlighted = false
        heart.layer.addSublayer(shapeLayer)
        heart.bounds = CGRect(x: 0, y: 0, width: 26, height: 26)
        heart.addTarget(self, action: #selector(DetailController.favorite(_:)), forControlEvents: .TouchDown)
        let heartButtonItem: UIBarButtonItem = UIBarButtonItem(customView: heart)
        self.navigationItem.rightBarButtonItem = heartButtonItem

        // TableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.multipleTouchEnabled = false
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.separatorColor = SuggestionsBoxTheme.tableSeparatorColor
        self.tableView.backgroundColor = SuggestionsBoxTheme.viewBackgroundColor
        self.tableView.tableFooterView = UIView()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        self.view.addSubview(self.tableView)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        // Get Data
        self.getData()

        if (suggestion?.favorites.contains(SuggestionsBoxTheme.userId) == true ) {
            self.iconFavoriteSuggestion()
        } else {
            self.iconUnFavoriteSuggestion()
        }
    }


    // MARK: Layout Methods

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        self.tableView.frame = self.view.frame
        self.newCommentButton.frame = CGRectMake(SuggestionsBoxTheme.sizeTableViewCommentButtonViewPadding, SuggestionsBoxTheme.sizeTableViewCommentButtonViewPadding, self.view.frame.size.width - SuggestionsBoxTheme.sizeTableViewCommentButtonViewPadding * 2, SuggestionsBoxTheme.sizeTableViewCellDefaultHeight)
    }


    // MARK: DataSource

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        if SuggestionsBoxTheme.admin {
            return 3
        } else {
            return 2
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch section {
        case 0:
            return 6
        case 1:
            return self.comments.count
        case 2:
            return 1
        default:
            return 1
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as UITableViewCell?
        if (cell != nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellIdentifier)
        }

        cell!.selectionStyle = .None
        cell!.backgroundColor = SuggestionsBoxTheme.tableCellBackgroundColor
        cell!.contentView.backgroundColor = SuggestionsBoxTheme.tableCellBackgroundColor
        cell!.textLabel!.textColor = SuggestionsBoxTheme.tableCellTitleTextColor
        cell!.textLabel!.numberOfLines = 0
        cell!.detailTextLabel?.textColor =  SuggestionsBoxTheme.tableCellDescriptionTextColor
        cell!.detailTextLabel?.numberOfLines = 0

        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                cell!.textLabel!.text = suggestion?.title
            } else if indexPath.row == 1 {
                cell!.textLabel!.text = suggestion?.description
            } else if indexPath.row == 2 {
                cell!.textLabel!.text = suggestion?.user
            } else if indexPath.row == 3 {
                cell!.textLabel!.text = suggestion?.dateString()
            } else if indexPath.row == 4 {
                cell!.textLabel!.text = suggestion?.favoritesString()
            } else {
                cell!.textLabel!.text = SuggestionsBoxTheme.detailNewCommentText
                cell!.textLabel!.font = UIFont.boldSystemFontOfSize(18)
            }
        case 1:
            let comment = comments[indexPath.row]
            cell!.textLabel!.text = comment.description
            cell!.detailTextLabel?.text = comment.user + " - " + comment.dateString()

        case 2:
            cell!.textLabel!.text = SuggestionsBoxTheme.detailDeleteText
        default:
            cell!.textLabel!.text = ""
        }

        return cell!
    }


    // MARK: Delegate

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)

        if indexPath.section == 0 && indexPath.row == 5 {
            self.add()
        }
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var sectionName: String
        switch section {
        case 0:
            sectionName = SuggestionsBoxTheme.detailSuggestionSectionText
        case 1:
            sectionName = SuggestionsBoxTheme.detailCommentsSectionText
        case 2:
            sectionName = SuggestionsBoxTheme.detailAdminSectionText
        default:
            sectionName = ""
        }

        return sectionName
    }


    // MARK: Icon Bezier Paths

    func iconFavoriteSuggestion() {
        let shapeLayer: CAShapeLayer = CAShapeLayer()
        shapeLayer.fillColor = SuggestionsBoxTheme.navigationBarHeartColor.CGColor
        shapeLayer.strokeColor = SuggestionsBoxTheme.navigationBarHeartColor.CGColor
        shapeLayer.path = self.bezierHeartShapePathWithWidth(26, atPoint: CGPoint(x: 14, y: 15)).CGPath
        let heart: UIButton = UIButton(type: .Custom)
        heart.showsTouchWhenHighlighted = false
        heart.layer.addSublayer(shapeLayer)
        heart.bounds = CGRect(x: 0, y: 0, width: 26, height: 26)
        heart.addTarget(self, action: #selector(DetailController.favorite(_:)), forControlEvents: .TouchDown)
        let heartButtonItem: UIBarButtonItem = UIBarButtonItem(customView: heart)
        self.navigationItem.rightBarButtonItem = heartButtonItem
        self.isFavorite = true
    }

    func iconUnFavoriteSuggestion() {
        let shapeLayer: CAShapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.clearColor().CGColor
        shapeLayer.strokeColor = SuggestionsBoxTheme.navigationBarHeartColor.CGColor
        shapeLayer.path = self.bezierHeartShapePathWithWidth(26, atPoint: CGPoint(x: 14, y: 15)).CGPath
        let heart: UIButton = UIButton(type: .Custom)
        heart.showsTouchWhenHighlighted = false
        heart.layer.addSublayer(shapeLayer)
        heart.bounds = CGRect(x: 0, y: 0, width: 26, height: 26)
        heart.addTarget(self, action: #selector(DetailController.favorite(_:)), forControlEvents: .TouchDown)
        let heartButtonItem: UIBarButtonItem = UIBarButtonItem(customView: heart)
        self.navigationItem.rightBarButtonItem = heartButtonItem
        self.isFavorite = false
    }

    func degressToRadians(angle: CGFloat) -> CGFloat {
        return angle / 180.0 * CGFloat(M_PI)
    }

    func bezierHeartShapePathWithWidth(width: CGFloat, atPoint center: CGPoint) -> UIBezierPath {
        let w: CGFloat = width / 2.5
        let path: UIBezierPath = UIBezierPath()
        // Left arc
        path.addArcWithCenter(CGPointMake(center.x - w / 2.0, center.y - w / 2.0), radius: (w * sqrt(2.0) / 2.0), startAngle: degressToRadians(135.0), endAngle: degressToRadians(-45.0), clockwise: true)
        // Right arc
        path.addArcWithCenter(CGPointMake(center.x + w / 2.0, center.y - w / 2.0), radius: (w * sqrt(2.0) / 2.0), startAngle: degressToRadians(-135.0), endAngle: degressToRadians(45.0), clockwise: true)
        path.addLineToPoint(CGPointMake(center.x, center.y + w))
        path.addLineToPoint(CGPointMake(center.x - w, center.y))
        path.closePath()
        return path
    }


    // MARK: UI Actions

    func favorite(sender: UIBarButtonItem) {

        if isFavorite {

            let index = suggestion?.favorites.indexOf(SuggestionsBoxTheme.userId)
            suggestion?.favorites.removeAtIndex(index!)
            self.tableView .reloadRowsAtIndexPaths([NSIndexPath.init(forItem: 4, inSection: 0)],  withRowAnimation: .Top)

            if let delegate = delegate {
                delegate.suggestionFavorited(suggestion!)
            }
            self.iconUnFavoriteSuggestion()

        } else {

            suggestion?.favorites.append(SuggestionsBoxTheme.userId)
            self.tableView .reloadRowsAtIndexPaths([NSIndexPath.init(forItem: 4, inSection: 0)],  withRowAnimation: .Bottom)
            if let delegate = delegate {
                delegate.suggestionUnFavorited(suggestion!)
            }
            self.iconFavoriteSuggestion()
        }
    }

    func add() {

        let newCommentController = NewCommentController(nibName: nil, bundle: nil)
        newCommentController.delegate = delegate
        newCommentController.suggestion = suggestion
        let navigationBar = UINavigationController.init(rootViewController: newCommentController)
        self.presentViewController(navigationBar, animated: true, completion: nil)
    }


    // MARK: Data

    func getData() {

        if let delegate = delegate {
            self.comments =  delegate.commentsForSuggestion(suggestion!)
            self.comments = self.comments.sort({ $0.createdAt.timeIntervalSinceNow > $1.createdAt.timeIntervalSinceNow })
            self.tableView.reloadData()
        }
    }
}
