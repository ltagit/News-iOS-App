import UIKit

class headlinesTableViewCell3: UITableViewCell {
    @IBOutlet weak var labelTextOf3: UILabel!
    @IBOutlet weak var timeLabel3: UILabel!
    @IBOutlet weak var catLabel3: UILabel!
    @IBOutlet weak var newsPictureLabel3: UIImageView!
    @IBOutlet weak var viewNews3: UIView!
    
    @IBOutlet weak var bookmarkButImage3: UIButton!
    
    var link3: headlinesTableViewController3?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        newsPictureLabel3.layer.cornerRadius = 5
              viewNews3.layer.cornerRadius = 5
              viewNews3.layer.borderWidth = 1
              viewNews3.layer.borderColor = #colorLiteral(red: 0.7851629853, green: 0.7852769494, blue: 0.785138011, alpha: 1)
        
         bookmarkButImage3.addTarget(self, action: #selector(doFavStuff3), for: .touchUpInside)
        
    }

    @objc private func doFavStuff3() {
        link3?.callbacktothis3(cell: self)
     }

}
