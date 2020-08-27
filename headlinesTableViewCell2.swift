import UIKit

class headlinesTableViewCell2: UITableViewCell {
    @IBOutlet weak var labelTextOf2: UILabel!
    @IBOutlet weak var timeLabel2: UILabel!
    @IBOutlet weak var catLabel2: UILabel!
    @IBOutlet weak var newsPictureLabel2: UIImageView!
    @IBOutlet weak var viewNews2: UIView!
    
    
    @IBOutlet weak var bookmarkButImage2: UIButton!
    var link2: headlinesTableViewController2?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        newsPictureLabel2.layer.cornerRadius = 5
        viewNews2.layer.cornerRadius = 5
        viewNews2.layer.borderWidth = 1
        viewNews2.layer.borderColor = #colorLiteral(red: 0.7851629853, green: 0.7852769494, blue: 0.785138011, alpha: 1)
        
        bookmarkButImage2.addTarget(self, action: #selector(doFavStuff2), for: .touchUpInside)
        
    }

    @objc private func doFavStuff2() {
        link2?.callbacktothis2(cell: self)
     }

}
