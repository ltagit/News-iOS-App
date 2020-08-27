import UIKit

class ResultsTableViewCell: UITableViewCell {

    @IBOutlet weak var labelTextOfS: UILabel!
    @IBOutlet weak var timeLabelS: UILabel!
    @IBOutlet weak var catLabelS: UILabel!
    @IBOutlet weak var newsPictureLabelS: UIImageView!
    @IBOutlet weak var bookmarkButImageS: UIButton!
    @IBOutlet weak var viewNewsS: UIView!
    var linkS: ResultsTableViewController?
    override func awakeFromNib() {
        super.awakeFromNib()
        newsPictureLabelS.layer.cornerRadius = 5
        viewNewsS.layer.cornerRadius = 5
        viewNewsS.layer.borderWidth = 1
        viewNewsS.layer.borderColor = #colorLiteral(red: 0.7851629853, green: 0.7852769494, blue: 0.785138011, alpha: 1)
        bookmarkButImageS.addTarget(self, action: #selector(doFavStuffS), for: .touchUpInside)
            }

            @objc private func doFavStuffS() {
                linkS?.callbacktothisS(cell: self)
             }

}
