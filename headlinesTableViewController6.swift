import UIKit
import XLPagerTabStrip
import Alamofire
import SDWebImage
import SwiftyJSON
import SwiftSpinner
import Toast_Swift

class headlinesTableViewController6: UITableViewController, IndicatorInfoProvider {
    var currentid6 = "default"
     var titleArray6 = [String]()
     var currenttitle6: String = ""
     var currentidtosend6: String = ""
     var catArray6 = [String]()
     var dateArray6 = [String]()
     var picArray6 = [String]()
     var idArray6 = [String]()
     var firstload6 = false
       var initialbutstate6 = [Int]()
       var valuesformem6 = [String]()
       var datemod2Array6 = [String] ()
       var urlArray6 = [String]()
       let defaults6 = UserDefaults.standard
    
    func callbacktothis6(cell: headlinesTableViewCell6){
    //    print(self.datemod2Array6)
        let indexPathTapped = tableView.indexPath(for: cell)
      //  print(indexPathTapped!.row)
       // cell.bookmarkButImage.isSelected = true
       // print(idArray6[indexPathTapped!.row])
        if (initialbutstate6[indexPathTapped!.row] == 1){
             self.navigationController?.view.hideAllToasts()
            initialbutstate6[indexPathTapped!.row] = 0
            valuesformem6.removeAll {$0 == idArray6[indexPathTapped!.row]}
            defaults6.set(0, forKey: "butstate\(idArray6[indexPathTapped!.row])")
            defaults6.set(valuesformem6, forKey: "valuesarray")
            self.navigationController?.view.makeToast("Article Removed From Bookmark")

        }
        else {
            self.navigationController?.view.hideAllToasts()
            initialbutstate6[indexPathTapped!.row] = 1
            if (valuesformem6.contains(idArray6[indexPathTapped!.row]) == false){
             valuesformem6.append(idArray6[indexPathTapped!.row])
            }
            //sets defaults for the butstate, image (either url or ""), title, date, cat, and general values array.
            defaults6.set(1, forKey: "butstate\(idArray6[indexPathTapped!.row])")
            if picArray6[indexPathTapped!.row] != ""{
                defaults6.set(picArray6[indexPathTapped!.row], forKey: "image\(idArray6[indexPathTapped!.row])")
                       }
                       else{
                defaults6.set("", forKey: "image\(idArray6[indexPathTapped!.row])")
                       }
            defaults6.set(titleArray6[indexPathTapped!.row], forKey: "title\(idArray6[indexPathTapped!.row])")
            defaults6.set(datemod2Array6[indexPathTapped!.row], forKey: "date\(idArray6[indexPathTapped!.row])")
            defaults6.set(catArray6[indexPathTapped!.row], forKey: "cat\(idArray6[indexPathTapped!.row])")
            defaults6.set(urlArray6[indexPathTapped!.row], forKey: "url\(idArray6[indexPathTapped!.row])")
            defaults6.set(valuesformem6, forKey: "valuesarray")
            self.navigationController?.view.makeToast("Article Bookmarked. Check out the Bookmarks tab to view")


            
        }
        //cell.bookmarkButImage.setImage(#imageLiteral(resourceName: "trending-up"), for: .normal)
     //   initialbutstate = 1;
     //       print(initialbutstate6)
     //   print(defaults6.string(forKey: "cat\(idArray6[indexPathTapped!.row])"))
     //   print(defaults6.stringArray(forKey: "valuesarray"))
    //    print("def val is: \(defaults.string(forKey: "title\(idArray[indexPathTapped!.row])")!)")
       // self.tableView.reloadSections([1], with: .none)
        
        if (initialbutstate6[indexPathTapped!.row] == 0)
        {
            cell.bookmarkButImage6.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
        else if (initialbutstate6[indexPathTapped!.row] == 1)
        {
            cell.bookmarkButImage6.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        }
        
        
        
      //  print(cell.)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("headlines 6 here")
   
                        if(defaults6.stringArray(forKey: "valuesarray") != nil){
                         valuesformem6 = defaults6.stringArray(forKey: "valuesarray")!
                        }
                
                
                
          SwiftSpinner.show("Loading SCIENCE Headlines..")
                  loadhomeCards()
          

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         if !firstload6{
       //       print("Headlines6 Appeared ")
            if(defaults6.stringArray(forKey: "valuesarray") != nil){
             valuesformem6 = defaults6.stringArray(forKey: "valuesarray")!
            }
                    // self.titleArray = ["test"]
                     
                     SwiftSpinner.show("Loading SCIENCE Headlines..")
                     loadhomeCards()
                    // loadhomeCards()
          }
          firstload6 = false


    }
    @IBAction func refreshIt6(_ sender: UIRefreshControl) {
        //loadhomeCards()
  //      print("refreshing 6")
        SwiftSpinner.show("Loading SCIENCE Headlines..")
        loadhomeCards()
        sender.endRefreshing()
     //   self.tableView.reloadData()
    }

       func loadhomeCards()
       {
           Alamofire.request("BackendRouteRetracted2onscience").responseJSON{
               (myresponse) in
               
               switch myresponse.result{
               case .success:
                
                   let myresult = try? JSON(data:myresponse.data!)
                   
                   //clears array if refreshed.
                   self.titleArray6.removeAll()
                   self.catArray6.removeAll()
                   self.dateArray6.removeAll()
                   self.picArray6.removeAll()
                   self.idArray6.removeAll()
                   self.initialbutstate6.removeAll()
                   self.datemod2Array6.removeAll()
                   self.urlArray6.removeAll()
                   
                   for i in myresult!["response"]["results"].arrayValue{
                       let webTitle = i["webTitle"].stringValue
                    //   print("title is: \(webTitle)")
                       let sectionName = i["sectionName"].stringValue
                       var webPublicationDate = i["webPublicationDate"].stringValue
                    if (webPublicationDate == "" ){
                        webPublicationDate = "2020-05-07T08:00:18Z"
                    }
                       //let thumbnail = i["fields"]["thumbnail"].stringValue
                       let id = i["id"].stringValue
                       self.idArray6.append(id)

                     var weburl6 = i["webUrl"].stringValue

                    //error for no url
                    if (weburl6 == ""){
                        weburl6 = "http://www.guardian.co.uk/404"
                    }

                    
                                    self.urlArray6.append(weburl6)
                       //print("id is: \(id)")
                       //print("this is: \(thumbnail)")
                     //  self.picArray1.append(thumbnail)
                      // print("this is: \(self.picArray1)")
                       
                       let testingpic = i["blocks"]["main"]["elements"][0]["assets"].arrayValue
                       let testingpicindex = testingpic.endIndex
                       if testingpic.count != 0{
                       self.picArray6.append(testingpic[testingpicindex-1]["file"].stringValue)
                       }
                       else{
                           self.picArray6.append("")
                       }

                  //     print ("picarray \(self.picArray6)")
                       
                       //print("\(webTitle)")
                       self.titleArray6.append(webTitle)
                       self.catArray6.append(sectionName)
                       let dateFormat = ISO8601DateFormatter()
                       let date = dateFormat.date(from:webPublicationDate)!
                    //   print("This is reformatted date from thingy: \(date)")

                         let dateformater2 = DateFormatter()
                         dateformater2.locale = Locale(identifier:"en_GB")
                         dateformater2.setLocalizedDateFormatFromTemplate("ddMMMYYYY")
                    // print("This2 is reformatted date from thingy: \(dateformater2.string(from:date))")
                     self.datemod2Array6.append(dateformater2.string(from:date))
                    
                    
                       let difhours = Calendar.current.dateComponents([.hour], from: date, to: Date()).hour!
                       let difmins = Calendar.current.dateComponents([.minute], from: date, to: Date()).minute!
                       let difsecs = Calendar.current.dateComponents([.second], from: date, to: Date()).second!
                       if difhours >= 1{
                           print("diffhours: \(difhours)h ago")
                           self.dateArray6.append("\(difhours)h ago")
                       }
                       else if difhours < 1 && difmins >= 1{
                           print("diffmins: \(difmins)m ago")
                           self.dateArray6.append("\(difmins)m ago")
                       }
                       else if difhours < 1 && difmins < 1 {
                           print("diffsecs: \(difsecs)s ago")
                           self.dateArray6.append("\(difsecs)s ago")
                       }
                       else {
                           print("diff happen now")
                           self.dateArray6.append("d ago")
                       }

                    self.initialbutstate6.append(self.defaults6.integer(forKey: "butstate\(id)"))
                    

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
        return  titleArray6.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sciencecell", for: indexPath) as! headlinesTableViewCell6

        cell.link6 = self
        //initially when the app is open, load the state of the but
        if (initialbutstate6[indexPath.row] == 0)
        {
            cell.bookmarkButImage6.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
        else if (initialbutstate6[indexPath.row] == 1)
        {
            cell.bookmarkButImage6.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        }
        
        
        
        

               if picArray6[indexPath.row] != ""{
                 


                 
                 cell.newsPictureLabel6.sd_setImage(with: URL(string: picArray6[indexPath.row]), placeholderImage: UIImage(named: "default-guardian"))
                 
               }
               else{
                   cell.newsPictureLabel6.image = #imageLiteral(resourceName: "default-guardian")
               }
               cell.labelTextOf6.text = "\(titleArray6[indexPath.row])"
               cell.catLabel6.text = "| \(catArray6[indexPath.row])"
               cell.timeLabel6.text = "\(dateArray6[indexPath.row])"
          //   SwiftSpinner.hide()
             return cell
    }
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "SCIENCE")
    }
   
        override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {

               return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in

                   let sharewithtwitter = UIAction(title: "Share with Twitter", image: #imageLiteral(resourceName: "twitter")) { action in
                       print("Sharing")
                    UIApplication.shared.open(URL(string:"https://twitter.com/intent/tweet?text=Check%20out%20this%20Article!&hashtags=CSCI_571_NewsApp&url=\(self.urlArray6[indexPath.row])")! as URL, options:[:], completionHandler: nil)
                   }
                
                
                
                let bookmark = UIAction(title: "Bookmark", image: UIImage(systemName: "bookmark")) { action in
                     print("Sharing")

                    let cell = tableView.cellForRow(at: indexPath) as! headlinesTableViewCell6
                    
                if (self.initialbutstate6[indexPath.row] == 1){
                         self.navigationController?.view.hideAllToasts()
                    self.initialbutstate6[indexPath.row] = 0
                    self.valuesformem6.removeAll {$0 == self.idArray6[indexPath.row]}
                    self.defaults6.set(0, forKey: "butstate\(self.idArray6[indexPath.row])")
                    self.defaults6.set(self.valuesformem6, forKey: "valuesarray")
                        self.navigationController?.view.makeToast("Article Removed From Bookmark")

                    }
                    else {
                        self.navigationController?.view.hideAllToasts()
                    self.initialbutstate6[indexPath.row] = 1
                    if (self.valuesformem6.contains(self.idArray6[indexPath.row]) == false){
                        self.valuesformem6.append(self.idArray6[indexPath.row])
                        }
                        //sets defaults for the butstate, image (either url or ""), title, date, cat, and general values array.
                    self.defaults6.set(1, forKey: "butstate\(self.idArray6[indexPath.row])")
                    if self.picArray6[indexPath.row] != ""{
                        self.defaults6.set(self.picArray6[indexPath.row], forKey: "image\(self.idArray6[indexPath.row])")
                                   }
                                   else{
                        self.defaults6.set("", forKey: "image\(self.idArray6[indexPath.row])")
                                   }
                    self.defaults6.set(self.titleArray6[indexPath.row], forKey: "title\(self.idArray6[indexPath.row])")
                    self.defaults6.set(self.datemod2Array6[indexPath.row], forKey: "date\(self.idArray6[indexPath.row])")
                    self.defaults6.set(self.catArray6[indexPath.row], forKey: "cat\(self.idArray6[indexPath.row])")
                    self.defaults6.set(self.urlArray6[indexPath.row], forKey: "url\(self.idArray6[indexPath.row])")
                    self.defaults6.set(self.valuesformem6, forKey: "valuesarray")
                        self.navigationController?.view.makeToast("Article Bookmarked. Check out the Bookmarks tab to view")

                        
                    }
                    //cell.bookmarkButImage.setImage(#imageLiteral(resourceName: "trending-up"), for: .normal)
                 //   initialbutstate = 1;
        //        print(self.initialbutstate6)
         //       print(self.defaults6.string(forKey: "cat\(self.idArray6[indexPath.row])"))

                   
                    if (self.initialbutstate6[indexPath.row] == 0)
                {
                    cell.bookmarkButImage6.setImage(UIImage(systemName: "bookmark"), for: .normal)
                }
                    else if (self.initialbutstate6[indexPath.row] == 1)
                {
                    cell.bookmarkButImage6.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
                }
                
                
                

                 }
              //  self.tableView.reloadSections([1], with: .none)
                   return UIMenu(title: "Menu", children: [sharewithtwitter, bookmark])
               }
        }

   

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currenttitle6 = titleArray6[indexPath.row]
        currentidtosend6 = idArray6[indexPath.row]
        performSegue(withIdentifier: "showDetail6", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let viewController = segue.destination as?
            DetailedViewController{
            viewController.detailedtitle = currenttitle6
            viewController.detailedid = currentidtosend6
        }
    }
    

}
