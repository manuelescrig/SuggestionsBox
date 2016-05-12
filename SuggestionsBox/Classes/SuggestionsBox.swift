//
//  SuggestionsBox.swift
//  SuggestionsBox
//
//  Created by Manuel Escrig Ventura on 30/04/16.
//
//


public class SuggestionsBox: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    let tableView : UITableView? = nil
    let searchBar : UISearchBar? = nil
    
    var featureRequests: [Suggestion]?
    var searchResults : [Suggestion]?
    
    let kTableViewHeaderViewPadding: CGFloat = 10
    let kTableViewHeaderViewHeight: CGFloat = 80
    let kTableViewFooterViewPadding: CGFloat = 10
    let kTableViewFooterViewHeight: CGFloat = 80

    // MARK: DataSource

    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }

    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("CustomCell")
        return cell!
    }
    
    // MARK: Delegate
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    public func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }

    public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kTableViewHeaderViewHeight
    }

    public func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView {
        var result: UIView? = nil
        if tableView.isEqual(self.tableView) && section == 0 {
            var label: UILabel = UILabel(frame: CGRectMake(kTableViewHeaderViewPadding, 0, self.view.frame.size.width - kTableViewHeaderViewPadding * 2, kTableViewHeaderViewHeight))
            label.text = NSLocalizedString("Powered by SuggestionsBox v1.0", comment: "")
            label.textAlignment = .Center
            label.numberOfLines = 3
            label.font = UIFont.systemFontOfSize(16)
            label.textColor = UIColor.lightGrayColor()

            var resultFrame: CGRect = CGRectMake(0.0, 0.0, self.view.frame.size.width, label.frame.size.height)
            result = UIView(frame: resultFrame)
            result!.addSubview(label)
        }
        return result!
    }
    
    public func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return kTableViewFooterViewHeight
    }
    
    public func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView {
        var result: UIView? = nil
        if tableView.isEqual(self.tableView) && section == 0 {
            var label: UILabel = UILabel(frame: CGRectMake(kTableViewHeaderViewPadding, 0, self.view.frame.size.width - kTableViewHeaderViewPadding * 2, kTableViewHeaderViewHeight))
            label.text = NSLocalizedString("Suggest a new feature, tweak, improvement... We'd love to hear your sugestions!", comment: "")
            label.textAlignment = .Center
            label.numberOfLines = 3
            label.font = UIFont.systemFontOfSize(16)
            label.textColor = UIColor.lightGrayColor()

            var resultFrame: CGRect = CGRectMake(0.0, 0.0, self.view.frame.size.width, label.frame.size.height)
            result = UIView(frame: resultFrame)
            result!.addSubview(label)
        }
        return result!
    }
    
    // MARK: UISearchBar
    
    public func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
//        if searchText.characters.count > 0 {
//            var predicate: NSPredicate = NSPredicate(format: "featureTitle contains[c] %@", searchText)
//            self.searchResults = self.featureRequests.filteredArrayUsingPredicate(predicate)
//        } else {
//            self.searchResults = self.featureRequests.copy()
//        }
//        self.tableView!.reloadData()
    }
}


