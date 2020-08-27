import UIKit
import CoreLocation
import Alamofire
import SDWebImage
import SwiftyJSON
import SwiftSpinner
import Toast_Swift

class TableViewController: UITableViewController, SearchTableDelegate {

//This search method was utilized from https://medium.com/@mattkopacz/dealing-with-searchable-content-in-a-separate-table-view-e733822f73fe
    func whatlookingfor(selected searchterm: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let forsearchresultview = storyboard.instantiateViewController(identifier: "searchresultspage") as? ResultsTableViewController{
        forsearchresultview.resultstest = searchterm
        self.navigationController?.pushViewController(forsearchresultview, animated: true)
        }
    }
    
    var locationManager: CLLocationManager!
    var currentCity = "Null City"
    var currentState = "Null State"
    var currentTemp = "0"
    var currentCond = "NullCon"
    var currentid = "default"
    var titleArray = [String]()
    var currenttitle: String = ""
    var currentidtosend: String = ""
    var catArray = [String]()
    var dateArray = [String]()
    var picArray = [String]()
    var idArray = [String]()
    var initialbutstate = [Int]()
    var valuesformem = [String]()
    var datemod2Array = [String] ()
    var urlArray = [String]()
    let defaults = UserDefaults.standard
    var location: CLLocation?
    var isUpdationLocation = false
    var lastLocationError: Error?
    var firstload = false
    
    func callbacktothis(cell: TableViewCell){
      //  print(self.datemod2Array)
        let indexPathTapped = tableView.indexPath(for: cell)
        //print(indexPathTapped!.row)
       // cell.bookmarkButImage.isSelected = true
       // print(idArray[indexPathTapped!.row])
        if (initialbutstate[indexPathTapped!.row] == 1){
             self.navigationController?.view.hideAllToasts()
            initialbutstate[indexPathTapped!.row] = 0
            valuesformem.removeAll {$0 == idArray[indexPathTapped!.row]}
            defaults.set(0, forKey: "butstate\(idArray[indexPathTapped!.row])")
            defaults.set(valuesformem, forKey: "valuesarray")
            self.navigationController?.view.makeToast("Article Removed From Bookmark")
        }
        else {
            self.navigationController?.view.hideAllToasts()
            initialbutstate[indexPathTapped!.row] = 1
            if (valuesformem.contains(idArray[indexPathTapped!.row]) == false){
             valuesformem.append(idArray[indexPathTapped!.row])
            }
            //sets defaults for the butstate, image (either url or ""), title, date, cat, and general values array.
            defaults.set(1, forKey: "butstate\(idArray[indexPathTapped!.row])")
            if picArray[indexPathTapped!.row] != ""{
                defaults.set(picArray[indexPathTapped!.row], forKey: "image\(idArray[indexPathTapped!.row])")
                       }
                       else{
                defaults.set("", forKey: "image\(idArray[indexPathTapped!.row])")
                       }
            defaults.set(titleArray[indexPathTapped!.row], forKey: "title\(idArray[indexPathTapped!.row])")
            defaults.set(datemod2Array[indexPathTapped!.row], forKey: "date\(idArray[indexPathTapped!.row])")
            defaults.set(catArray[indexPathTapped!.row], forKey: "cat\(idArray[indexPathTapped!.row])")
            defaults.set(urlArray[indexPathTapped!.row], forKey: "url\(idArray[indexPathTapped!.row])")
            defaults.set(valuesformem, forKey: "valuesarray")
            self.navigationController?.view.makeToast("Article Bookmarked. Check out the Bookmarks tab to view")

            
        }
     //   initialbutstate = 1;
     //    print("TEST321 ids: \(defaults.stringArray(forKey: "valuesarray"))  savedimg: \(defaults.string(forKey: "image\(idArray[indexPathTapped!.row])")) savedtitle: \(defaults.string(forKey: "title\(idArray[indexPathTapped!.row])")) saveddate: \(defaults.string(forKey: "date\(idArray[indexPathTapped!.row])"))  savedcat: \(defaults.string(forKey: "cat\(idArray[indexPathTapped!.row])"))        ")
          //  print(initialbutstate)
        //print(defaults.string(forKey: "cat\(idArray[indexPathTapped!.row])"))
        //print(defaults.stringArray(forKey: "valuesarray"))
    //    print("def val is: \(defaults.string(forKey: "title\(idArray[indexPathTapped!.row])")!)")
       // self.tableView.reloadSections([1], with: .none)
        
        if (initialbutstate[indexPathTapped!.row] == 0)
        {
            cell.bookmarkButImage.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
        else if (initialbutstate[indexPathTapped!.row] == 1)
        {
            cell.bookmarkButImage.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        }
        
    }
    

var resultController: UISearchController?
private var resultTableController: SearchTableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstload = true
        

        //this sets valuesformem to whatever is in the memory.
        if(defaults.stringArray(forKey: "valuesarray") != nil){
         valuesformem = defaults.stringArray(forKey: "valuesarray")!
        }
        else if(defaults.stringArray(forKey: "valuesarray") == nil){
            valuesformem = []
            defaults.set(valuesformem, forKey: "valuesarray")
        }

//This search method was utilized from https://medium.com/@mattkopacz/dealing-with-searchable-content-in-a-separate-table-view-e733822f73fe
        
        resultTableController = (storyboard?.instantiateViewController(identifier: "SearchTest") as! SearchTableViewController)
        resultTableController.delegate = self
        resultController = UISearchController(searchResultsController: resultTableController)
        resultController?.searchResultsUpdater = resultTableController
        navigationItem.searchController = resultController
        navigationItem.searchController?.searchBar.placeholder = "Enter keyword.."
        resultController?.obscuresBackgroundDuringPresentation = true
        definesPresentationContext = false
        SwiftSpinner.show("Loading Home Page..")
        weatherupdate()
        loadhomeCards()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //this updates each time the page is loaded.
        if !firstload{
          //  print("I appeared ")
                  // self.titleArray = ["test"]
              self.initialbutstate.removeAll()
            for (a, test) in idArray.enumerated(){
                self.initialbutstate.append(self.defaults.integer(forKey: "butstate\(idArray[a])"))
            }
            
            if(defaults.stringArray(forKey: "valuesarray") != nil){
             valuesformem = defaults.stringArray(forKey: "valuesarray")!
            }
          //   tableView.reloadData()
            tableView.reloadSections([1], with: .none)
         //   tableView.reloadData()
                  // loadhomeCards()
        }
        firstload = false
       // print("check123\(UserDefaults.standard.dictionaryRepresentation())")

    }

