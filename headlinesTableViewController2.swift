import UIKit
import XLPagerTabStrip
import Alamofire
import SDWebImage
import SwiftyJSON
import SwiftSpinner

import Toast_Swift

class headlinesTableViewController2: UITableViewController, IndicatorInfoProvider {
    var currentid2 = "default"
    var titleArray2 = [String]()
    var currenttitle2: String = ""
    var currentidtosend2: String = ""
    var catArray2 = [String]()
    var dateArray2 = [String]()
    var picArray2 = [String]()
    var idArray2 = [String]()
    var firstload2 = false


    var initialbutstate2 = [Int]()
    var valuesformem2 = [String]()
    var datemod2Array2 = [String] ()
    var urlArray2 = [String]()
    let defaults2 = UserDefaults.standard
  

    func callbacktothis2(cell: headlinesTableViewCell2){
     //   print(self.datemod2Array2)
        let indexPathTapped = tableView.indexPath(for: cell)
       // print(indexPathTapped!.row)
       // cell.bookmarkButImage.isSelected = true
       // print(idArray2[indexPathTapped!.row])
        if (initialbutstate2[indexPathTapped!.row] == 1){
             self.navigationController?.view.hideAllToasts()
            initialbutstate2[indexPathTapped!.row] = 0
            valuesformem2.removeAll {$0 == idArray2[indexPathTapped!.row]}
            defaults2.set(0, forKey: "butstate\(idArray2[indexPathTapped!.row])")
            defaults2.set(valuesformem2, forKey: "valuesarray")
            self.navigationController?.view.makeToast("Article Removed From Bookmark")

        }
        else {
            self.navigationController?.view.hideAllToasts()
            initialbutstate2[indexPathTapped!.row] = 1
            if (valuesformem2.contains(idArray2[indexPathTapped!.row]) == false){
             valuesformem2.append(idArray2[indexPathTapped!.row])
            }
            //sets defaults for the butstate, image (either url or ""), title, date, cat, and general values array.
            defaults2.set(1, forKey: "butstate\(idArray2[indexPathTapped!.row])")
            if picArray2[indexPathTapped!.row] != ""{
                defaults2.set(picArray2[indexPathTapped!.row], forKey: "image\(idArray2[indexPathTapped!.row])")
                       }
                       else{
                defaults2.set("", forKey: "image\(idArray2[indexPathTapped!.row])")
                       }
            defaults2.set(titleArray2[indexPathTapped!.row], forKey: "title\(idArray2[indexPathTapped!.row])")
            defaults2.set(datemod2Array2[indexPathTapped!.row], forKey: "date\(idArray2[indexPathTapped!.row])")
            defaults2.set(catArray2[indexPathTapped!.row], forKey: "cat\(idArray2[indexPathTapped!.row])")
            defaults2.set(urlArray2[indexPathTapped!.row], forKey: "url\(idArray2[indexPathTapped!.row])")
            defaults2.set(valuesformem2, forKey: "valuesarray")
            self.navigationController?.view.makeToast("Article Bookmarked. Check out the Bookmarks tab to view")


            
        }

     //   initialbutstate = 1;
     //       print(initialbutstate2)
     //   print(defaults2.string(forKey: "cat\(idArray2[indexPathTapped!.row])"))
     //   print(defaults2.stringArray(forKey: "valuesarray"))
    //    print("def val is: \(defaults.string(forKey: "title\(idArray[indexPathTapped!.row])")!)")
       // self.tableView.reloadSections([1], with: .none)
        
        if (initialbutstate2[indexPathTapped!.row] == 0)
        {
            cell.bookmarkButImage2.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
        else if (initialbutstate2[indexPathTapped!.row] == 1)
        {
            cell.bookmarkButImage2.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        }
        
        
        
      //  print(cell.)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("headlines 2 here")
    //this sets valuesformem to whatever is in the memory.
    if(defaults2.stringArray(forKey: "valuesarray") != nil){
     valuesformem2 = defaults2.stringArray(forKey: "valuesarray")!
    }
        SwiftSpinner.show("Loading BUSINESS Headlines..")
                loadhomeCards()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if !firstload2{
               print("Headlines2 Appeared ")
             if(defaults2.stringArray(forKey: "valuesarray") != nil){
              valuesformem2 = defaults2.stringArray(forKey: "valuesarray")!
             }
                    // self.titleArray = ["test"]
            
                      SwiftSpinner.show("Loading BUSINESS Headlines..")
                      loadhomeCards()
                     // loadhomeCards()
           }
           firstload2 = false

    }
    @IBAction func refreshIt2(_ sender: UIRefreshControl) {
        //loadhomeCards()
        print("refreshing 2")
        SwiftSpinner.show("Loading BUSINESS Headlines..")
        loadhomeCards()
        sender.endRefreshing()
     //   self.tableView.reloadData()
    }

    func loadhomeCards()
       {
           Alamofire.request("BackendRouteRetracted2onbusiness").responseJSON{
               (myresponse) in
               
               switch myresponse.result{
               case .success:
                
                   let myresult = try? JSON(data:myresponse.data!)
                   
                   //clears array if refreshed.
                   self.titleArray2.removeAll()
                   self.catArray2.removeAll()
                   self.dateArray2.removeAll()
                   self.picArray2.removeAll()
                   self.idArray2.removeAll()
                   
                   self.initialbutstate2.removeAll()
                   self.datemod2Array2.removeAll()
                   self.urlArray2.removeAll()
                   
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
                       self.idArray2.append(id)

                        var weburl2 = i["webUrl"].stringValue
                    
                    //error for no url
                    if (weburl2 == ""){
                    weburl2 = "http://www.guardian.co.uk/404"
                                       }
                        self.urlArray2.append(weburl2)
                       //print("id is: \(id)")
                       //print("this is: \(thumbnail)")
                     //  self.picArray1.append(thumbnail)
                      // print("this is: \(self.picArray1)")
                       
                       let testingpic = i["blocks"]["main"]["elements"][0]["assets"].arrayValue
                       let testingpicindex = testingpic.endIndex
                       if testingpic.count != 0{
                       self.picArray2.append(testingpic[testingpicindex-1]["file"].stringValue)
                       }
                       else{
                           self.picArray2.append("")
                       }

                //       print ("picarray \(self.picArray2)")
                       
                       //print("\(webTitle)")
                       self.titleArray2.append(webTitle)
                       self.catArray2.append(sectionName)
                       let dateFormat = ISO8601DateFormatter()
                       let date = dateFormat.date(from:webPublicationDate)!
                    //   print("This is reformatted date from thingy: \(date)")
                    
                         let dateformater2 = DateFormatter()
                         dateformater2.locale = Locale(identifier:"en_GB")
                         dateformater2.setLocalizedDateFormatFromTemplate("ddMMMYYYY")
                    // print("This2 is reformatted date from thingy: \(dateformater2.string(from:date))")
                     self.datemod2Array2.append(dateformater2.string(from:date))
                    
                    
                       let difhours = Calendar.current.dateComponents([.hour], from: date, to: Date()).hour!
                       let difmins = Calendar.current.dateComponents([.minute], from: date, to: Date()).minute!
                       let difsecs = Calendar.current.dateComponents([.second], from: date, to: Date()).second!
                       if difhours >= 1{
                           print("diffhours: \(difhours)h ago")
                           self.dateArray2.append("\(difhours)h ago")
                       }
                       else if difhours < 1 && difmins >= 1{
                           print("diffmins: \(difmins)m ago")
                           self.dateArray2.append("\(difmins)m ago")
                       }
                       else if difhours < 1 && difmins < 1 {
                           print("diffsecs: \(difsecs)s ago")
                           self.dateArray2.append("\(difsecs)s ago")
                       }
                       else {
                           print("diff happen now")
                           self.dateArray2.append("d ago")
                       }
                    
                    self.initialbutstate2.append(self.defaults2.integer(forKey: "butstate\(id)"))

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
        return titleArray2.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "buisinesscell", for: indexPath) as! headlinesTableViewCell2

        // print("\(titleArray)")
        
        cell.link2 = self
        //initially when the app is open, load the state of the but
        if (initialbutstate2[indexPath.row] == 0)
        {
            cell.bookmarkButImage2.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
        else if (initialbutstate2[indexPath.row] == 1)
        {
            cell.bookmarkButImage2.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        }

        
             if picArray2[indexPath.row] != ""{

               cell.newsPictureLabel2.sd_setImage(with: URL(string: picArray2[indexPath.row]), placeholderImage: UIImage(named: "default-guardian"))
               
             }
             else{
                 cell.newsPictureLabel2.image = #imageLiteral(resourceName: "default-guardian")
             }
             cell.labelTextOf2.text = "\(titleArray2[indexPath.row])"
             cell.catLabel2.text = "| \(catArray2[indexPath.row])"
             cell.timeLabel2.text = "\(dateArray2[indexPath.row])"
         //  SwiftSpinner.hide()
           return cell
    }
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "BUSINESS")
    }
        override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {

               return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in

                   let sharewithtwitter = UIAction(title: "Share with Twitter", image: #imageLiteral(resourceName: "twitter")) { action in
                       print("Sharing")
                    UIApplication.shared.open(URL(string:"https://twitter.com/intent/tweet?text=Check%20out%20this%20Article!&hashtags=CSCI_571_NewsApp&url=\(self.urlArray2[indexPath.row])")! as URL, options:[:], completionHandler: nil)
                   }
                
                
                
                let bookmark = UIAction(title: "Bookmark", image: UIImage(systemName: "bookmark")) { action in
                     print("Sharing")
                    let cell = tableView.cellForRow(at: indexPath) as! headlinesTableViewCell2
                    
                if (self.initialbutstate2[indexPath.row] == 1){
                         self.navigationController?.view.hideAllToasts()
                    self.initialbutstate2[indexPath.row] = 0
                    self.valuesformem2.removeAll {$0 == self.idArray2[indexPath.row]}
                    self.defaults2.set(0, forKey: "butstate\(self.idArray2[indexPath.row])")
                    self.defaults2.set(self.valuesformem2, forKey: "valuesarray")
                        self.navigationController?.view.makeToast("Article Removed From Bookmark")

                    }
                    else {
                        self.navigationController?.view.hideAllToasts()
                    self.initialbutstate2[indexPath.row] = 1
                    if (self.valuesformem2.contains(self.idArray2[indexPath.row]) == false){
                        self.valuesformem2.append(self.idArray2[indexPath.row])
                        }
                        //sets defaults for the butstate, image (either url or ""), title, date, cat, and general values array.
                    self.defaults2.set(1, forKey: "butstate\(self.idArray2[indexPath.row])")
                    if self.picArray2[indexPath.row] != ""{
                        self.defaults2.set(self.picArray2[indexPath.row], forKey: "image\(self.idArray2[indexPath.row])")
                                   }
                                   else{
                        self.defaults2.set("", forKey: "image\(self.idArray2[indexPath.row])")
                                   }
                    self.defaults2.set(self.titleArray2[indexPath.row], forKey: "title\(self.idArray2[indexPath.row])")
                    self.defaults2.set(self.datemod2Array2[indexPath.row], forKey: "date\(self.idArray2[indexPath.row])")
                    self.defaults2.set(self.catArray2[indexPath.row], forKey: "cat\(self.idArray2[indexPath.row])")
                    self.defaults2.set(self.urlArray2[indexPath.row], forKey: "url\(self.idArray2[indexPath.row])")
                    self.defaults2.set(self.valuesformem2, forKey: "valuesarray")
                        self.navigationController?.view.makeToast("Article Bookmarked. Check out the Bookmarks tab to view")

                        
                    }
                 //   initialbutstate = 1;
            //    print(self.initialbutstate2)
            //    print(self.defaults2.string(forKey: "cat\(self.idArray2[indexPath.row])"))

                   
                    if (self.initialbutstate2[indexPath.row] == 0)
                {
                    cell.bookmarkButImage2.setImage(UIImage(systemName: "bookmark"), for: .normal)
                }
                    else if (self.initialbutstate2[indexPath.row] == 1)
                {
                    cell.bookmarkButImage2.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
                }
                
                
                

                 }
              //  self.tableView.reloadSections([1], with: .none)
                   return UIMenu(title: "Menu", children: [sharewithtwitter, bookmark])
               }
        }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currenttitle2 = titleArray2[indexPath.row]
        currentidtosend2 = idArray2[indexPath.row]
        performSegue(withIdentifier: "showDetail2", sender: nil)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as?
            DetailedViewController{
            viewController.detailedtitle = currenttitle2
            viewController.detailedid = currentidtosend2
        }
    }
    

}

