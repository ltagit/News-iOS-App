import UIKit

class BottomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var condLabel: UILabel!
    @IBOutlet weak var testView: UIView!
    @IBOutlet weak var imageWeather: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        testView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        imageWeather.layer.cornerRadius = 5
        testView.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
