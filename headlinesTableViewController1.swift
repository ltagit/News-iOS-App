import UIKit
import XLPagerTabStrip
import Alamofire
import SDWebImage
import SwiftyJSON
import SwiftSpinner
import Toast_Swift

class headlinesTableViewController1: UITableViewController, IndicatorInfoProvider {
    var currentid1 = "default"
    var titleArray1 = [String]()
    var currenttitle1: String = ""
    var currentidtosend1: String = ""
    var catArray1 = [String]()
    var dateArray1 = [String]()
    var picArray1 = [String]()
    var idArray1 = [String]()
    var firstload1 = false
    var initialbutstate1 = [Int]()
    var valuesformem1 = [String]()
    var datemod2Array1 = [String] ()
    var urlArray1 = [String]()
    let defaults1 = UserDefaults.standard
     

        func callbacktothis1(cell: headlinesTableViewCell1){
            //print(self.datemod2Array1)
            let indexPathTapped = tableView.indexPath(for: cell)
          //  print(indexPathTapped!.row)
           // cell.bookmarkButImage.isSelected = true
           // print(idArray1[indexPathTapped!.row])
            if (initialbutstate1[indexPathTapped!.row] == 1){
                 self.navigationController?.view.hideAllToasts()
                initialbutstate1[indexPathTapped!.row] = 0
                valuesformem1.removeAll {$0 == idArray1[indexPathTapped!.row]}
                defaults1.set(0, forKey: "butstate\(idArray1[indexPathTapped!.row])")
                defaults1.set(valuesformem1, forKey: "valuesarray")
                self.navigationController?.view.makeToast("Article Removed From Bookmark")

            }
            else {
                self.navigationController?.view.hideAllToasts()
                initialbutstate1[indexPathTapped!.row] = 1
                if (valuesformem1.contains(idArray1[indexPathTapped!.row]) == false){
                 valuesformem1.append(idArray1[indexPathTapped!.row])
                }
                //sets defaults for the butstate, image (either url or ""), title, date, cat, and general values array.
                defaults1.set(1, forKey: "butstate\(idArray1[indexPathTapped!.row])")
                if picArray1[indexPathTapped!.row] != ""{
                    defaults1.set(picArray1[indexPathTapped!.row], forKey: "image\(idArray1[indexPathTapped!.row])")
                           }
                           else{
                    defaults1.set("", forKey: "image\(idArray1[indexPathTapped!.row])")
                           }
                defaults1.set(titleArray1[indexPathTapped!.row], forKey: "title\(idArray1[indexPathTapped!.row])")
                defaults1.set(datemod2Array1[indexPathTapped!.row], forKey: "date\(idArray1[indexPathTapped!.row])")
                defaults1.set(catArray1[indexPathTapped!.row], forKey: "cat\(idArray1[indexPathTapped!.row])")
                defaults1.set(urlArray1[indexPathTapped!.row], forKey: "url\(idArray1[indexPathTapped!.row])")
                defaults1.set(valuesformem1, forKey: "valuesarray")
                self.navigationController?.view.makeToast("Article Bookmarked. Check out the Bookmarks tab to view")


                
            }
            //cell.bookmarkButImage.setImage(#imageLiteral(resourceName: "trending-up"), for: .normal)
         //   initialbutstate = 1;
          //      print(initialbutstate1)
         //   print(defaults1.string(forKey: "cat\(idArray1[indexPathTapped!.row])"))
         //   print(defaults1.stringArray(forKey: "valuesarray"))
        //    print("def val is: \(defaults.string(forKey: "title\(idArray[indexPathTapped!.row])")!)")
           // self.tableView.reloadSections([1], with: .none)
            
            if (initialbutstate1[indexPathTapped!.row] == 0)
            {
                cell.bookmarkButImage1.setImage(UIImage(systemName: "bookmark"), for: .normal)
            }
            else if (initialbutstate1[indexPathTapped!.row] == 1)
            {
                cell.bookmarkButImage1.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            }
            
            
        }
        
