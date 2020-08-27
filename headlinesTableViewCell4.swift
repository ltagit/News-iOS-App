import UIKit

class headlinesTableViewCell4: UITableViewCell {
    @IBOutlet weak var labelTextOf4: UILabel!
    @IBOutlet weak var timeLabel4: UILabel!
    @IBOutlet weak var catLabel4: UILabel!
    @IBOutlet weak var newsPictureLabel4: UIImageView!
    @IBOutlet weak var viewNews4: UIView!
    
    @IBOutlet weak var bookmarkButImage4: UIButton!
    var link4: headlinesTableViewController4?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        newsPictureLabel4.layer.cornerRadius = 5
        viewNews4.layer.cornerRadius = 5
        viewNews4.layer.borderWidth = 1
        viewNews4.layer.borderColor = #colorLiteral(red: 0.7851629853, green: 0.7852769494, blue: 0.785138011, alpha: 1)
        

        bookmarkButImage4.addTarget(self, action: #selector(doFavStuff4), for: .touchUpInside)
    }

    @objc private func doFavStuff4() {
        link4?.callbacktothis4(cell: self)
     }

}
