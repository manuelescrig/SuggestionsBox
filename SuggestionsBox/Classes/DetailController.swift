//
//  DetailController.swift
//  SuggestionsBox
//
//  Created by Manuel Escrig Ventura on 30/04/16.
//
//


class DetailController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var delegate: SuggestionsBoxDelegate?

    var tableView: UITableView = UITableView.init()
    var newCommentButton: UIButton = UIButton.init()
    var suggestion: Suggestion?
    var comments = [Comment]()

    var isFavorite = false

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
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
        self.view.addSubview(self.tableView)
    }


    // MARK: Layout Methods

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        self.tableView.frame = self.view.frame
        self.newCommentButton.frame = CGRectMake(SuggestionsBoxTheme.sizeTableViewCommentButtonViewPadding, SuggestionsBoxTheme.sizeTableViewCommentButtonViewPadding, self.view.frame.size.width - SuggestionsBoxTheme.sizeTableViewCommentButtonViewPadding * 2, SuggestionsBoxTheme.sizeTableViewCellDefaultHeight)
    }


    // MARK: DataSource

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        if SuggestionsBoxConfig.admin {
            return 3
        } else {
            return 2
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch section {
        case 0:
            return 5
        case 1:
            return self.comments.count
        case 2:
            return 1
        default:
            return 1
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let commet = comments[0]
        let cell = tableView.dequeueReusableCellWithIdentifier("cellIdentifier", forIndexPath: indexPath)
        cell.selectionStyle = .None
        cell.textLabel?.numberOfLines = 0
        cell.textLabel!.textColor = SuggestionsBoxTheme.tableCellTitleTextColor
        cell.backgroundColor = SuggestionsBoxTheme.tableCellBackgroundColor
        cell.contentView.backgroundColor = SuggestionsBoxTheme.tableCellBackgroundColor

        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                cell.textLabel!.text = suggestion?.title
            } else if indexPath.row == 1 {
                cell.textLabel!.text = suggestion?.description
            } else if indexPath.row == 2 {
                cell.textLabel!.text = suggestion?.author
            } else if indexPath.row == 3 {
                cell.textLabel!.text = suggestion?.dateString()
            } else {
                cell.textLabel!.text = suggestion?.favoritesString()
            }
        case 1:
            cell.textLabel!.text = commet.description
            cell.detailTextLabel?.text = String(commet.author)
        case 2:
            cell.textLabel!.text = SuggestionsBoxTheme.detailDeleteText
        default:
            cell.textLabel!.text = ""
        }

        return cell
    }


    // MARK: Delegate

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
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

    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 100
        default:
            return 0
        }
    }

    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let result = UIView.init()

        if tableView.isEqual(self.tableView) && section == 0 {

            newCommentButton.titleLabel!.textAlignment = .Center
            newCommentButton.titleLabel!.font = UIFont.boldSystemFontOfSize(16)
            newCommentButton.layer.cornerRadius = 20
            newCommentButton.layer.borderColor = UIColor.grayColor().CGColor
            newCommentButton.layer.borderWidth = 1
            newCommentButton.setTitle(SuggestionsBoxTheme.detailNewCommentText, forState: .Normal)
            newCommentButton.setTitleColor(UIColor.grayColor(), forState: .Normal)
            newCommentButton.addTarget(self, action: #selector(DetailController.buttonHighlight(_:)), forControlEvents: .TouchDown)
            newCommentButton.addTarget(self, action: #selector(DetailController.buttonNormal(_:)), forControlEvents: .TouchUpInside)
            newCommentButton.addTarget(self, action: #selector(DetailController.buttonNormal(_:)), forControlEvents: .TouchUpOutside)
            newCommentButton.addTarget(self, action: #selector(DetailController.buttonNormal(_:)), forControlEvents: .TouchCancel)
            newCommentButton.addTarget(self, action: #selector(DetailController.add(_:)), forControlEvents: .TouchUpInside)
            newCommentButton.clipsToBounds = true
            newCommentButton.layer.masksToBounds = true

            let resultFrame: CGRect = CGRectMake(0.0, 0.0, self.view.frame.size.width, newCommentButton.frame.size.height)
            result.frame = resultFrame
            result.addSubview(newCommentButton)
        }
        return result
    }


    // MARK: Icon Bezier Paths

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
        print("favorite")

        if isFavorite {
            // Add Button
            let shapeLayer: CAShapeLayer = CAShapeLayer()
            shapeLayer.fillColor = UIColor.clearColor().CGColor
            shapeLayer.strokeColor = SuggestionsBoxTheme.navigationBarHeartColor.CGColor
            shapeLayer.path = self.bezierHeartShapePathWithWidth(26, atPoint: CGPointMake(14, 15)).CGPath
            let heart: UIButton = UIButton(type: .Custom)
            heart.showsTouchWhenHighlighted = false
            heart.layer.addSublayer(shapeLayer)
            heart.bounds = CGRect(x: 0, y: 0, width: 26, height: 26)
            heart.addTarget(self, action: #selector(DetailController.favorite(_:)), forControlEvents: .TouchDown)
            let heartButtonItem: UIBarButtonItem = UIBarButtonItem(customView: heart)
            self.navigationItem.rightBarButtonItem = heartButtonItem
            self.isFavorite = false

        } else {
            let shapeLayer: CAShapeLayer = CAShapeLayer()
            shapeLayer.fillColor = SuggestionsBoxTheme.navigationBarHeartColor.CGColor
            shapeLayer.strokeColor = SuggestionsBoxTheme.navigationBarHeartColor.CGColor
            shapeLayer.path = self.bezierHeartShapePathWithWidth(26, atPoint: CGPointMake(14, 15)).CGPath
            let heart: UIButton = UIButton(type: .Custom)
            heart.showsTouchWhenHighlighted = false
            heart.layer.addSublayer(shapeLayer)
            heart.bounds = CGRect(x: 0, y: 0, width: 26, height: 26)
            heart.addTarget(self, action: #selector(DetailController.favorite(_:)), forControlEvents: .TouchDown)
            let heartButtonItem: UIBarButtonItem = UIBarButtonItem(customView: heart)
            self.navigationItem.rightBarButtonItem = heartButtonItem
            self.isFavorite = true
        }
    }

    func buttonHighlight(sender: UIButton) {
        print("buttonHighlight")
        sender.backgroundColor = UIColor.lightGrayColor()
    }

    func buttonNormal(sender: UIButton) {
        print("buttonNormal")
        sender.backgroundColor = UIColor.groupTableViewBackgroundColor()
    }

    func add(sender: UIBarButtonItem) {
        print("add")

        let newCommentController = NewCommentController(nibName: nil, bundle: nil)
        newCommentController.delegate = delegate
        newCommentController.suggestion = suggestion
        let navigationBar = UINavigationController.init(rootViewController: newCommentController)
        self.presentViewController(navigationBar, animated: true, completion: nil)
    }
}
