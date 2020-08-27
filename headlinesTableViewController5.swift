import UIKit
import XLPagerTabStrip
import Alamofire
import SDWebImage
import SwiftyJSON
import SwiftSpinner
import Toast_Swift

class headlinesTableViewController5: UITableViewController, IndicatorInfoProvider {
    var currentid5 = "default"
    var titleArray5 = [String]()
    var currenttitle5: String = ""
    var currentidtosend5: String = ""
    var catArray5 = [String]()
    var dateArray5 = [String]()
    var picArray5 = [String]()
    var idArray5 = [String]()
    var firstload5 = false
    var initialbutstate5 = [Int]()
    var valuesformem5 = [String]()
    var datemod2Array5 = [String] ()
    var urlArray5 = [String]()
    let defaults5 = UserDefaults.standard

     func callbacktothis5(cell: headlinesTableViewCell5){
    //     print(self.datemod2Array5)
         let indexPathTapped = tableView.indexPath(for: cell)
     //    print(indexPathTapped!.row)
        // cell.bookmarkButImage.isSelected = true
        // print(idArray5[indexPathTapped!.row])
         if (initialbutstate5[indexPathTapped!.row] == 1){
              self.navigationController?.view.hideAllToasts()
             initialbutstate5[indexPathTapped!.row] = 0
             valuesformem5.removeAll {$0 == idArray5[indexPathTapped!.row]}
             defaults5.set(0, forKey: "butstate\(idArray5[indexPathTapped!.row])")
             defaults5.set(urlArray5[indexPathTapped!.row], forKey: "url\(idArray5[indexPathTapped!.row])")
             defaults5.set(valuesformem5, forKey: "valuesarray")
             self.navigationController?.view.makeToast("Article Removed From Bookmark")

         }
         else {
             self.navigationController?.view.hideAllToasts()
             initialbutstate5[indexPathTapped!.row] = 1
             if (valuesformem5.contains(idArray5[indexPathTapped!.row]) == false){
              valuesformem5.append(idArray5[indexPathTapped!.row])
             }
             //sets defaults for the butstate, image (either url or ""), title, date, cat, and general values array.
             defaults5.set(1, forKey: "butstate\(idArray5[indexPathTapped!.row])")
             if picArray5[indexPathTapped!.row] != ""{
                 defaults5.set(picArray5[indexPathTapped!.row], forKey: "image\(idArray5[indexPathTapped!.row])")
                        }
                        else{
                 defaults5.set("", forKey: "image\(idArray5[indexPathTapped!.row])")
                        }
             defaults5.set(titleArray5[indexPathTapped!.row], forKey: "title\(idArray5[indexPathTapped!.row])")
             defaults5.set(datemod2Array5[indexPathTapped!.row], forKey: "date\(idArray5[indexPathTapped!.row])")
             defaults5.set(catArray5[indexPathTapped!.row], forKey: "cat\(idArray5[indexPathTapped!.row])")
             defaults5.set(valuesformem5, forKey: "valuesarray")
             self.navigationController?.view.makeToast("Article Bookmarked. Check out the Bookmarks tab to view")


             
         }
         //cell.bookmarkButImage.setImage(#imageLiteral(resourceName: "trending-up"), for: .normal)
      //   initialbutstate = 1;
        //     print(initialbutstate5)
     //    print(defaults5.string(forKey: "cat\(idArray5[indexPathTapped!.row])"))
        // print(defaults5.stringArray(forKey: "valuesarray"))
     //    print("def val is: \(defaults.string(forKey: "title\(idArray[indexPathTapped!.row])")!)")
        // self.tableView.reloadSections([1], with: .none)
         
         if (initialbutstate5[indexPathTapped!.row] == 0)
         {
             cell.bookmarkButImage5.setImage(UIImage(systemName: "bookmark"), for: .normal)
         }
         else if (initialbutstate5[indexPathTapped!.row] == 1)
         {
             cell.bookmarkButImage5.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
         }
         
         
         
       //  print(cell.)
         
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("headlines 5 here")
 
                        //this sets valuesformem to whatever is in the memory.
                        if(defaults5.stringArray(forKey: "valuesarray") != nil){
                         valuesformem5 = defaults5.stringArray(forKey: "valuesarray")!
                        }
        
           SwiftSpinner.show("Loading TECHNOLOGY Headlines..")
                   loadhomeCards()
           
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //this updates each time the page is loaded.
        if !firstload5{
      //       print("Headlines5 Appeared ")
            if(defaults5.stringArray(forKey: "valuesarray") != nil){
             valuesformem5 = defaults5.stringArray(forKey: "valuesarray")!
            }
                   // self.titleArray = ["test"]
                    
                    SwiftSpinner.show("Loading TECHNOLOGY Headlines..")
                    loadhomeCards()
                   // loadhomeCards()
         }
         firstload5 = false

    }
    @IBAction func refreshIt5(_ sender: UIRefreshControl) {
        //loadhomeCards()
   //     print("refreshing 5")
        SwiftSpinner.show("Loading TECHNOLOGY Headlines..")
        loadhomeCards()
        sender.endRefreshing()
     //   self.tableView.reloadData()
    }

