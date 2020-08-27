import UIKit
import SDWebImage

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var catLabel: UILabel!
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet weak var pictureView: UIImageView!
    @IBOutlet weak var bookmarksView: UIButton!
    @IBOutlet weak var collectthing: UIView!
    var linkb1: CollectionViewController?
    func config(with titleName: String, catLabelBthing: String, dateLabelBthing: String, pictureLabel: String){
        
        collectthing.layer.cornerRadius = 5
        collectthing.layer.borderWidth = 1
        collectthing.layer.borderColor = #colorLiteral(red: 0.7851629853, green: 0.7852769494, blue: 0.785138011, alpha: 1)
        titleLabel.text = titleName
        catLabel.text = "| \(catLabelBthing)"
        dateLabel.text = dateLabelBthing
        var temppicturehold = pictureLabel
        if (temppicturehold != "") {
            pictureView.sd_setImage(with: URL(string: temppicturehold), placeholderImage: UIImage(named: "default-guardian"))
            
        }
        else{
            pictureView.image = #imageLiteral(resourceName: "default-guardian")
        }
        bookmarksView.addTarget(self, action: #selector(doFavStuffb1), for: .touchUpInside)
        
        
        print("url321 to get pictures here: \(temppicturehold)")
    }
    @objc private func doFavStuffb1() {
        linkb1?.callbacktothisb1(cell: self)
     }
    
}
