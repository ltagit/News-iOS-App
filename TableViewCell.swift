import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var labelTextOf: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var catLabel: UILabel!
    @IBOutlet weak var newsPictureLabel: UIImageView!
    @IBOutlet weak var viewNews: UIView!
    

    @IBOutlet weak var bookmarkButImage: UIButton!
    

    var link: TableViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        newsPictureLabel.layer.cornerRadius = 5
        viewNews.layer.cornerRadius = 5
        viewNews.layer.borderWidth = 1
        viewNews.layer.borderColor = #colorLiteral(red: 0.7851629853, green: 0.7852769494, blue: 0.785138011, alpha: 1)
        bookmarkButImage.addTarget(self, action: #selector(doFavStuff), for: .touchUpInside)
    }

    @objc private func doFavStuff() {
        link?.callbacktothis(cell: self)
     }

    
}