    override func viewDidLoad() {
        super.viewDidLoad()
      //  print("headlines 1 here")

                if(defaults1.stringArray(forKey: "valuesarray") != nil){
                 valuesformem1 = defaults1.stringArray(forKey: "valuesarray")!
                }

        
        SwiftSpinner.show("Loading WORLD Headlines..")
                loadhomeCards()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //this updates each time the page is loaded.
        if !firstload1{
         //    print("Headlines1 Appeared ")
            if(defaults1.stringArray(forKey: "valuesarray") != nil){
             valuesformem1 = defaults1.stringArray(forKey: "valuesarray")!
            }
                   // self.titleArray = ["test"]
                    
                    SwiftSpinner.show("Loading WORLD Headlines..")
                    loadhomeCards()
           // tableView.reloadData()
            
            
                   // loadhomeCards()
         }
         firstload1 = false
        

    }
    @IBAction func refreshIt1(_ sender: UIRefreshControl) {
        SwiftSpinner.show("Loading WORLD Headlines..")
        loadhomeCards()
        sender.endRefreshing()
     //   self.tableView.reloadData()
    }

    
    func loadhomeCards()
    {
        Alamofire.request("BackendRouteRetracted2onworld").responseJSON{
            (myresponse) in
            
            switch myresponse.result{
            case .success:
             
                let myresult = try? JSON(data:myresponse.data!)
                
                //clears array if refreshed.
                self.titleArray1.removeAll()
                self.catArray1.removeAll()
                self.dateArray1.removeAll()
                self.picArray1.removeAll()
                self.idArray1.removeAll()
                self.initialbutstate1.removeAll()
                self.datemod2Array1.removeAll()
                self.urlArray1.removeAll()
                
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
                    self.idArray1.append(id)
                    var weburl1 = i["webUrl"].stringValue
                    //error for no url
                    if (weburl1 == ""){
                    weburl1 = "http://www.guardian.co.uk/404"
                                        }
                    self.urlArray1.append(weburl1)
                    //print("id is: \(id)")
                    //print("this is: \(thumbnail)")
                  //  self.picArray1.append(thumbnail)
                   // print("this is: \(self.picArray1)")
                    
                    let testingpic = i["blocks"]["main"]["elements"][0]["assets"].arrayValue
                    let testingpicindex = testingpic.endIndex
                    if testingpic.count != 0{
                    self.picArray1.append(testingpic[testingpicindex-1]["file"].stringValue)
                    }
                    else{
                        self.picArray1.append("")
                    }

                 //   print ("picarray \(self.picArray1)")
                    
                    //print("\(webTitle)")
                    self.titleArray1.append(webTitle)
                    self.catArray1.append(sectionName)
                    let dateFormat = ISO8601DateFormatter()
                    let date = dateFormat.date(from:webPublicationDate)!
             //       print("This is reformatted date from thingy: \(date)")

                         let dateformater2 = DateFormatter()
                         dateformater2.locale = Locale(identifier:"en_GB")
                         dateformater2.setLocalizedDateFormatFromTemplate("ddMMMYYYY")
                    // print("This2 is reformatted date from thingy: \(dateformater2.string(from:date))")
                     self.datemod2Array1.append(dateformater2.string(from:date))
                    
                    
                    let difhours = Calendar.current.dateComponents([.hour], from: date, to: Date()).hour!
                    let difmins = Calendar.current.dateComponents([.minute], from: date, to: Date()).minute!
                    let difsecs = Calendar.current.dateComponents([.second], from: date, to: Date()).second!
                    if difhours >= 1{
                        print("diffhours: \(difhours)h ago")
                        self.dateArray1.append("\(difhours)h ago")
                    }
                    else if difhours < 1 && difmins >= 1{
                        print("diffmins: \(difmins)m ago")
                        self.dateArray1.append("\(difmins)m ago")
                    }
                    else if difhours < 1 && difmins < 1 {
                        print("diffsecs: \(difsecs)s ago")
                        self.dateArray1.append("\(difsecs)s ago")
                    }
                    else {
                        print("diff happen now")
                        self.dateArray1.append("d ago")
                    }
                    

                    self.initialbutstate1.append(self.defaults1.integer(forKey: "butstate\(id)"))
                    
                    

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
        return titleArray1.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "worldcell", for: indexPath) as! headlinesTableViewCell1
        

        cell.link1 = self
        //initially when the app is open, load the state of the but
        if (initialbutstate1[indexPath.row] == 0)
        {
            cell.bookmarkButImage1.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
        else if (initialbutstate1[indexPath.row] == 1)
        {
            cell.bookmarkButImage1.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        }

          if picArray1[indexPath.row] != ""{
            
            cell.newsPictureLabel1.sd_setImage(with: URL(string: picArray1[indexPath.row]), placeholderImage: UIImage(named: "default-guardian"))
            
          }
          else{
              cell.newsPictureLabel1.image = #imageLiteral(resourceName: "default-guardian")
          }
          cell.labelTextOf1.text = "\(titleArray1[indexPath.row])"
          cell.catLabel1.text = "| \(catArray1[indexPath.row])"
          cell.timeLabel1.text = "\(dateArray1[indexPath.row])"
       // SwiftSpinner.hide()
        return cell
        
    }
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "WORLD")
    }
    
    
//needtoadd
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {

           return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in

               let sharewithtwitter = UIAction(title: "Share with Twitter", image: #imageLiteral(resourceName: "twitter")) { action in
                   print("Sharing")
                UIApplication.shared.open(URL(string:"https://twitter.com/intent/tweet?text=Check%20out%20this%20Article!&hashtags=CSCI_571_NewsApp&url=\(self.urlArray1[indexPath.row])")! as URL, options:[:], completionHandler: nil)
               }
            

            let bookmark = UIAction(title: "Bookmark", image: UIImage(systemName: "bookmark")) { action in
                 print("Sharing")
                let cell = tableView.cellForRow(at: indexPath) as! headlinesTableViewCell1
                
            if (self.initialbutstate1[indexPath.row] == 1){
                     self.navigationController?.view.hideAllToasts()
                self.initialbutstate1[indexPath.row] = 0
                self.valuesformem1.removeAll {$0 == self.idArray1[indexPath.row]}
                self.defaults1.set(0, forKey: "butstate\(self.idArray1[indexPath.row])")
                self.defaults1.set(self.valuesformem1, forKey: "valuesarray")
                    self.navigationController?.view.makeToast("Article Removed From Bookmark")

                }
                else {
                    self.navigationController?.view.hideAllToasts()
                self.initialbutstate1[indexPath.row] = 1
                if (self.valuesformem1.contains(self.idArray1[indexPath.row]) == false){
                    self.valuesformem1.append(self.idArray1[indexPath.row])
                    }
                    //sets defaults for the butstate, image (either url or ""), title, date, cat, and general values array.
                self.defaults1.set(1, forKey: "butstate\(self.idArray1[indexPath.row])")
                if self.picArray1[indexPath.row] != ""{
                    self.defaults1.set(self.picArray1[indexPath.row], forKey: "image\(self.idArray1[indexPath.row])")
                               }
                               else{
                    self.defaults1.set("", forKey: "image\(self.idArray1[indexPath.row])")
                               }
                self.defaults1.set(self.titleArray1[indexPath.row], forKey: "title\(self.idArray1[indexPath.row])")
                self.defaults1.set(self.datemod2Array1[indexPath.row], forKey: "date\(self.idArray1[indexPath.row])")
                self.defaults1.set(self.catArray1[indexPath.row], forKey: "cat\(self.idArray1[indexPath.row])")
                self.defaults1.set(self.urlArray1[indexPath.row], forKey: "url\(self.idArray1[indexPath.row])")
                self.defaults1.set(self.valuesformem1, forKey: "valuesarray")
                    self.navigationController?.view.makeToast("Article Bookmarked. Check out the Bookmarks tab to view")

                    
                }
                //cell.bookmarkButImage.setImage(#imageLiteral(resourceName: "trending-up"), for: .normal)
             //   initialbutstate = 1;
       //     print(self.initialbutstate1)
        //    print(self.defaults1.string(forKey: "cat\(self.idArray1[indexPath.row])"))

               
                if (self.initialbutstate1[indexPath.row] == 0)
            {
                cell.bookmarkButImage1.setImage(UIImage(systemName: "bookmark"), for: .normal)
            }
                else if (self.initialbutstate1[indexPath.row] == 1)
            {
                cell.bookmarkButImage1.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            }
            
            
            

             }

               return UIMenu(title: "Menu", children: [sharewithtwitter, bookmark])
           }
    }


       override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           currenttitle1 = titleArray1[indexPath.row]
           currentidtosend1 = idArray1[indexPath.row]

           performSegue(withIdentifier: "showDetail1", sender: nil)
       }
       
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

           if let viewController = segue.destination as?
               DetailedViewController{
               viewController.detailedtitle = currenttitle1
               viewController.detailedid = currentidtosend1
           }
       }
       

}

