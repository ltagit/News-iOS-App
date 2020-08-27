import UIKit
import XLPagerTabStrip
import Alamofire
import SDWebImage
import SwiftyJSON
import SwiftSpinner
import Toast_Swift

class headlinesTableViewController4: UITableViewController, IndicatorInfoProvider {
    var currentid4 = "default"
    var titleArray4 = [String]()
    var currenttitle4: String = ""
    var currentidtosend4: String = ""
    var catArray4 = [String]()
    var dateArray4 = [String]()
    var picArray4 = [String]()
    var idArray4 = [String]()
    var firstload4 = false
    var initialbutstate4 = [Int]()
    var valuesformem4 = [String]()
    var datemod2Array4 = [String] ()
    var urlArray4 = [String]()
    let defaults4 = UserDefaults.standard
    func callbacktothis4(cell: headlinesTableViewCell4){
      //  print(self.datemod2Array4)
        let indexPathTapped = tableView.indexPath(for: cell)
       // print(indexPathTapped!.row)
       // cell.bookmarkButImage.isSelected = true
      //  print(idArray4[indexPathTapped!.row])
        if (initialbutstate4[indexPathTapped!.row] == 1){
             self.navigationController?.view.hideAllToasts()
            initialbutstate4[indexPathTapped!.row] = 0
            valuesformem4.removeAll {$0 == idArray4[indexPathTapped!.row]}
            defaults4.set(0, forKey: "butstate\(idArray4[indexPathTapped!.row])")
            defaults4.set(valuesformem4, forKey: "valuesarray")
            self.navigationController?.view.makeToast("Article Removed From Bookmark")

        }
        else {
            self.navigationController?.view.hideAllToasts()
            initialbutstate4[indexPathTapped!.row] = 1
            if (valuesformem4.contains(idArray4[indexPathTapped!.row]) == false){
             valuesformem4.append(idArray4[indexPathTapped!.row])
            }
            //sets defaults for the butstate, image (either url or ""), title, date, cat, and general values array.
            defaults4.set(1, forKey: "butstate\(idArray4[indexPathTapped!.row])")
            if picArray4[indexPathTapped!.row] != ""{
                defaults4.set(picArray4[indexPathTapped!.row], forKey: "image\(idArray4[indexPathTapped!.row])")
                       }
                       else{
                defaults4.set("", forKey: "image\(idArray4[indexPathTapped!.row])")
                       }
            defaults4.set(titleArray4[indexPathTapped!.row], forKey: "title\(idArray4[indexPathTapped!.row])")
            defaults4.set(datemod2Array4[indexPathTapped!.row], forKey: "date\(idArray4[indexPathTapped!.row])")
            defaults4.set(catArray4[indexPathTapped!.row], forKey: "cat\(idArray4[indexPathTapped!.row])")
            defaults4.set(urlArray4[indexPathTapped!.row], forKey: "url\(idArray4[indexPathTapped!.row])")
            defaults4.set(valuesformem4, forKey: "valuesarray")
            self.navigationController?.view.makeToast("Article Bookmarked. Check out the Bookmarks tab to view")


            
        }
        //cell.bookmarkButImage.setImage(#imageLiteral(resourceName: "trending-up"), for: .normal)
     //   initialbutstate = 1;
        //    print(initialbutstate4)
     //   print(defaults4.string(forKey: "cat\(idArray4[indexPathTapped!.row])"))
      //  print(defaults4.stringArray(forKey: "valuesarray"))
    //    print("def val is: \(defaults.string(forKey: "title\(idArray[indexPathTapped!.row])")!)")
       // self.tableView.reloadSections([1], with: .none)
        
        if (initialbutstate4[indexPathTapped!.row] == 0)
        {
            cell.bookmarkButImage4.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
        else if (initialbutstate4[indexPathTapped!.row] == 1)
        {
            cell.bookmarkButImage4.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        }
        
        
        
      //  print(cell.)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("headlines 4 here")

                        //this sets valuesformem to whatever is in the memory.
                        if(defaults4.stringArray(forKey: "valuesarray") != nil){
                         valuesformem4 = defaults4.stringArray(forKey: "valuesarray")!
                        }
                
                
        SwiftSpinner.show("Loading SPORTS Headlines..")
                loadhomeCards()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !firstload4{
                print("Headlines4 Appeared ")
            //needtoadd
            if(defaults4.stringArray(forKey: "valuesarray") != nil){
             valuesformem4 = defaults4.stringArray(forKey: "valuesarray")!
            }
                      // self.titleArray = ["test"]
                       
                       SwiftSpinner.show("Loading SPORTS Headlines..")
                       loadhomeCards()
                      // loadhomeCards()
            }
            firstload4 = false


    }
    @IBAction func refreshIt4(_ sender: UIRefreshControl) {
        //loadhomeCards()
   //     print("refreshing 4")
        SwiftSpinner.show("Loading SPORTS Headlines..")
        loadhomeCards()
        sender.endRefreshing()
     //   self.tableView.reloadData()
    }
    
    func loadhomeCards()
    {
        Alamofire.request("BackendRouteRetracted2onsports").responseJSON{
            (myresponse) in
            
            switch myresponse.result{
            case .success:
             
                let myresult = try? JSON(data:myresponse.data!)
                
                //clears array if refreshed.
                self.titleArray4.removeAll()
                self.catArray4.removeAll()
                self.dateArray4.removeAll()
                self.picArray4.removeAll()
                self.idArray4.removeAll()
                
                self.initialbutstate4.removeAll()
                self.datemod2Array4.removeAll()
                self.urlArray4.removeAll()
                
                
                for i in myresult!["response"]["results"].arrayValue{
                    let webTitle = i["webTitle"].stringValue
                    print("title is: \(webTitle)")
                    let sectionName = i["sectionName"].stringValue
                    var webPublicationDate = i["webPublicationDate"].stringValue
                    if (webPublicationDate == "" ){
                          webPublicationDate = "2020-05-07T08:00:18Z"
                      }
                    
                    //let thumbnail = i["fields"]["thumbnail"].stringValue
                    let id = i["id"].stringValue
                    self.idArray4.append(id)
                    
                  var weburl4 = i["webUrl"].stringValue
                    //error for no url
                    if (weburl4 == ""){
                        weburl4 = "http://www.guardian.co.uk/404"
                         }

                  self.urlArray4.append(weburl4)
                                     //print("id is: \(id)")
                                     //print("this is: \(thumbnail)")
                                   //  self.picArray1.append(thumbnail)
                                    // print("this is: \(self.picArray1)")

                    
                    let testingpic = i["blocks"]["main"]["elements"][0]["assets"].arrayValue
                    let testingpicindex = testingpic.endIndex
                    if testingpic.count != 0{
                    self.picArray4.append(testingpic[testingpicindex-1]["file"].stringValue)
                    }
                    else{
                        self.picArray4.append("")
                    }

                   // print ("picarray \(self.picArray4)")
                    
                    //print("\(webTitle)")
                    self.titleArray4.append(webTitle)
                    self.catArray4.append(sectionName)
                    let dateFormat = ISO8601DateFormatter()
                    let date = dateFormat.date(from:webPublicationDate)!
                //    print("This is reformatted date from thingy: \(date)")
                    
                             let dateformater2 = DateFormatter()
                             dateformater2.locale = Locale(identifier:"en_GB")
                             dateformater2.setLocalizedDateFormatFromTemplate("ddMMMYYYY")
                        // print("This2 is reformatted date from thingy: \(dateformater2.string(from:date))")
                         self.datemod2Array4.append(dateformater2.string(from:date))
                        
                    
                    
                    let difhours = Calendar.current.dateComponents([.hour], from: date, to: Date()).hour!
                    let difmins = Calendar.current.dateComponents([.minute], from: date, to: Date()).minute!
                    let difsecs = Calendar.current.dateComponents([.second], from: date, to: Date()).second!
                    if difhours >= 1{
                        print("diffhours: \(difhours)h ago")
                        self.dateArray4.append("\(difhours)h ago")
                    }
                    else if difhours < 1 && difmins >= 1{
                        print("diffmins: \(difmins)m ago")
                        self.dateArray4.append("\(difmins)m ago")
                    }
                    else if difhours < 1 && difmins < 1 {
                        print("diffsecs: \(difsecs)s ago")
                        self.dateArray4.append("\(difsecs)s ago")
                    }
                    else {
                        print("diff happen now")
                        self.dateArray4.append("d ago")
                    }
                    self.initialbutstate4.append(self.defaults4.integer(forKey: "butstate\(id)"))
                    
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
        return titleArray4.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sportscell", for: indexPath) as! headlinesTableViewCell4

                // print("\(titleArray)")
                
                cell.link4 = self
                //initially when the app is open, load the state of the but
                if (initialbutstate4[indexPath.row] == 0)
                {
                    cell.bookmarkButImage4.setImage(UIImage(systemName: "bookmark"), for: .normal)
                }
                else if (initialbutstate4[indexPath.row] == 1)
                {
                    cell.bookmarkButImage4.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
                }
        
        if picArray4[indexPath.row] != ""{

                cell.newsPictureLabel4.sd_setImage(with: URL(string: picArray4[indexPath.row]), placeholderImage: UIImage(named: "default-guardian"))
                
              }
              else{
                  cell.newsPictureLabel4.image = #imageLiteral(resourceName: "default-guardian")
              }
              cell.labelTextOf4.text = "\(titleArray4[indexPath.row])"
              cell.catLabel4.text = "| \(catArray4[indexPath.row])"
              cell.timeLabel4.text = "\(dateArray4[indexPath.row])"
           // SwiftSpinner.hide()
            return cell
    }
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "SPORTS")
    }
        override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {

               return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in

                   let sharewithtwitter = UIAction(title: "Share with Twitter", image: #imageLiteral(resourceName: "twitter")) { action in
                       print("Sharing")
                    UIApplication.shared.open(URL(string:"https://twitter.com/intent/tweet?text=Check%20out%20this%20Article!&hashtags=CSCI_571_NewsApp&url=\(self.urlArray4[indexPath.row])")! as URL, options:[:], completionHandler: nil)
                   }
                
                
                
                let bookmark = UIAction(title: "Bookmark", image: UIImage(systemName: "bookmark")) { action in
                     print("Sharing")
                    let cell = tableView.cellForRow(at: indexPath) as! headlinesTableViewCell4
                    
                if (self.initialbutstate4[indexPath.row] == 1){
                         self.navigationController?.view.hideAllToasts()
                    self.initialbutstate4[indexPath.row] = 0
                    self.valuesformem4.removeAll {$0 == self.idArray4[indexPath.row]}
                    self.defaults4.set(0, forKey: "butstate\(self.idArray4[indexPath.row])")
                    self.defaults4.set(self.valuesformem4, forKey: "valuesarray")
                        self.navigationController?.view.makeToast("Article Removed From Bookmark")

                    }
                    else {
                        self.navigationController?.view.hideAllToasts()
                    self.initialbutstate4[indexPath.row] = 1
                    if (self.valuesformem4.contains(self.idArray4[indexPath.row]) == false){
                        self.valuesformem4.append(self.idArray4[indexPath.row])
                        }
                        //sets defaults for the butstate, image (either url or ""), title, date, cat, and general values array.
                    self.defaults4.set(1, forKey: "butstate\(self.idArray4[indexPath.row])")
                    if self.picArray4[indexPath.row] != ""{
                        self.defaults4.set(self.picArray4[indexPath.row], forKey: "image\(self.idArray4[indexPath.row])")
                                   }
                                   else{
                        self.defaults4.set("", forKey: "image\(self.idArray4[indexPath.row])")
                                   }
                    self.defaults4.set(self.titleArray4[indexPath.row], forKey: "title\(self.idArray4[indexPath.row])")
                    self.defaults4.set(self.datemod2Array4[indexPath.row], forKey: "date\(self.idArray4[indexPath.row])")
                    self.defaults4.set(self.catArray4[indexPath.row], forKey: "cat\(self.idArray4[indexPath.row])")
                    self.defaults4.set(self.urlArray4[indexPath.row], forKey: "url\(self.idArray4[indexPath.row])")
                    self.defaults4.set(self.valuesformem4, forKey: "valuesarray")
                        self.navigationController?.view.makeToast("Article Bookmarked. Check out the Bookmarks tab to view")

                        
                    }
                    //cell.bookmarkButImage.setImage(#imageLiteral(resourceName: "trending-up"), for: .normal)
                 //   initialbutstate = 1;
             //   print(self.initialbutstate4)
             //   print(self.defaults4.string(forKey: "cat\(self.idArray4[indexPath.row])"))

                   
                    if (self.initialbutstate4[indexPath.row] == 0)
                {
                    cell.bookmarkButImage4.setImage(UIImage(systemName: "bookmark"), for: .normal)
                }
                    else if (self.initialbutstate4[indexPath.row] == 1)
                {
                    cell.bookmarkButImage4.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
                }
                
                
                

                 }

                   return UIMenu(title: "Menu", children: [sharewithtwitter, bookmark])
               }
        }

          override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
              currenttitle4 = titleArray4[indexPath.row]
              currentidtosend4 = idArray4[indexPath.row]
              performSegue(withIdentifier: "showDetail4", sender: nil)
          }
          

          override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
              if let viewController = segue.destination as?
                  DetailedViewController{
                  viewController.detailedtitle = currenttitle4
                  viewController.detailedid = currentidtosend4
              }
          }
          

}
