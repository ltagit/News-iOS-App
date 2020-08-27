import UIKit

class searchResultsCell: UITableViewCell {
    var testing: String?
    @IBOutlet weak var textsuggests: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        if (testing != nil){
         //print("I am \(testing)")
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