    func loadhomeCards()
{
    let urltoget = "https://lta6232proj8backend.wl.r.appspot.com/guardhome"
    Alamofire.request(urltoget, method: .get).responseJSON{
        (myresponse) in
        
        switch myresponse.result{
        case .success:

            let myresult = try? JSON(data:myresponse.data!)
            //clears array if refreshed.
            self.titleArray.removeAll()
            self.catArray.removeAll()
            self.dateArray.removeAll()
            self.picArray.removeAll()
            self.idArray.removeAll()
            self.initialbutstate.removeAll()
            self.datemod2Array.removeAll()
            self.urlArray.removeAll()
            for i in myresult!["response"]["results"].arrayValue{
                let webTitle = i["webTitle"].stringValue
                let sectionName = i["sectionName"].stringValue
                var webPublicationDate = i["webPublicationDate"].stringValue
                if (webPublicationDate == "" ){
                    webPublicationDate = "2020-05-07T08:00:18Z"
                               }
                let thumbnail = i["fields"]["thumbnail"].stringValue
                var weburl = i["webUrl"].stringValue
                if (weburl == ""){
                    weburl = "http://www.guardian.co.uk/404"
                }
                let id = i["id"].stringValue
                self.idArray.append(id)
                //print("id is: \(id)")
                //print("this is: \(thumbnail)")
                self.picArray.append(thumbnail)
                print("this is: \(self.picArray)")
                //print("\(webTitle)")
                self.titleArray.append(webTitle)
                self.catArray.append(sectionName)
                self.urlArray.append(weburl)
                let dateFormat = ISO8601DateFormatter()
                let date = dateFormat.date(from:webPublicationDate)!
               // print("This is reformatted date from thingy: \(date)")
                    let dateformater2 = DateFormatter()
                    dateformater2.locale = Locale(identifier:"en_GB")
                    dateformater2.setLocalizedDateFormatFromTemplate("ddMMMYYYY")
               // print("This2 is reformatted date from thingy: \(dateformater2.string(from:date))")
                self.datemod2Array.append(dateformater2.string(from:date))
                let difhours = Calendar.current.dateComponents([.hour], from: date, to: Date()).hour!
                let difmins = Calendar.current.dateComponents([.minute], from: date, to: Date()).minute!
                let difsecs = Calendar.current.dateComponents([.second], from: date, to: Date()).second!
                if difhours >= 1{
                    print("diffhours: \(difhours)h ago")
                    self.dateArray.append("\(difhours)h ago")
                }
                else if difhours < 1 && difmins >= 1{
                    print("diffmins: \(difmins)m ago")
                    self.dateArray.append("\(difmins)m ago")
                }
                else if difhours < 1 && difmins < 1 {
                    print("diffsecs: \(difsecs)s ago")
                    self.dateArray.append("\(difsecs)s ago")
                }
                else {
                    print("diff happen now")
                    self.dateArray.append("d ago")
                }

            //this saves the state of the button on load
            //print("nothere \(self.defaults.integer(forKey: id))")
                self.initialbutstate.append(self.defaults.integer(forKey: "butstate\(id)"))

            }
       //     print(myresult!["response"]["results"][0].description)
        
              //self.tableView.reloadData()
            
       //      SwiftSpinner.hide()
            self.tableView.reloadSections([1], with: .none)
            break
        case .failure:
     //        SwiftSpinner.hide()
            self.tableView.reloadSections([1], with: .none)
           //   self.tableView.reloadData()
            break
        }
    }
    }
    
    
    
