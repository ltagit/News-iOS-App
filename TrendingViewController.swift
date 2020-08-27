import UIKit
import Alamofire
import SwiftyJSON
import Charts

class TrendingViewController: UIViewController {

    var trendpoints: [Double] = []
    var searchterm = "Trending Chart for Coronavirus"

    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var searchtext: UITextField!
    
    func setChartStuff(){
        var arrayforchart = [ChartDataEntry]()
        for i in 0..<trendpoints.count{
            print("pointsare: \(trendpoints[i])")
            let points = ChartDataEntry(x: Double(i), y: trendpoints[i])
            arrayforchart.append(points)
        }
        
        let linechart = LineChartDataSet(entries: arrayforchart, label: searchterm)
        linechart.colors = [#colorLiteral(red: 0.1847769618, green: 0.4873527288, blue: 0.9652674794, alpha: 1)]
        linechart.drawCircleHoleEnabled = false
        linechart.circleColors = [#colorLiteral(red: 0.1847769618, green: 0.4873527288, blue: 0.9652674794, alpha: 1)]
        linechart.circleRadius = 5
        let data = LineChartData()
        data.addDataSet(linechart)
        lineChartView.data = data
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchtext.addTarget(self, action: #selector(onReturn), for: UIControl.Event.editingDidEndOnExit)
        defaultchart()
    }
    func defaultchart(){
        self.trendpoints.removeAll()
        searchterm = "Trending Chart for Coronavirus"
        let parametersstart = ["whichurl" : "Coronavirus"]
        Alamofire.request( "BackendRouteRetracted2trending", method: .post, parameters: parametersstart, encoding: URLEncoding(), headers: nil).responseJSON{
            (myresponse) in
            switch myresponse.result{
            case .success:
                let myresult = try? JSON(data:myresponse.data!)
             let arrayfortext = myresult!["default"]["timelineData"].arrayValue
             for (index,things) in arrayfortext.enumerated() {
          //      print("arrayhereis: \(arrayfortext[index]["value"]) ")
                let thingtochange = arrayfortext[index]["value"][0].doubleValue
      //          print("set: \(thingtochange)")
                self.trendpoints.append(thingtochange)
             }
                self.setChartStuff()
                break
            case .failure:
                print("it doesnt work")
               //   self.tableView.reloadData()
                break
            }
        }
    }
    
    @IBAction func onReturn()
    {   self.trendpoints.removeAll()
        self.searchtext.resignFirstResponder()
        print("searchis: \(self.searchtext.text!)")
        if(self.searchtext.text! != ""){
            searchterm = "Trending Chart for \(self.searchtext.text!)"
        }
        else if (self.searchtext.text! == "")
        {
            searchterm = "Trending Chart for Coronavirus"
        }

        let parameters = ["whichurl" : "\(self.searchtext.text!)"]
        Alamofire.request( "BackendRouteRetracted2trending", method: .post, parameters: parameters, encoding: URLEncoding(), headers: nil).responseJSON{
                (myresponse) in
                
                switch myresponse.result{
                case .success:
                    let myresult = try? JSON(data:myresponse.data!)
                 let arrayfortext = myresult!["default"]["timelineData"].arrayValue
                 for (index,things) in arrayfortext.enumerated() {
                    print("arrayhereis: \(arrayfortext[index]["value"]) ")
                    let thingtochange = arrayfortext[index]["value"][0].doubleValue
                 //  let convertodouble = (thingtochange as NSInteger).doubleValue
                    print("set: \(thingtochange)")
                    self.trendpoints.append(thingtochange)
                  //  print("valu: \(self.trendpoints[index])")
                 }
                    self.setChartStuff()
                    break
                case .failure:
                    print("it doesnt work")
                   //   self.tableView.reloadData()
                    break
                }
            }
        }
    func gettrendstuff()
    {
        let parameters = ["whichguardurl" : "\(self.searchtext.text!)"]
        Alamofire.request( "BackendRouteRetracted2trending", method: .post, parameters: parameters, encoding: URLEncoding(), headers: nil).responseJSON{
            (myresponse) in
            
            switch myresponse.result{
            case .success:
                let myresult = try? JSON(data:myresponse.data!)
             let arrayfortext = myresult!["default"]["timelineData"].arrayValue
             for (index,things) in arrayfortext.enumerated() {
                print("arrayhereis: \(arrayfortext[index]["value"]) ")

             }
           
                break
            case .failure:
                print("it doesnt work")
               //   self.tableView.reloadData()
                break
            }
        }
        }
    

}
