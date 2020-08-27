import UIKit

class headlinesTableViewCell6: UITableViewCell {
    @IBOutlet weak var labelTextOf6: UILabel!
    @IBOutlet weak var timeLabel6: UILabel!
    @IBOutlet weak var catLabel6: UILabel!
    @IBOutlet weak var newsPictureLabel6: UIImageView!
    @IBOutlet weak var viewNews6: UIView!
    
    @IBOutlet weak var bookmarkButImage6: UIButton!
    var link6: headlinesTableViewController6?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        newsPictureLabel6.layer.cornerRadius = 5
        viewNews6.layer.cornerRadius = 5
        viewNews6.layer.borderWidth = 1
        viewNews6.layer.borderColor = #colorLiteral(red: 0.7851629853, green: 0.7852769494, blue: 0.785138011, alpha: 1)
        
        bookmarkButImage6.addTarget(self, action: #selector(doFavStuff6), for: .touchUpInside)
    }


    @objc private func doFavStuff6() {
        link6?.callbacktothis6(cell: self)
     }


}
