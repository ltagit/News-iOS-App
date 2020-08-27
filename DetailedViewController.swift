import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner
import Toast_Swift

class DetailedViewController: UIViewController {
    var detailedtitle: String = ""
    var detailedid: String = ""
    var urltoopen: String = ""
    var urlforimageuse: String = ""
    var titleforuse: String = ""
    var dateforuse: String = ""
    var catforuse: String = ""
    var textforuse: String = ""
    let defaults = UserDefaults.standard
    var valuesformem1 = [String]()
    var initialbutstate1 = 0
    override func viewDidLoad() {
        super.viewDidLoad()
  //      print("mem1\(defaults.stringArray(forKey: "valuesarray"))")
        self.navigationItem.title = "\(detailedtitle)";
    //    print("here \(detailedid)")
        SwiftSpinner.show("Loading Detailed article..")
        loadDetailedCard()
         detailcontent.numberOfLines = 30
       // print("fa321\(detailcontent.attributedText)")
        //detailcontent.lineBreakMode = .byTruncatingTail
    }
    override func viewDidAppear(_ animated: Bool) {
                initialbutstate1 = self.defaults.integer(forKey: "butstate\(detailedid)")
        valuesformem1 = self.defaults.stringArray(forKey: "valuesarray") ?? []
        print("valformem\(valuesformem1)")
        if (initialbutstate1 == 0){
            bookmarkButImageD.image = UIImage(systemName: "bookmark")
        }
        else if (initialbutstate1 == 1){
            bookmarkButImageD.image = UIImage(systemName: "bookmark.fill")
        }
    }
    //this gets the height of the text.  heavily modified from https://stackoverflow.com/a/40652701
    func labelheight(atttext:NSAttributedString, font:UIFont, width:CGFloat) -> CGFloat
    {
        let newlabel:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        newlabel.numberOfLines = 30
        newlabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        newlabel.attributedText = atttext
        newlabel.font = font
        newlabel.sizeToFit()
        return newlabel.frame.size.height
    }

    @IBOutlet weak var varriedheights: NSLayoutConstraint!
    @IBOutlet weak var viewthings: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var detailcontent: UILabel!
    @IBOutlet weak var detailedTitleHeader: UILabel!
    @IBOutlet weak var detailedCategory: UILabel!
    @IBOutlet weak var detailedDate: UILabel!
    @IBOutlet weak var detailedPic: UIImageView!
    @IBOutlet weak var bookmarkButImageD: UIBarButtonItem!
    func loadDetailedCard()
    {
        let parameters = ["whichguardurl" : "\(detailedid)"]
        initialbutstate1 = self.defaults.integer(forKey: "butstate\(detailedid)")
        valuesformem1 = self.defaults.stringArray(forKey: "valuesarray") ?? []
        print("valformem\(valuesformem1)")
        if (initialbutstate1 == 0){
            bookmarkButImageD.image = UIImage(systemName: "bookmark")
        }
        else if (initialbutstate1 == 1){
            bookmarkButImageD.image = UIImage(systemName: "bookmark.fill")
        }
        Alamofire.request( "BackendRouteRetracted2", method: .post, parameters: parameters, encoding: URLEncoding(), headers: nil).responseJSON{
            (myresponse) in
            
            switch myresponse.result{
            case .success:
                let myresult = try? JSON(data:myresponse.data!)
             var addedstringfortext = "<html><body style=\"font-family: HelveticaNeue; font-size: 17\">"
             let arrayfortext = myresult!["response"]["content"]["blocks"]["body"].arrayValue
             for (index,things) in arrayfortext.enumerated() {
                print("arrayhereis: \(index) \(arrayfortext[index]["bodyHtml"]) ")
                addedstringfortext = addedstringfortext + (arrayfortext[index]["bodyHtml"].string ?? "")
             }
            addedstringfortext = addedstringfortext + "</body></html>"
                let fixedstringfortext = addedstringfortext.replacingOccurrences(of: "’", with: "&apos;")
                let fixedstringfortext2 = fixedstringfortext.replacingOccurrences(of: "“", with: "&quot;")
                let fixedstringfortext3 = fixedstringfortext2.replacingOccurrences(of: "”", with: "&quot;")
                let fixedstringfortext4 = fixedstringfortext3.replacingOccurrences(of: "–", with: "&mdash;")
                
                //if things start breaking remove these two
           //     let fixedstringfortext5 = fixedstringfortext4.replacingOccurrences(of: "<img", with: "<div")
        //        let fixedstringfortext6 = fixedstringfortext5.replacingOccurrences(of: "/img>", with: "/div>")
                addedstringfortext = fixedstringfortext4
                
         //       print("append\(addedstringfortext)")
              //print( "arrayhereis: \(myresult!["response"]["content"]["blocks"]["body"][0]["bodyHtml"].stringValue)")
                
                let testdata = Data(addedstringfortext.utf8)
                if let attributedString = try? NSAttributedString(data: testdata, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
                   self.detailcontent.attributedText = attributedString
                    self.textforuse = attributedString.string
                    let testing =  self.labelheight(atttext: attributedString, font: UIFont.systemFont(ofSize: 17), width: 370)
                  //  print("testing123\(testing)")
                  //  print("height123\(self.detailcontent.frame.size.height)")
                    self.varriedheights.constant =  525 + testing
                }
                
                let testingpic = myresult!["response"]["content"]["blocks"]["main"]["elements"][0]["assets"].arrayValue
                let testingpicindex = testingpic.endIndex
              //  print ("ending index is \(testingpicindex)")
                if testingpic.count != 0
                {
                    do{
                        let imageurl = URL(string: "\(testingpic[testingpicindex-1]["file"].stringValue)")!
                        self.urlforimageuse = testingpic[testingpicindex-1]["file"].stringValue
              //          print("urlisfor\(self.urlforimageuse)")
                        let imagedata = try Data(contentsOf: imageurl)
                        self.detailedPic.image = UIImage(data: imagedata)
                    }
                    catch{
                        print(error)
                    }
             //    print("it worked \(testingpic[testingpicindex-1]["file"].stringValue)")
                }
                else{
                    self.detailedPic.image = #imageLiteral(resourceName: "default-guardian")
                }
                //clears array if refreshed.
              //  self.titleArray.removeAll()
                self.detailedTitleHeader.text = "\(myresult!["response"]["content"]["webTitle"].stringValue)"
                self.titleforuse = "\(myresult!["response"]["content"]["webTitle"].stringValue)"
                self.detailedCategory.text = "\(myresult!["response"]["content"]["sectionName"].stringValue)"
                self.catforuse = "\(myresult!["response"]["content"]["sectionName"].stringValue)"
                var datetoconvert = "\(myresult!["response"]["content"]["webPublicationDate"].stringValue)"
                if (datetoconvert == "" ){
                    datetoconvert = "2020-05-07T08:00:18Z"
                }
                let dateFormat = ISO8601DateFormatter()
                    let date = dateFormat.date(from:datetoconvert)
                    if date != nil{
                        let dateformater2 = DateFormatter()
                        dateformater2.locale = Locale(identifier:"en_GB")
                        dateformater2.setLocalizedDateFormatFromTemplate("ddMMMYYYY")
                        print("This is reformatted date from thingy: \(dateformater2.string(from:date!))")
                        self.detailedDate.text = dateformater2.string(from:date!)
                        self.dateforuse = dateformater2.string(from:date!)
                    }
                var weburld = "\(myresult!["response"]["content"]["webUrl"].stringValue)"
                if (weburld == ""){
                weburld = "http://www.guardian.co.uk/404"
                                       }
                self.urltoopen = weburld
                SwiftSpinner.hide()
                break
            case .failure:
                SwiftSpinner.hide()
              //  print("it doesnt work")
               //   self.tableView.reloadData()
                break
            }
        }
        }
    
