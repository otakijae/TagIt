import UIKit

class TaggingViewCell: UITableViewCell {
	
    @IBOutlet weak var colorTagView: UIView!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var removeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.colorTagView.layer.cornerRadius = self.colorTagView.frame.size.width / 2;
        self.colorTagView.clipsToBounds = true;
        
        self.backgroundColor = UIColor.clear

        let backgroundView = UIView()
        backgroundView.backgroundColor = .backgroundColor
        self.backgroundView = backgroundView
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
	
}
