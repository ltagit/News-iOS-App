import UIKit
import Alamofire
import SwiftyJSON

protocol SearchTableDelegate {
    func whatlookingfor(selected searchterm: String)
}

class SearchTableViewController: UITableViewController, UISearchResultsUpdating {
    var delegate: SearchTableDelegate!
    var whatyoutyped = ""
    var bingresults = [""]
    var autosuggestResults = [String]()
    var searchsug = ""
    var whatcount = -1
    override func viewDidLoad() {
        super.viewDidLoad()
       // print("searchhere")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bingresults.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchingcell", for: indexPath) as! searchResultsCell
        cell.textsuggests.text = bingresults[indexPath.row]
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.whatlookingfor(selected: bingresults[indexPath.row])
    }
    
    func loadhomeCardsS()
           {
               let header = ["Ocp-Apim-Subscription-Key" : "RETRACTED"]
               Alamofire.request( "https://api.cognitive.microsoft.com/bing/v7.0/suggestions?q=\(searchsug)", method: .get, parameters: nil, encoding: URLEncoding(), headers: header).responseJSON{
                   (myresponse) in
                   switch myresponse.result{
                   case .success:
                    
                       let myresult = try? JSON(data:myresponse.data!)
                       self.bingresults.removeAll()
                       for i in myresult!["suggestionGroups"][0]["searchSuggestions"].arrayValue{
                        let tester = i["displayText"].stringValue
                    //    print("sug\(tester)")
                        self.bingresults.append(tester)
                       }
                       self.tableView.reloadSections([0], with: .none)
                       break
                   case .failure:
                       self.tableView.reloadSections([0], with: .none)
                       break
                   }
               }
               }
    
    func updateSearchResults(for searchController: UISearchController) {
        //print("youtyped: \(searchController.searchBar.text)")
      //  whatyoutyped = searchController.searchBar.text ?? ""
        searchController.searchBar.searchTextField.addTarget(self, action: #selector(onReturn), for: UIControl.Event.editingDidEndOnExit)
        if let inputText = searchController.searchBar.text, !inputText.isEmpty {
        //   print("You entered this text\(inputText)")
            whatyoutyped = inputText
            if (whatyoutyped.count >= 3)
            {
                if(whatcount != whatyoutyped.count){
            //    print("sentbyinhere \(inputText)")
                    searchsug = inputText.replacingOccurrences(of: " ", with: "")
             //       print("hey321\(searchsug)")
                    loadhomeCardsS()
            }

            whatcount = whatyoutyped.count
            }
            if (whatyoutyped.count == 1){
                whatcount = -1
            }
            
            if(whatyoutyped.count < 3){
                bingresults = [""]
               //  tableView.reloadData()
            }
               }
        
        
               tableView.reloadData()
    }
    
    
    
    
    @IBAction func onReturn(){
        print("youenteredit")
        delegate.whatlookingfor(selected: whatyoutyped)
    }

}
