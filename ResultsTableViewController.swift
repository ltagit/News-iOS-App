import UIKit
import Alamofire
import SDWebImage
import SwiftyJSON
import SwiftSpinner
import Toast_Swift

class ResultsTableViewController: UITableViewController {
        var currentidS = "default"
        var titleArrayS = [String]()
        var currenttitleS: String = ""
        var currentidtosendS: String = ""
        var catArrayS = [String]()
        var dateArrayS = [String]()
        var picArrayS = [String]()
        var idArrayS = [String]()
        var firstloadS = false
        var initialbutstateS = [Int]()
        var valuesformemS = [String]()
        var datemod2ArrayS = [String] ()
        var urlArrayS = [String]()
        let defaultsS = UserDefaults.standard
        var resultstest: String?
        var searchtermtolookup = ""

    func callbacktothisS(cell: ResultsTableViewCell){
       // print(self.datemod2ArrayS)
        let indexPathTapped = tableView.indexPath(for: cell)
      //  print(indexPathTapped!.row)
       // cell.bookmarkButImage.isSelected = true
        print(idArrayS[indexPathTapped!.row])
        if (initialbutstateS[indexPathTapped!.row] == 1){
            self.navigationController?.view.hideAllToasts()
            initialbutstateS[indexPathTapped!.row] = 0
            valuesformemS.removeAll {$0 == idArrayS[indexPathTapped!.row]}
            defaultsS.set(0, forKey: "butstate\(idArrayS[indexPathTapped!.row])")
            defaultsS.set(valuesformemS, forKey: "valuesarray")
            self.navigationController?.view.makeToast("Article Removed From Bookmark")
        }
        else {
            self.navigationController?.view.hideAllToasts()
            initialbutstateS[indexPathTapped!.row] = 1
            if (valuesformemS.contains(idArrayS[indexPathTapped!.row]) == false){
             valuesformemS.append(idArrayS[indexPathTapped!.row])
            }
            //sets defaults for the butstate, image (either url or ""), title, date, cat, and general values array.
            defaultsS.set(1, forKey: "butstate\(idArrayS[indexPathTapped!.row])")
            if picArrayS[indexPathTapped!.row] != ""{
                defaultsS.set(picArrayS[indexPathTapped!.row], forKey: "image\(idArrayS[indexPathTapped!.row])")
                       }
                       else{
                defaultsS.set("", forKey: "image\(idArrayS[indexPathTapped!.row])")
                       }
            defaultsS.set(titleArrayS[indexPathTapped!.row], forKey: "title\(idArrayS[indexPathTapped!.row])")
            defaultsS.set(datemod2ArrayS[indexPathTapped!.row], forKey: "date\(idArrayS[indexPathTapped!.row])")
            defaultsS.set(catArrayS[indexPathTapped!.row], forKey: "cat\(idArrayS[indexPathTapped!.row])")
            defaultsS.set(urlArrayS[indexPathTapped!.row], forKey: "url\(idArrayS[indexPathTapped!.row])")
            defaultsS.set(valuesformemS, forKey: "valuesarray")
            self.navigationController?.view.makeToast("Article Bookmarked. Check out the Bookmarks tab to view")
        }
     //   initialbutstate = 1;
        //print(initialbutstateS)
        //print(defaultsS.string(forKey: "cat\(idArrayS[indexPathTapped!.row])"))
        //print(defaultsS.stringArray(forKey: "valuesarray"))
    //    print("def val is: \(defaults.string(forKey: "title\(idArray[indexPathTapped!.row])")!)")
       // self.tableView.reloadSections([1], with: .none)
        
        if (initialbutstateS[indexPathTapped!.row] == 0)
        {
            cell.bookmarkButImageS.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
        else if (initialbutstateS[indexPathTapped!.row] == 1)
        {
            cell.bookmarkButImageS.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
       // print("sentby \(resultstest)")
        searchtermtolookup = resultstest ?? "Coronavirus"
       // print("sentby1 \(searchtermtolookup)")
        
        if(defaultsS.stringArray(forKey: "valuesarray") != nil){
                        valuesformemS = defaultsS.stringArray(forKey: "valuesarray")!
                       }

               SwiftSpinner.show("Loading Search results..")
                       loadhomeCards()
        
    }
       override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            if !firstloadS{
             //    print("Headlines1 Appeared ")
                if(defaultsS.stringArray(forKey: "valuesarray") != nil){
                 valuesformemS = defaultsS.stringArray(forKey: "valuesarray")!
                }
                        SwiftSpinner.show("Loading Search results..")
                        loadhomeCards()
               // tableView.reloadData()
             }
             firstloadS = false
        }

    @IBAction func refreshsearchpage(_ sender: UIRefreshControl) {
            loadhomeCards()
                sender.endRefreshing()
    }
        func loadhomeCards()
        {
            let parameters = ["whichguardurl" : "\(searchtermtolookup)"]
            Alamofire.request( "BackendRouteRetracted2gsearch", method: .post, parameters: parameters, encoding: URLEncoding(), headers: nil).responseJSON{
                (myresponse) in
                switch myresponse.result{
                case .success:
                    let myresult = try? JSON(data:myresponse.data!)
                    self.titleArrayS.removeAll()
                    self.catArrayS.removeAll()
                    self.dateArrayS.removeAll()
                    self.picArrayS.removeAll()
                    self.idArrayS.removeAll()
                    self.initialbutstateS.removeAll()
                    self.datemod2ArrayS.removeAll()
                    self.urlArrayS.removeAll()
                    
                    for i in myresult!["response"]["results"].arrayValue{
                        let webTitle = i["webTitle"].stringValue
                       // print("title is: \(webTitle)")
                        let sectionName = i["sectionName"].stringValue
                        var webPublicationDate = i["webPublicationDate"].stringValue
                        if (webPublicationDate == "" ){
                            webPublicationDate = "2020-05-07T08:00:18Z"
                        }
                        let id = i["id"].stringValue
                        self.idArrayS.append(id)
                        var weburl1 = i["webUrl"].stringValue
                        //error for no url
                        if (weburl1 == ""){
                            weburl1 = "http://www.guardian.co.uk/404"
                        }
                        self.urlArrayS.append(weburl1)
                        //print("id is: \(id)")
                        //print("this is: \(thumbnail)")
                      //  self.picArray1.append(thumbnail)
                       // print("this is: \(self.picArray1)")
                        let testingpic = i["blocks"]["main"]["elements"][0]["assets"].arrayValue
                        let testingpicindex = testingpic.endIndex
                        if testingpic.count != 0{
                        self.picArrayS.append(testingpic[testingpicindex-1]["file"].stringValue)
                        }
                        else{
                            self.picArrayS.append("")
                        }
                     //   print ("picarray \(self.picArrayS)")
                        //print("\(webTitle)")
                        self.titleArrayS.append(webTitle)
                        self.catArrayS.append(sectionName)
                        let dateFormat = ISO8601DateFormatter()
                        let date = dateFormat.date(from:webPublicationDate)!
                       // print("This is reformatted date from thingy: \(date)")
                             let dateformater2 = DateFormatter()
                             dateformater2.locale = Locale(identifier:"en_GB")
                             dateformater2.setLocalizedDateFormatFromTemplate("ddMMMYYYY")
                        // print("This2 is reformatted date from thingy: \(dateformater2.string(from:date))")
                         self.datemod2ArrayS.append(dateformater2.string(from:date))
                        let difdats = Calendar.current.dateComponents([.day], from: date, to: Date()).day!
                        let difhours = Calendar.current.dateComponents([.hour], from: date, to: Date()).hour!
                        let difmins = Calendar.current.dateComponents([.minute], from: date, to: Date()).minute!
                        let difsecs = Calendar.current.dateComponents([.second], from: date, to: Date()).second!
                        if difdats >= 1{
                            print("diffdays: \(difdats) days ago")
                            self.dateArrayS.append("\(difdats) days ago")
                        }
                        else if difhours >= 1 && difdats < 1 {
                            print("diffhours: \(difhours)h ago")
                            self.dateArrayS.append("\(difhours)h ago")
                        }
                        else if difhours < 1 && difmins >= 1{
                            print("diffmins: \(difmins)m ago")
                            self.dateArrayS.append("\(difmins)m ago")
                        }
                        else if difhours < 1 && difmins < 1 {
                            print("diffsecs: \(difsecs)s ago")
                            self.dateArrayS.append("\(difsecs)s ago")
                        }
                        else {
                            print("diff happen now")
                            self.dateArrayS.append("d ago")
                        }

                        self.initialbutstateS.append(self.defaultsS.integer(forKey: "butstate\(id)"))
                    }
               //     print(myresult!["response"]["results"][0].description)
                      //self.tableView.reloadData()
                 //   print("sentby3\(self.titleArrayS)")
                    if (self.titleArrayS.count == 0){
                     //   print("sentby4empty")
                         SwiftSpinner.hide()
                    }
                    self.tableView.reloadSections([0], with: .none)
                    break
                case .failure:
                    self.tableView.reloadSections([0], with: .none)
                      SwiftSpinner.hide()
                   //   self.tableView.reloadData()
                    break
                }
            }
            }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArrayS.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "resultscell", for: indexPath) as! ResultsTableViewCell
            cell.linkS = self
            //initially when the app is open, load the state of the but
            if (initialbutstateS[indexPath.row] == 0)
            {
                cell.bookmarkButImageS.setImage(UIImage(systemName: "bookmark"), for: .normal)
            }
            else if (initialbutstateS[indexPath.row] == 1)
            {
                cell.bookmarkButImageS.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            }
              if picArrayS[indexPath.row] != ""{
                cell.newsPictureLabelS.sd_setImage(with: URL(string: picArrayS[indexPath.row]), placeholderImage: UIImage(named: "default-guardian"))
              }
              else{
                  cell.newsPictureLabelS.image = #imageLiteral(resourceName: "default-guardian")
              }
              cell.labelTextOfS.text = "\(titleArrayS[indexPath.row])"
              cell.catLabelS.text = "| \(catArrayS[indexPath.row])"
              cell.timeLabelS.text = "\(dateArrayS[indexPath.row])"
            SwiftSpinner.hide()
            return cell
            
        }
      override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
               return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
                   let sharewithtwitter = UIAction(title: "Share with Twitter", image: #imageLiteral(resourceName: "twitter")) { action in
                       print("Sharing")
                    UIApplication.shared.open(URL(string:"https://twitter.com/intent/tweet?text=Check%20out%20this%20Article!&hashtags=CSCI_571_NewsApp&url=\(self.urlArrayS[indexPath.row])")! as URL, options:[:], completionHandler: nil)
                   }
                
                let bookmark = UIAction(title: "Bookmark", image: UIImage(systemName: "bookmark")) { action in
                     print("Sharing")
                    let cell = tableView.cellForRow(at: indexPath) as! ResultsTableViewCell
                if (self.initialbutstateS[indexPath.row] == 1){
                         self.navigationController?.view.hideAllToasts()
                    self.initialbutstateS[indexPath.row] = 0
                    self.valuesformemS.removeAll {$0 == self.idArrayS[indexPath.row]}
                    self.defaultsS.set(0, forKey: "butstate\(self.idArrayS[indexPath.row])")
                    self.defaultsS.set(self.valuesformemS, forKey: "valuesarray")
                        self.navigationController?.view.makeToast("Article Removed From Bookmark")
                    }
                    else {
                        self.navigationController?.view.hideAllToasts()
                    self.initialbutstateS[indexPath.row] = 1
                    if (self.valuesformemS.contains(self.idArrayS[indexPath.row]) == false){
                        self.valuesformemS.append(self.idArrayS[indexPath.row])
                        }
                        //sets defaults for the butstate, image (either url or ""), title, date, cat, and general values array.
                    self.defaultsS.set(1, forKey: "butstate\(self.idArrayS[indexPath.row])")
                    if self.picArrayS[indexPath.row] != ""{
                        self.defaultsS.set(self.picArrayS[indexPath.row], forKey: "image\(self.idArrayS[indexPath.row])")
                                   }
                                   else{
                        self.defaultsS.set("", forKey: "image\(self.idArrayS[indexPath.row])")
                                   }
                    self.defaultsS.set(self.titleArrayS[indexPath.row], forKey: "title\(self.idArrayS[indexPath.row])")
                    self.defaultsS.set(self.datemod2ArrayS[indexPath.row], forKey: "date\(self.idArrayS[indexPath.row])")
                    self.defaultsS.set(self.catArrayS[indexPath.row], forKey: "cat\(self.idArrayS[indexPath.row])")
                    self.defaultsS.set(self.valuesformemS, forKey: "valuesarray")
                    self.defaultsS.set(self.urlArrayS[indexPath.row], forKey: "url\(self.idArrayS[indexPath.row])")
                        self.navigationController?.view.makeToast("Article Bookmarked. Check out the Bookmarks tab to view")
                    }

               // print(self.initialbutstateS)
           //     print(self.defaultsS.string(forKey: "cat\(self.idArrayS[indexPath.row])"))

                    if (self.initialbutstateS[indexPath.row] == 0)
                {
                    cell.bookmarkButImageS.setImage(UIImage(systemName: "bookmark"), for: .normal)
                }
                    else if (self.initialbutstateS[indexPath.row] == 1)
                {
                    cell.bookmarkButImageS.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
                }

                 }
                   return UIMenu(title: "Menu", children: [sharewithtwitter, bookmark])
               }
        }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          currenttitleS = titleArrayS[indexPath.row]
          currentidtosendS = idArrayS[indexPath.row]
          performSegue(withIdentifier: "showDetailS", sender: nil)
      }
      
      override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if let viewController = segue.destination as?
              DetailedViewController{
              viewController.detailedtitle = currenttitleS
              viewController.detailedid = currentidtosendS
          }
      }

}