    @IBAction func refreshIt(_ sender: UIRefreshControl) {
        weatherupdate()
        loadhomeCards()
        sender.endRefreshing()
     //   self.tableView.reloadData()
    }
    func reportLocationServicesDeniedError(){
       // print("Im here")
        let alert = UIAlertController(title: "LocationServices Disabled", message: "Please go to settings to fix", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else if section == 1 {
            return titleArray.count
        }
        else {return 0}
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell

        if indexPath.section == 0{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "BottomTableViewCell", for: indexPath) as! BottomTableViewCell
            cell.bottomLabel.text = "\(currentCity)"
            cell.stateLabel.text = "\(currentState)"
            let toconvertweather = Double(currentTemp) ?? 0.0
            let convertedweatheralready = String(format: "%.0f", toconvertweather)
           // print("wea123\(convertedweatheralready)")
            cell.degreeLabel.text="\(convertedweatheralready)°C"
            cell.condLabel.text="\(currentCond)"
            if (currentCond == "Clouds"){
                            cell.imageWeather.image = #imageLiteral(resourceName: "cloudy_weather")
            }
            else if (currentCond == "Clear"){
                                cell.imageWeather.image = #imageLiteral(resourceName: "clear_weather")
                }
            else if (currentCond == "Snow"){
                                    cell.imageWeather.image = #imageLiteral(resourceName: "snowy_weather")
                    }
            else if (currentCond == "Rain"){
                                        cell.imageWeather.image = #imageLiteral(resourceName: "rainy_weather")
                        }
            else if (currentCond == "Thunderstorm"){
                                        cell.imageWeather.image = #imageLiteral(resourceName: "thunder_weather")
                            }
            else{
                         cell.imageWeather.image = #imageLiteral(resourceName: "sunny_weather")
            }

                    return cell
        }
        else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
            cell.link = self
            //initially when the app is open, load the state of the but
            if (initialbutstate[indexPath.row] == 0)
            {
                cell.bookmarkButImage.setImage(UIImage(systemName: "bookmark"), for: .normal)
            }
            else if (initialbutstate[indexPath.row] == 1)
            {
                cell.bookmarkButImage.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            }
            
            
            
            
           // print("\(titleArray)")
            if picArray[indexPath.row] != ""{
                
                            cell.newsPictureLabel.sd_setImage(with: URL(string: picArray[indexPath.row]), placeholderImage: UIImage(named: "default-guardian"))
            
            }
            else{
                cell.newsPictureLabel.image = #imageLiteral(resourceName: "default-guardian")
            }
            cell.labelTextOf.text = "\(titleArray[indexPath.row])"
            cell.catLabel.text = "| \(catArray[indexPath.row])"
            cell.timeLabel.text = "\(dateArray[indexPath.row])"
            
            return cell
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {

           return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
               let sharewithtwitter = UIAction(title: "Share with Twitter", image: #imageLiteral(resourceName: "twitter")) { action in
                   print("Sharing")
                UIApplication.shared.open(URL(string:"https://twitter.com/intent/tweet?text=Check%20out%20this%20Article!&hashtags=CSCI_571_NewsApp&url=\(self.urlArray[indexPath.row])")! as URL, options:[:], completionHandler: nil)
               }
            
            
            
            let bookmark = UIAction(title: "Bookmark", image: UIImage(systemName: "bookmark")) { action in
                 print("Sharing")
                let cell = tableView.cellForRow(at: indexPath) as! TableViewCell
                
            if (self.initialbutstate[indexPath.row] == 1){
                     self.navigationController?.view.hideAllToasts()
                self.initialbutstate[indexPath.row] = 0
                self.valuesformem.removeAll {$0 == self.idArray[indexPath.row]}
                self.defaults.set(0, forKey: "butstate\(self.idArray[indexPath.row])")
                self.defaults.set(self.valuesformem, forKey: "valuesarray")
                    self.navigationController?.view.makeToast("Article Removed From Bookmark")

                }
                else {
                    self.navigationController?.view.hideAllToasts()
                self.initialbutstate[indexPath.row] = 1
                if (self.valuesformem.contains(self.idArray[indexPath.row]) == false){
                    self.valuesformem.append(self.idArray[indexPath.row])
                    }
                    //sets defaults for the butstate, image (either url or ""), title, date, cat, and general values array.
                self.defaults.set(1, forKey: "butstate\(self.idArray[indexPath.row])")
                if self.picArray[indexPath.row] != ""{
                    self.defaults.set(self.picArray[indexPath.row], forKey: "image\(self.idArray[indexPath.row])")
                               }
                               else{
                    self.defaults.set("", forKey: "image\(self.idArray[indexPath.row])")
                               }
                self.defaults.set(self.titleArray[indexPath.row], forKey: "title\(self.idArray[indexPath.row])")
                self.defaults.set(self.datemod2Array[indexPath.row], forKey: "date\(self.idArray[indexPath.row])")
                self.defaults.set(self.catArray[indexPath.row], forKey: "cat\(self.idArray[indexPath.row])")
                self.defaults.set(self.urlArray[indexPath.row], forKey: "url\(self.idArray[indexPath.row])")
                self.defaults.set(self.valuesformem, forKey: "valuesarray")
                    self.navigationController?.view.makeToast("Article Bookmarked. Check out the Bookmarks tab to view")

                    
                }
                //cell.bookmarkButImage.setImage(#imageLiteral(resourceName: "trending-up"), for: .normal)
             //   initialbutstate = 1;
          //  print(self.initialbutstate)
            //print(self.defaults.string(forKey: "cat\(self.idArray[indexPath.row])"))

               
                if (self.initialbutstate[indexPath.row] == 0)
            {
                cell.bookmarkButImage.setImage(UIImage(systemName: "bookmark"), for: .normal)
            }
                else if (self.initialbutstate[indexPath.row] == 1)
            {
                cell.bookmarkButImage.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            }
            
            
            

             }
               return UIMenu(title: "Menu", children: [sharewithtwitter, bookmark])
           }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  
            currenttitle = titleArray[indexPath.row]
            currentidtosend = idArray[indexPath.row]
            self.navigationController?.view.hideAllToasts()
            performSegue(withIdentifier: "showDetail", sender: nil)

    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as?
            DetailedViewController{
            viewController.detailedtitle = currenttitle
            viewController.detailedid = currentidtosend
        }
    }
    

}
//method for getting location adapated from https://www.youtube.com/watch?v=HlVBC_PzYq0&t=405s
extension TableViewController: CLLocationManagerDelegate{
    func weatherupdate() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        handleAuthenticationStatus(status: status)
    }
    func handleAuthenticationStatus(status: CLAuthorizationStatus){
        switch status{
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
       // reportLocationServicesDeniedError()
            SwiftSpinner.hide()
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        @unknown default:
            print("alert : error is: \(status)")
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations.last ?? CLLocation()
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) in
            var locationlocality = ""
            var locationStateName = ""
            if placemarks != nil{
                let placemark = placemarks?.last
                locationlocality = placemark?.locality ?? "Unknown locality"
                locationStateName = placemark?.administrativeArea ?? "Unknown State"
                self.currentState = locationStateName
                self.currentCity = locationlocality
                let fixedcurrentCity = self.currentCity.replacingOccurrences(of: " ", with: "%20")
                print("This is the current City: \(fixedcurrentCity)  This is the Current State: \(self.currentState)")
                //this reloads the table to show most recent data.
                Alamofire.request("https://api.openweathermap.org/data/2.5/weather?q=\(fixedcurrentCity)&units=metric&appid=RETRACTED").responseJSON{
                    (myresponse) in
                    switch myresponse.result{
                    case .success:
                        let myresult = try? JSON(data:myresponse.data!)
                        print(myresult!["main"]["temp"].description)
                        self.currentTemp = myresult!["main"]["temp"].description
                        print("\(self.currentTemp)")
                        print(myresult!["weather"][0]["main"])
                        self.currentCond = myresult!["weather"][0]["main"].description
                            SwiftSpinner.hide()
                          self.tableView.reloadData()
                        break
                    case .failure:
                        SwiftSpinner.hide()
                      //    self.tableView.reloadData()
                        break
                    }
                }

                
                
            }
            else{
              //  SwiftSpinner.hide()
                locationlocality = "Could not find location"
            }
              
        }

    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

    }
}
