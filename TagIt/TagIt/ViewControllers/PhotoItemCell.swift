import UIKit

class PhotoItemCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var taggedLabel: UILabel!
    
    var representedAssetIdentifier: String!
    
    var thumbnailImage: UIImage! {
        didSet {
            imageView.image = thumbnailImage
        }
    }
	
	override var isSelected: Bool {
		didSet {
			if isSelected {
				imageView.layer.borderColor = UIColor.pastelBlue.cgColor
				imageView.layer.borderWidth = 5
			} else {
				imageView.layer.borderWidth = 0
			}
		}
	}
    
    override func prepareForReuse() {
        super.prepareForReuse()
				isSelected = false
        imageView.image = nil
    }
	
}
