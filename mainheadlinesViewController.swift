import UIKit
import XLPagerTabStrip
class mainheadlinesViewController: ButtonBarPagerTabStripViewController, SearchTableDelegate {
    //This search method was utilized from https://medium.com/@mattkopacz/dealing-with-searchable-content-in-a-separate-table-view-e733822f73fe
    func whatlookingfor(selected searchterm: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let forsearchresultview = storyboard.instantiateViewController(identifier: "searchresultspage") as? ResultsTableViewController{
        forsearchresultview.resultstest = searchterm
        self.navigationController?.pushViewController(forsearchresultview, animated: true)
        }
    }
    
    
    var resultController: UISearchController?
    private var resultTableController: SearchTableViewController!
    override func viewDidLoad() {
        settings.style.buttonBarBackgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        settings.style.selectedBarBackgroundColor = #colorLiteral(red: 0.239962846, green: 0.4757795334, blue: 0.8400776982, alpha: 1)
        settings.style.selectedBarHeight = 5
        settings.style.buttonBarItemBackgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 20)
        settings.style.buttonBarItemLeftRightMargin = 0.5
        settings.style.buttonBarItemTitleColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
        guard changeCurrentIndex == true else { return }
        oldCell?.label.textColor = #colorLiteral(red: 0.6362272501, green: 0.6363211274, blue: 0.6362066865, alpha: 1)
        oldCell?.label.font = oldCell?.label.font.withSize(15)
        newCell?.label.textColor = #colorLiteral(red: 0.4984611273, green: 0.6511092186, blue: 0.9885901809, alpha: 1)
        newCell?.label.font = newCell?.label.font.withSize(15)
        }
         super.viewDidLoad()

         //This search method was utilized from https://medium.com/@mattkopacz/dealing-with-searchable-content-in-a-separate-table-view-e733822f73fe
                 
                 resultTableController = (storyboard?.instantiateViewController(identifier: "SearchTest") as! SearchTableViewController)
                 resultTableController.delegate = self
                 resultController = UISearchController(searchResultsController: resultTableController)
                 resultController?.searchResultsUpdater = resultTableController
        resultController?.isActive = true
         navigationItem.searchController = resultController
        navigationItem.searchController?.searchBar.placeholder = "Enter keyword.."
        navigationItem.hidesSearchBarWhenScrolling = false
        resultController?.obscuresBackgroundDuringPresentation = true
        definesPresentationContext = false
    }

    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WorldOne")
        let child_2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BuisnessOne")
        let child_3 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PoliticsOne")
        let child_4 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SportsOne")
        let child_5 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TechnologyOne")
        let child_6 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ScienceOne")
        return[child_1, child_2, child_3, child_4, child_5, child_6]
        
        
    }
    
    
}