    @IBAction func butwaspressed(_ sender: UIBarButtonItem) {

        if(initialbutstate1 == 1){
             self.navigationController?.view.hideAllToasts()
            initialbutstate1 = 0
            defaults.set(0, forKey: "butstate\(detailedid)")
            self.valuesformem1.removeAll {$0 == detailedid}
            self.defaults.set(valuesformem1, forKey: "valuesarray")
            bookmarkButImageD.image = UIImage(systemName: "bookmark")
            self.navigationController?.view.makeToast("Article Removed From Bookmark")
        }
        else{
             self.navigationController?.view.hideAllToasts()
             initialbutstate1 = 1
            bookmarkButImageD.image = UIImage(systemName: "bookmark.fill")
            if (valuesformem1.contains(detailedid) == false){
             valuesformem1.append(detailedid)
            }
            defaults.set(1, forKey: "butstate\(detailedid)")
            if self.urlforimageuse != ""{
          //      print("readyhere")
                self.defaults.set(self.urlforimageuse, forKey: "image\(detailedid)")
                       }
                       else{
                self.defaults.set("", forKey: "image\(detailedid)")
                       }
             self.defaults.set(self.titleforuse, forKey: "title\(detailedid)")
             self.defaults.set(self.dateforuse, forKey: "date\(detailedid)")
            self.defaults.set(self.catforuse, forKey: "cat\(detailedid)")
            self.defaults.set(self.urltoopen, forKey: "url\(detailedid)")
            self.defaults.set(self.valuesformem1, forKey: "valuesarray")
                self.navigationController?.view.makeToast("Article Bookmarked. Check out the Bookmarks tab to view")

            
            
         //   let testingvar = self.defaults.string(forKey: "image\(detailedid)")
          //  print("mem1\(defaults.stringArray(forKey: "valuesarray"))")
           // print ("imagdetail\(testingvar)")
        }
        
        
    }
    @IBAction func letsTweet(_ sender: UIBarButtonItem) {
        //print("letstweet: https://twitter.com/intent/tweet?text=Check%20out%20this%20Article!&hashtags=CSCI_571_NewsApp&url=\(self.urltoopen)")
        UIApplication.shared.open(URL(string:"https://twitter.com/intent/tweet?text=Check%20out%20this%20Article!&hashtags=CSCI_571_NewsApp&url=\(self.urltoopen)")! as URL, options:[:], completionHandler: nil)
    }
    @IBAction func viewfullButton(_ sender: UIButton) {
        if self.urltoopen != "" {
        UIApplication.shared.open(URL(string:"\(self.urltoopen)")! as URL, options:[:], completionHandler: nil)
        }
    }

}
extension UIScrollView {
    func updateContentView() {
        contentSize.height = subviews.sorted(by: { $0.frame.maxY < $1.frame.maxY }).last?.frame.maxY ?? contentSize.height
    }
}
