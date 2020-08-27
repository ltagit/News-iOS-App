import UIKit
import Toast_Swift

class CollectionViewController: UICollectionViewController {
    var dataSource : [String] = [""]
    var tempstore: [String] = [""]
    var currenttile = ""
    var currentidtosend = ""
    func callbacktothisb1(cell: CollectionViewCell){
         self.navigationController?.view.hideAllToasts()
        tempstore = dataSource
           let indexPathTappedb = collectionView.indexPath(for: cell)
   //     print("clicked \(indexPathTappedb!.row)")
        tempstore.removeAll {$0 == dataSource[indexPathTappedb!.row]}
        self.navigationController?.view.hideAllToasts()
        defaults.set(0, forKey: "butstate\(dataSource[indexPathTappedb!.row])")
        defaults.set(tempstore, forKey: "valuesarray")
        self.navigationController?.view.makeToast("Article Removed From Bookmark")
        dataSource = defaults.stringArray(forKey: "valuesarray") ?? []
        if (dataSource.count == 0){
            nothingHere.text = "No Bookmarks Added"
        }
        else{
            nothingHere.text = ""
        }
        collectionView.reloadData()
    }
    
    @IBOutlet weak var nothingHere: UILabel!
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = defaults.stringArray(forKey: "valuesarray") ?? []
        if (dataSource.count == 0){
            nothingHere.text = "No Bookmarks Added"
        }
        else{
            nothingHere.text = ""
        }
        collectionView.reloadData()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("backtoblack")
        dataSource = defaults.stringArray(forKey: "valuesarray") ?? []
        if (dataSource.count == 0){
            nothingHere.text = "No Bookmarks Added"
        }
        else{
            nothingHere.text = ""
        }
        collectionView.reloadData()

    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let collectionviewController = segue.destination as?
            DetailedViewController{
            collectionviewController.detailedtitle = currenttile
            collectionviewController.detailedid = currentidtosend
        }
    }
 
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
 
        return dataSource.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        if let bookmarksCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellB", for: indexPath) as? CollectionViewCell {
                    bookmarksCell.linkb1 = self
            let title = defaults.string(forKey: "title\(dataSource[indexPath.row])") ?? ""
            let category = defaults.string(forKey: "cat\(dataSource[indexPath.row])") ?? ""
            let datetofill = defaults.string(forKey: "date\(dataSource[indexPath.row])") ?? ""
            let picturetofill = defaults.string(forKey: "image\(dataSource[indexPath.row])") ?? ""

            bookmarksCell.config(with: title, catLabelBthing: category, dateLabelBthing: datetofill, pictureLabel: picturetofill)
            cell = bookmarksCell
        }

        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {

               return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
                   let sharewithtwitter = UIAction(title: "Share with Twitter", image: #imageLiteral(resourceName: "twitter")) { action in
                       print("Sharing")
                    let urlfortwittersharing = self.defaults.string(forKey: "url\(self.dataSource[indexPath.row])") ?? "http://www.guardian.co.uk/404"
                    UIApplication.shared.open(URL(string:"https://twitter.com/intent/tweet?text=Check%20out%20this%20Article!&hashtags=CSCI_571_NewsApp&url=\(urlfortwittersharing)")! as URL, options:[:], completionHandler: nil)
                   }
                

                let bookmark = UIAction(title: "Bookmark", image: UIImage(systemName: "bookmark")) { action in
                     print("Sharing")

                        self.navigationController?.view.hideAllToasts()
                    self.tempstore = self.dataSource
                   // let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
                    //     print("clicked \(indexPathTappedb!.row)")
                    self.tempstore.removeAll {$0 == self.dataSource[indexPath.row]}
                         self.navigationController?.view.hideAllToasts()
                    self.defaults.set(0, forKey: "butstate\(self.dataSource[indexPath.row])")
                    self.defaults.set(self.tempstore, forKey: "valuesarray")
                         self.navigationController?.view.makeToast("Article Removed From Bookmark")
                    self.dataSource = self.defaults.stringArray(forKey: "valuesarray") ?? []
                    if (self.dataSource.count == 0){
                        self.nothingHere.text = "No Bookmarks Added"
                         }
                         else{
                        self.nothingHere.text = ""
                         }
                         collectionView.reloadData()
                    
                  
                    //cell.bookmarkButImage.setImage(#imageLiteral(resourceName: "trending-up"), for: .normal)
                 //   initialbutstate = 1;
           //     print(self.initialbutstate1)
            //    print(self.defaults1.string(forKey: "cat\(self.idArray1[indexPath.row])"))

                
                

                 }

                   return UIMenu(title: "Menu", children: [sharewithtwitter, bookmark])
               }
        }


    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currenttile = defaults.string(forKey: "title\(dataSource[indexPath.row])") ?? ""
        currentidtosend = dataSource[indexPath.row] ?? ""
            self.navigationController?.view.hideAllToasts()
        performSegue(withIdentifier: "detfrombook", sender: nil)
    }
    
}
