import UIKit

class headlinesTableViewCell1: UITableViewCell {
    @IBOutlet weak var labelTextOf1: UILabel!
    @IBOutlet weak var timeLabel1: UILabel!
    @IBOutlet weak var catLabel1: UILabel!
    @IBOutlet weak var newsPictureLabel1: UIImageView!
    @IBOutlet weak var viewNews1: UIView!
    

    @IBOutlet weak var bookmarkButImage1: UIButton!
    var link1: headlinesTableViewController1?

    override func awakeFromNib() {
        super.awakeFromNib()
        newsPictureLabel1.layer.cornerRadius = 5
        viewNews1.layer.cornerRadius = 5
        viewNews1.layer.borderWidth = 1
        viewNews1.layer.borderColor = #colorLiteral(red: 0.7851629853, green: 0.7852769494, blue: 0.785138011, alpha: 1)

             bookmarkButImage1.addTarget(self, action: #selector(doFavStuff1), for: .touchUpInside)
    }

    @objc private func doFavStuff1() {
        link1?.callbacktothis1(cell: self)
     }


}
