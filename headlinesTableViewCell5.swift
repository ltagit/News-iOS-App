import UIKit

class headlinesTableViewCell5: UITableViewCell {
    @IBOutlet weak var labelTextOf5: UILabel!
    @IBOutlet weak var timeLabel5: UILabel!
    @IBOutlet weak var catLabel5: UILabel!
    @IBOutlet weak var newsPictureLabel5: UIImageView!
    @IBOutlet weak var viewNews5: UIView!
    
    
    @IBOutlet weak var bookmarkButImage5: UIButton!
    var link5: headlinesTableViewController5?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        newsPictureLabel5.layer.cornerRadius = 5
               viewNews5.layer.cornerRadius = 5
               viewNews5.layer.borderWidth = 1
               viewNews5.layer.borderColor = #colorLiteral(red: 0.7851629853, green: 0.7852769494, blue: 0.785138011, alpha: 1)

        bookmarkButImage5.addTarget(self, action: #selector(doFavStuff5), for: .touchUpInside)
    }


    @objc private func doFavStuff5() {
        link5?.callbacktothis5(cell: self)
     }

}
