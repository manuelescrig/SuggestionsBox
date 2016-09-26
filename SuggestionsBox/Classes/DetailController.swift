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

    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
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
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = SuggestionsBoxTheme.navigationBarHeartColor.cgColor
        shapeLayer.path = self.bezierHeartShapePathWithWidth(26, atPoint: CGPoint(x: 14, y: 15)).cgPath
        let heart: UIButton = UIButton(type: .custom)
        heart.showsTouchWhenHighlighted = false
        heart.layer.addSublayer(shapeLayer)
        heart.bounds = CGRect(x: 0, y: 0, width: 26, height: 26)
        heart.addTarget(self, action: #selector(DetailController.favorite(_:)), for: .touchDown)
        let heartButtonItem: UIBarButtonItem = UIBarButtonItem(customView: heart)
        self.navigationItem.rightBarButtonItem = heartButtonItem

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
    }

    override func viewWillAppear(_ animated: Bool) {
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

        self.tableView.frame = self.view.bounds
        self.newCommentButton.frame = CGRect(x: SuggestionsBoxTheme.sizeTableViewCommentButtonViewPadding, y: SuggestionsBoxTheme.sizeTableViewCommentButtonViewPadding, width: self.view.frame.size.width - SuggestionsBoxTheme.sizeTableViewCommentButtonViewPadding * 2, height: SuggestionsBoxTheme.sizeTableViewCellDefaultHeight)
    }


    // MARK: DataSource

    func numberOfSections(in tableView: UITableView) -> Int {

        if SuggestionsBoxTheme.admin {
            return 3
        } else {
            return 2
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

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

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as UITableViewCell?
        if (cell != nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellIdentifier)
        }

        cell!.selectionStyle = .none
        cell!.backgroundColor = SuggestionsBoxTheme.tableCellBackgroundColor
        cell!.contentView.backgroundColor = SuggestionsBoxTheme.tableCellBackgroundColor
        cell!.textLabel!.textColor = SuggestionsBoxTheme.tableCellTitleTextColor
        cell!.textLabel!.numberOfLines = 0
        cell!.detailTextLabel?.textColor =  SuggestionsBoxTheme.tableCellDescriptionTextColor
        cell!.detailTextLabel?.numberOfLines = 0

        switch (indexPath as NSIndexPath).section {
        case 0:
            if (indexPath as NSIndexPath).row == 0 {
                cell!.textLabel!.text = suggestion?.title
            } else if (indexPath as NSIndexPath).row == 1 {
                cell!.textLabel!.text = suggestion?.description
            } else if (indexPath as NSIndexPath).row == 2 {
                cell!.textLabel!.text = suggestion?.user
            } else if (indexPath as NSIndexPath).row == 3 {
                cell!.textLabel!.text = suggestion?.dateString()
            } else if (indexPath as NSIndexPath).row == 4 {
                cell!.textLabel!.text = suggestion?.favoritesString()
            } else {
                cell!.textLabel!.text = SuggestionsBoxTheme.detailNewCommentText
                cell!.textLabel!.font = UIFont.boldSystemFont(ofSize: 18)
            }
        case 1:
            let comment = comments[(indexPath as NSIndexPath).row]
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)

        if (indexPath as NSIndexPath).section == 0 && (indexPath as NSIndexPath).row == 5 {
            self.add()
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
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
        shapeLayer.fillColor = SuggestionsBoxTheme.navigationBarHeartColor.cgColor
        shapeLayer.strokeColor = SuggestionsBoxTheme.navigationBarHeartColor.cgColor
        shapeLayer.path = self.bezierHeartShapePathWithWidth(26, atPoint: CGPoint(x: 14, y: 15)).cgPath
        let heart: UIButton = UIButton(type: .custom)
        heart.showsTouchWhenHighlighted = false
        heart.layer.addSublayer(shapeLayer)
        heart.bounds = CGRect(x: 0, y: 0, width: 26, height: 26)
        heart.addTarget(self, action: #selector(DetailController.favorite(_:)), for: .touchDown)
        let heartButtonItem: UIBarButtonItem = UIBarButtonItem(customView: heart)
        self.navigationItem.rightBarButtonItem = heartButtonItem
        self.isFavorite = true
    }

    func iconUnFavoriteSuggestion() {
        let shapeLayer: CAShapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = SuggestionsBoxTheme.navigationBarHeartColor.cgColor
        shapeLayer.path = self.bezierHeartShapePathWithWidth(26, atPoint: CGPoint(x: 14, y: 15)).cgPath
        let heart: UIButton = UIButton(type: .custom)
        heart.showsTouchWhenHighlighted = false
        heart.layer.addSublayer(shapeLayer)
        heart.bounds = CGRect(x: 0, y: 0, width: 26, height: 26)
        heart.addTarget(self, action: #selector(DetailController.favorite(_:)), for: .touchDown)
        let heartButtonItem: UIBarButtonItem = UIBarButtonItem(customView: heart)
        self.navigationItem.rightBarButtonItem = heartButtonItem
        self.isFavorite = false
    }

    func degressToRadians(_ angle: CGFloat) -> CGFloat {
        return angle / 180.0 * CGFloat(M_PI)
    }

    func bezierHeartShapePathWithWidth(_ width: CGFloat, atPoint center: CGPoint) -> UIBezierPath {
        let w: CGFloat = width / 2.5
        let path: UIBezierPath = UIBezierPath()
        // Left arc
        path.addArc(withCenter: CGPoint(x: center.x - w / 2.0, y: center.y - w / 2.0), radius: (w * sqrt(2.0) / 2.0), startAngle: degressToRadians(135.0), endAngle: degressToRadians(-45.0), clockwise: true)
        // Right arc
        path.addArc(withCenter: CGPoint(x: center.x + w / 2.0, y: center.y - w / 2.0), radius: (w * sqrt(2.0) / 2.0), startAngle: degressToRadians(-135.0), endAngle: degressToRadians(45.0), clockwise: true)
        path.addLine(to: CGPoint(x: center.x, y: center.y + w))
        path.addLine(to: CGPoint(x: center.x - w, y: center.y))
        path.close()
        return path
    }


    // MARK: UI Actions

    func favorite(_ sender: UIBarButtonItem) {

        if isFavorite {

            let index = suggestion?.favorites.index(of: SuggestionsBoxTheme.userId)
            suggestion?.favorites.remove(at: index!)
            self.tableView .reloadRows(at: [IndexPath.init(item: 4, section: 0)],  with: .top)

            if let delegate = delegate {
                delegate.suggestionFavorited(suggestion!)
            }
            self.iconUnFavoriteSuggestion()

        } else {

            suggestion?.favorites.append(SuggestionsBoxTheme.userId)
            self.tableView .reloadRows(at: [IndexPath.init(item: 4, section: 0)],  with: .bottom)
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
        self.present(navigationBar, animated: true, completion: nil)
    }


    // MARK: Data

    func getData() {

        if let delegate = delegate {
            self.comments =  delegate.commentsForSuggestion(suggestion!)
            self.comments = self.comments.sorted(by: { $0.createdAt.timeIntervalSinceNow > $1.createdAt.timeIntervalSinceNow })
            self.tableView.reloadData()
        }
    }
}
