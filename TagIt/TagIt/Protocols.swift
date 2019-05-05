import UIKit

protocol UpdateColorDelegate: class {
    func updateColor(selectedColor: UIColor)
}

protocol TaggingDelegate: class {
    func putTagsOnPhoto(with tagList: [String])
}