    func loadhomeCards()
    {
        Alamofire.request("BackendRouteRetracted2ontechnology").responseJSON{
            (myresponse) in
            
            switch myresponse.result{
            case .success:
             
                let myresult = try? JSON(data:myresponse.data!)
                
                //clears array if refreshed.
                self.titleArray5.removeAll()
                self.catArray5.removeAll()
                self.dateArray5.removeAll()
                self.picArray5.removeAll()
                self.idArray5.removeAll()
                self.initialbutstate5.removeAll()
                self.datemod2Array5.removeAll()
                self.urlArray5.removeAll()
                
                
                for i in myresult!["response"]["results"].arrayValue{
                    let webTitle = i["webTitle"].stringValue
              //      print("title is: \(webTitle)")
                    let sectionName = i["sectionName"].stringValue
                    var webPublicationDate = i["webPublicationDate"].stringValue
                    if (webPublicationDate == "" ){
                        webPublicationDate = "2020-05-07T08:00:18Z"
                    }
                    //let thumbnail = i["fields"]["thumbnail"].stringValue
                    let id = i["id"].stringValue
                    self.idArray5.append(id)
                    var weburl5 = i["webUrl"].stringValue
                    //error for no url
                    if (weburl5 == ""){
                        weburl5 = "http://www.guardian.co.uk/404"
                    }
                     self.urlArray5.append(weburl5)
                    //print("id is: \(id)")
                    //print("this is: \(thumbnail)")
                  //  self.picArray1.append(thumbnail)
                   // print("this is: \(self.picArray1)")
                    
                    let testingpic = i["blocks"]["main"]["elements"][0]["assets"].arrayValue
                    let testingpicindex = testingpic.endIndex
                    if testingpic.count != 0{
                    self.picArray5.append(testingpic[testingpicindex-1]["file"].stringValue)
                    }
                    else{
                        self.picArray5.append("")
                    }

                  //  print ("picarray \(self.picArray5)")
                    
                    //print("\(webTitle)")
                    self.titleArray5.append(webTitle)
                    self.catArray5.append(sectionName)
                    let dateFormat = ISO8601DateFormatter()
                    let date = dateFormat.date(from:webPublicationDate)!
                  //  print("This is reformatted date from thingy: \(date)")
                         let dateformater2 = DateFormatter()
                         dateformater2.locale = Locale(identifier:"en_GB")
                         dateformater2.setLocalizedDateFormatFromTemplate("ddMMMYYYY")
                    // print("This2 is reformatted date from thingy: \(dateformater2.string(from:date))")
                     self.datemod2Array5.append(dateformater2.string(from:date))
                    
                    
                    let difhours = Calendar.current.dateComponents([.hour], from: date, to: Date()).hour!
                    let difmins = Calendar.current.dateComponents([.minute], from: date, to: Date()).minute!
                    let difsecs = Calendar.current.dateComponents([.second], from: date, to: Date()).second!
                    if difhours >= 1{
                        print("diffhours: \(difhours)h ago")
                        self.dateArray5.append("\(difhours)h ago")
                    }
                    else if difhours < 1 && difmins >= 1{
                        print("diffmins: \(difmins)m ago")
                        self.dateArray5.append("\(difmins)m ago")
                    }
                    else if difhours < 1 && difmins < 1 {
                        print("diffsecs: \(difsecs)s ago")
                        self.dateArray5.append("\(difsecs)s ago")
                    }
                    else {
                        print("diff happen now")
                        self.dateArray5.append("d ago")
                    }

                    self.initialbutstate5.append(self.defaults5.integer(forKey: "butstate\(id)"))
                    
                    
                }
           //     print(myresult!["response"]["results"][0].description)
            
                  //self.tableView.reloadData()
                self.tableView.reloadSections([0], with: .none)
                SwiftSpinner.hide()
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
        return titleArray5.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "technologycell", for: indexPath) as! headlinesTableViewCell5

        cell.link5 = self
        //initially when the app is open, load the state of the but
        if (initialbutstate5[indexPath.row] == 0)
        {
            cell.bookmarkButImage5.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
        else if (initialbutstate5[indexPath.row] == 1)
        {
            cell.bookmarkButImage5.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        }
        
        
            if picArray5[indexPath.row] != ""{

              cell.newsPictureLabel5.sd_setImage(with: URL(string: picArray5[indexPath.row]), placeholderImage: UIImage(named: "default-guardian"))
              
            }
            else{
                cell.newsPictureLabel5.image = #imageLiteral(resourceName: "default-guardian")
            }
            cell.labelTextOf5.text = "\(titleArray5[indexPath.row])"
            cell.catLabel5.text = "| \(catArray5[indexPath.row])"
            cell.timeLabel5.text = "\(dateArray5[indexPath.row])"
        //  SwiftSpinner.hide()
          return cell
          
    }
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "TECHNOLOGY")
    }
 
