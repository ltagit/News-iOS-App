import UIKit
import XLPagerTabStrip
import Alamofire
import SDWebImage
import SwiftyJSON
import SwiftSpinner
import Toast_Swift

class headlinesTableViewController3: UITableViewController, IndicatorInfoProvider {
    var currentid3 = "default"
    var titleArray3 = [String]()
    var currenttitle3: String = ""
    var currentidtosend3: String = ""
    var catArray3 = [String]()
    var dateArray3 = [String]()
    var picArray3 = [String]()
    var idArray3 = [String]()
    var firstload3 = false
    

    var initialbutstate3 = [Int]()
    var valuesformem3 = [String]()
    var datemod2Array3 = [String] ()
    var urlArray3 = [String]()
    let defaults3 = UserDefaults.standard


    func callbacktothis3(cell: headlinesTableViewCell3){
      //  print(self.datemod2Array3)
        let indexPathTapped = tableView.indexPath(for: cell)
      //  print(indexPathTapped!.row)
       // cell.bookmarkButImage.isSelected = true
      //  print(idArray3[indexPathTapped!.row])
        if (initialbutstate3[indexPathTapped!.row] == 1){
             self.navigationController?.view.hideAllToasts()
            initialbutstate3[indexPathTapped!.row] = 0
            valuesformem3.removeAll {$0 == idArray3[indexPathTapped!.row]}
            defaults3.set(0, forKey: "butstate\(idArray3[indexPathTapped!.row])")
            defaults3.set(valuesformem3, forKey: "valuesarray")
            self.navigationController?.view.makeToast("Article Removed From Bookmark")

        }
        else {
            self.navigationController?.view.hideAllToasts()
            initialbutstate3[indexPathTapped!.row] = 1
            if (valuesformem3.contains(idArray3[indexPathTapped!.row]) == false){
             valuesformem3.append(idArray3[indexPathTapped!.row])
            }
            //sets defaults for the butstate, image (either url or ""), title, date, cat, and general values array.
            defaults3.set(1, forKey: "butstate\(idArray3[indexPathTapped!.row])")
            if picArray3[indexPathTapped!.row] != ""{
                defaults3.set(picArray3[indexPathTapped!.row], forKey: "image\(idArray3[indexPathTapped!.row])")
                       }
                       else{
                defaults3.set("", forKey: "image\(idArray3[indexPathTapped!.row])")
                       }
            defaults3.set(titleArray3[indexPathTapped!.row], forKey: "title\(idArray3[indexPathTapped!.row])")
            defaults3.set(datemod2Array3[indexPathTapped!.row], forKey: "date\(idArray3[indexPathTapped!.row])")
            defaults3.set(catArray3[indexPathTapped!.row], forKey: "cat\(idArray3[indexPathTapped!.row])")
            defaults3.set(urlArray3[indexPathTapped!.row], forKey: "url\(idArray3[indexPathTapped!.row])")
            defaults3.set(valuesformem3, forKey: "valuesarray")
            self.navigationController?.view.makeToast("Article Bookmarked. Check out the Bookmarks tab to view")


            
        }
        //cell.bookmarkButImage.setImage(#imageLiteral(resourceName: "trending-up"), for: .normal)
     //   initialbutstate = 1;
     //       print(initialbutstate3)
     //   print(defaults3.string(forKey: "cat\(idArray3[indexPathTapped!.row])"))
     //   print(defaults3.stringArray(forKey: "valuesarray"))
    //    print("def val is: \(defaults.string(forKey: "title\(idArray[indexPathTapped!.row])")!)")
       // self.tableView.reloadSections([1], with: .none)
        
        if (initialbutstate3[indexPathTapped!.row] == 0)
        {
            cell.bookmarkButImage3.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
        else if (initialbutstate3[indexPathTapped!.row] == 1)
        {
            cell.bookmarkButImage3.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        }
        
        
        
      //  print(cell.)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("headlines 3 here")
  
                        //this sets valuesformem to whatever is in the memory.
                        if(defaults3.stringArray(forKey: "valuesarray") != nil){
                         valuesformem3 = defaults3.stringArray(forKey: "valuesarray")!
                        }
                
        SwiftSpinner.show("Loading POLITICS Headlines..")
                  loadhomeCards()
          
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        if !firstload3{
        //       print("Headlines3 Appeared ")
            if(defaults3.stringArray(forKey: "valuesarray") != nil){
             valuesformem3 = defaults3.stringArray(forKey: "valuesarray")!
            }
                   // self.titleArray = ["test"]
                     // self.titleArray = ["test"]
                      SwiftSpinner.show("Loading POLITICS Headlines..")
                      loadhomeCards()
                     // loadhomeCards()
           }
           firstload3 = false

    }
    @IBAction func refreshIt3(_ sender: UIRefreshControl) {
        //loadhomeCards()
        print("refreshing 3")
        SwiftSpinner.show("Loading POLITICS Headlines..")
        loadhomeCards()
        sender.endRefreshing()
     //   self.tableView.reloadData()
    }

       func loadhomeCards()
       {
           Alamofire.request("BackendRouteRetracted2onpolitics").responseJSON{
               (myresponse) in
               
               switch myresponse.result{
               case .success:
                
                   let myresult = try? JSON(data:myresponse.data!)
                   
                   //clears array if refreshed.
                   self.titleArray3.removeAll()
                   self.catArray3.removeAll()
                   self.dateArray3.removeAll()
                   self.picArray3.removeAll()
                   self.idArray3.removeAll()
                  self.initialbutstate3.removeAll()
                  self.datemod2Array3.removeAll()
                self.urlArray3.removeAll()
                                   
                   
                   for i in myresult!["response"]["results"].arrayValue{
                       let webTitle = i["webTitle"].stringValue
           //            print("title is: \(webTitle)")
                       let sectionName = i["sectionName"].stringValue
                       var webPublicationDate = i["webPublicationDate"].stringValue
                    if (webPublicationDate == "" ){
                        webPublicationDate = "2020-05-07T08:00:18Z"
                    }
                       //let thumbnail = i["fields"]["thumbnail"].stringValue
                       let id = i["id"].stringValue
                       self.idArray3.append(id)
                     var weburl3 = i["webUrl"].stringValue
                    //error for no url
                    if (weburl3 == ""){
                    weburl3 = "http://www.guardian.co.uk/404"
                                        }

                     self.urlArray3.append(weburl3)
                                       //print("id is: \(id)")
                                       //print("this is: \(thumbnail)")
                                     //  self.picArray1.append(thumbnail)
                                      // print("this is: \(self.picArray1)")
                                       
                       
                       let testingpic = i["blocks"]["main"]["elements"][0]["assets"].arrayValue
                       let testingpicindex = testingpic.endIndex
                       if testingpic.count != 0{
                       self.picArray3.append(testingpic[testingpicindex-1]["file"].stringValue)
                       }
                       else{
                           self.picArray3.append("")
                       }

                    //   print ("picarray \(self.picArray3)")
                       
                       //print("\(webTitle)")
                       self.titleArray3.append(webTitle)
                       self.catArray3.append(sectionName)
                       let dateFormat = ISO8601DateFormatter()
                       let date = dateFormat.date(from:webPublicationDate)!
                    //   print("This is reformatted date from thingy: \(date)")
                    
                         let dateformater2 = DateFormatter()
                         dateformater2.locale = Locale(identifier:"en_GB")
                         dateformater2.setLocalizedDateFormatFromTemplate("ddMMMYYYY")
                    // print("This2 is reformatted date from thingy: \(dateformater2.string(from:date))")
                     self.datemod2Array3.append(dateformater2.string(from:date))
                    
                    
                    
                       let difhours = Calendar.current.dateComponents([.hour], from: date, to: Date()).hour!
                       let difmins = Calendar.current.dateComponents([.minute], from: date, to: Date()).minute!
                       let difsecs = Calendar.current.dateComponents([.second], from: date, to: Date()).second!
                       if difhours >= 1{
                           print("diffhours: \(difhours)h ago")
                           self.dateArray3.append("\(difhours)h ago")
                       }
                       else if difhours < 1 && difmins >= 1{
                           print("diffmins: \(difmins)m ago")
                           self.dateArray3.append("\(difmins)m ago")
                       }
                       else if difhours < 1 && difmins < 1 {
                           print("diffsecs: \(difsecs)s ago")
                           self.dateArray3.append("\(difsecs)s ago")
                       }
                       else {
                           print("diff happen now")
                           self.dateArray3.append("d ago")
                       }

                    self.initialbutstate3.append(self.defaults3.integer(forKey: "butstate\(id)"))
                    
                    

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
        return titleArray3.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "politicscell", for: indexPath) as! headlinesTableViewCell3

        cell.link3 = self
        //initially when the app is open, load the state of the but
        if (initialbutstate3[indexPath.row] == 0)
        {
            cell.bookmarkButImage3.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
        else if (initialbutstate3[indexPath.row] == 1)
        {
            cell.bookmarkButImage3.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        }
        
        
        
              if picArray3[indexPath.row] != ""{
                


                
                cell.newsPictureLabel3.sd_setImage(with: URL(string: picArray3[indexPath.row]), placeholderImage: UIImage(named: "default-guardian"))
                
              }
              else{
                  cell.newsPictureLabel3.image = #imageLiteral(resourceName: "default-guardian")
              }
              cell.labelTextOf3.text = "\(titleArray3[indexPath.row])"
              cell.catLabel3.text = "| \(catArray3[indexPath.row])"
              cell.timeLabel3.text = "\(dateArray3[indexPath.row])"
           // SwiftSpinner.hide()
            return cell
            
    }
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "POLITICS")
    }
        override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {

               return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in

                   let sharewithtwitter = UIAction(title: "Share with Twitter", image: #imageLiteral(resourceName: "twitter")) { action in
                       print("Sharing")
                    UIApplication.shared.open(URL(string:"https://twitter.com/intent/tweet?text=Check%20out%20this%20Article!&hashtags=CSCI_571_NewsApp&url=\(self.urlArray3[indexPath.row])")! as URL, options:[:], completionHandler: nil)
                   }
                
                
                
                let bookmark = UIAction(title: "Bookmark", image: UIImage(systemName: "bookmark")) { action in
                     print("Sharing")
                    let cell = tableView.cellForRow(at: indexPath) as! headlinesTableViewCell3
                    
                if (self.initialbutstate3[indexPath.row] == 1){
                         self.navigationController?.view.hideAllToasts()
                    self.initialbutstate3[indexPath.row] = 0
                    self.valuesformem3.removeAll {$0 == self.idArray3[indexPath.row]}
                    self.defaults3.set(0, forKey: "butstate\(self.idArray3[indexPath.row])")
                    self.defaults3.set(self.valuesformem3, forKey: "valuesarray")
                        self.navigationController?.view.makeToast("Article Removed From Bookmark")

                    }
                    else {
                        self.navigationController?.view.hideAllToasts()
                    self.initialbutstate3[indexPath.row] = 1
                    if (self.valuesformem3.contains(self.idArray3[indexPath.row]) == false){
                        self.valuesformem3.append(self.idArray3[indexPath.row])
                        }
                        //sets defaults for the butstate, image (either url or ""), title, date, cat, and general values array.
                    self.defaults3.set(1, forKey: "butstate\(self.idArray3[indexPath.row])")
                    if self.picArray3[indexPath.row] != ""{
                        self.defaults3.set(self.picArray3[indexPath.row], forKey: "image\(self.idArray3[indexPath.row])")
                                   }
                                   else{
                        self.defaults3.set("", forKey: "image\(self.idArray3[indexPath.row])")
                                   }
                    self.defaults3.set(self.titleArray3[indexPath.row], forKey: "title\(self.idArray3[indexPath.row])")
                    self.defaults3.set(self.datemod2Array3[indexPath.row], forKey: "date\(self.idArray3[indexPath.row])")
                    self.defaults3.set(self.catArray3[indexPath.row], forKey: "cat\(self.idArray3[indexPath.row])")
                    self.defaults3.set(self.urlArray3[indexPath.row], forKey: "url\(self.idArray3[indexPath.row])")
                    self.defaults3.set(self.valuesformem3, forKey: "valuesarray")
                        self.navigationController?.view.makeToast("Article Bookmarked. Check out the Bookmarks tab to view")

                        
                    }

             //   print(self.initialbutstate3)
             //   print(self.defaults3.string(forKey: "cat\(self.idArray3[indexPath.row])"))

                   
                    if (self.initialbutstate3[indexPath.row] == 0)
                {
                    cell.bookmarkButImage3.setImage(UIImage(systemName: "bookmark"), for: .normal)
                }
                    else if (self.initialbutstate3[indexPath.row] == 1)
                {
                    cell.bookmarkButImage3.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
                }
                
                
                

                 }
              //  self.tableView.reloadSections([1], with: .none)
                   return UIMenu(title: "Menu", children: [sharewithtwitter, bookmark])
               }
        }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currenttitle3 = titleArray3[indexPath.row]
        currentidtosend3 = idArray3[indexPath.row]
        performSegue(withIdentifier: "showDetail3", sender: nil)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as?
            DetailedViewController{
            viewController.detailedtitle = currenttitle3
            viewController.detailedid = currentidtosend3
        }
    }
}