        override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {

               return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in

                   let sharewithtwitter = UIAction(title: "Share with Twitter", image: #imageLiteral(resourceName: "twitter")) { action in
                       print("Sharing")
                    UIApplication.shared.open(URL(string:"https://twitter.com/intent/tweet?text=Check%20out%20this%20Article!&hashtags=CSCI_571_NewsApp&url=\(self.urlArray5[indexPath.row])")! as URL, options:[:], completionHandler: nil)
                   }
                
                
                
                let bookmark = UIAction(title: "Bookmark", image: UIImage(systemName: "bookmark")) { action in
                     print("Sharing")
                    let cell = tableView.cellForRow(at: indexPath) as! headlinesTableViewCell5
                    
                if (self.initialbutstate5[indexPath.row] == 1){
                         self.navigationController?.view.hideAllToasts()
                    self.initialbutstate5[indexPath.row] = 0
                    self.valuesformem5.removeAll {$0 == self.idArray5[indexPath.row]}
                    self.defaults5.set(0, forKey: "butstate\(self.idArray5[indexPath.row])")
                    self.defaults5.set(self.valuesformem5, forKey: "valuesarray")
                        self.navigationController?.view.makeToast("Article Removed From Bookmark")

                    }
                    else {
                        self.navigationController?.view.hideAllToasts()
                    self.initialbutstate5[indexPath.row] = 1
                    if (self.valuesformem5.contains(self.idArray5[indexPath.row]) == false){
                        self.valuesformem5.append(self.idArray5[indexPath.row])
                        }
                        //sets defaults for the butstate, image (either url or ""), title, date, cat, and general values array.
                    self.defaults5.set(1, forKey: "butstate\(self.idArray5[indexPath.row])")
                    if self.picArray5[indexPath.row] != ""{
                        self.defaults5.set(self.picArray5[indexPath.row], forKey: "image\(self.idArray5[indexPath.row])")
                                   }
                                   else{
                        self.defaults5.set("", forKey: "image\(self.idArray5[indexPath.row])")
                                   }
                    self.defaults5.set(self.titleArray5[indexPath.row], forKey: "title\(self.idArray5[indexPath.row])")
                    self.defaults5.set(self.datemod2Array5[indexPath.row], forKey: "date\(self.idArray5[indexPath.row])")
                    self.defaults5.set(self.catArray5[indexPath.row], forKey: "cat\(self.idArray5[indexPath.row])")
                    self.defaults5.set(self.urlArray5[indexPath.row], forKey: "url\(self.idArray5[indexPath.row])")
                    self.defaults5.set(self.valuesformem5, forKey: "valuesarray")
                        self.navigationController?.view.makeToast("Article Bookmarked. Check out the Bookmarks tab to view")

                        
                    }
                    //cell.bookmarkButImage.setImage(#imageLiteral(resourceName: "trending-up"), for: .normal)
                 //   initialbutstate = 1;
          //      print(self.initialbutstate5)
           //     print(self.defaults5.string(forKey: "cat\(self.idArray5[indexPath.row])"))

                   
                    if (self.initialbutstate5[indexPath.row] == 0)
                {
                    cell.bookmarkButImage5.setImage(UIImage(systemName: "bookmark"), for: .normal)
                }
                    else if (self.initialbutstate5[indexPath.row] == 1)
                {
                    cell.bookmarkButImage5.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
                }
                
                
                

                 }

                   return UIMenu(title: "Menu", children: [sharewithtwitter, bookmark])
               }
        }



        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            currenttitle5 = titleArray5[indexPath.row]
            currentidtosend5 = idArray5[indexPath.row]
            performSegue(withIdentifier: "showDetail5", sender: nil)
        }
        

        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if let viewController = segue.destination as?
                DetailedViewController{
                viewController.detailedtitle = currenttitle5
                viewController.detailedid = currentidtosend5
            }
        }
        

}
