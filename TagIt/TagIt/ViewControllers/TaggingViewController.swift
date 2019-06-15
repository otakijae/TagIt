import UIKit
import Photos

class ModalNavigationController: UINavigationController {
    
    weak var semiModalPresentationController: SemiModalPresentationController?
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
        semiModalPresentationController = presentationController as? SemiModalPresentationController
        
        navigationBar.backgroundColor = .backgroundColor
        view.backgroundColor = .backgroundColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.layoutSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
	
}

class TaggingViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightContraint: NSLayoutConstraint!
    
    private var isFirst: Bool = true
    var selectedColor: UIColor = UIColor(hexFromString: "555555")
	
    override func viewDidLoad() {
        super.viewDidLoad()
			
        self.textField.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        initialSettings()
        keyboardSettings()
    }
    
    func initialSettings() {
        self.tableViewHeightContraint.constant = self.view.height / 2
        self.view.backgroundColor = .backgroundColor
        self.tableView.backgroundColor = .backgroundColor
    }
	
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.layoutIfNeeded()
        navigationController?.view.layoutIfNeeded()
        
        if isFirst {
            fitting(animated: true)
            isFirst = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !isFirst {
            fitting(animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    private func fitting(animated: Bool) {
        if let navi = navigationController as? ModalNavigationController {
            var height = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            height += navi.navigationBar.frame.height
            navi.semiModalPresentationController?.setModalViewHeight(height, animated: animated)
        }
    }
	
}

// MARK: UITableView

extension TaggingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "설정"
        } else {
            return "추가된 태그"
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            if let photo = PhotographManager.sharedInstance.selectedPhotograph {
                return photo.tagList.count
            } else {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = UITableViewCell()
            cell.backgroundColor = .backgroundColor
            cell.textLabel?.textColor = .darkGray
            cell.textLabel?.font = UIFont.systemFont(ofSize: 17.0)
            cell.textLabel?.text = "🍑 색깔 추가"
            return cell
            
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaggingViewCell", for: indexPath) as? TaggingViewCell else {
                return UITableViewCell()
            }
            
            if let photo = PhotographManager.sharedInstance.selectedPhotograph {
                cell.tagLabel.text = photo.listToArray(objectList: photo.tagList)[indexPath.row]
                cell.colorTagView.backgroundColor = UIColor(hexFromString: photo.colorId)
            }
            cell.selectionStyle = .none
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            performSegue(withIdentifier: "AddColorSegue", sender: self)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
	
		public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
				if editingStyle == .delete {
						guard let photo: Photograph = PhotographManager.sharedInstance.selectedPhotograph else { return }
						photo.deleteTag(tagIndexPath: indexPath)
						self.tableView.deleteRows(at: [indexPath], with: .automatic)
				}
		}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddColorSegue" {
            guard let destination = segue.destination as? ColorPickerViewController else {
                fatalError("unexpected view controller for segue")
            }
            
            let indexPath = self.tableView.indexPathForSelectedRow
            destination.updateColorDelegate = self
            destination.selectedTagIndex = indexPath
            
        } else if segue.identifier == "UnwindTaggingSegue" {
            guard let destination = segue.destination as? ZoomedPhotoViewController else {
                fatalError("unexpected view controller for segue")
            }
						destination.imageTagSettings()
        }
    }
}

extension TaggingViewController: UpdateColorDelegate {
    func updateColor(selectedColor: UIColor) {			
				guard let photo: Photograph = PhotographManager.sharedInstance.selectedPhotograph else { return }
				photo.editColor(selectedColorId: selectedColor.toHexString())
				self.tableView.reloadData()
    }
}

// MARK: - keyboard handle

extension TaggingViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
				guard
					let photo: Photograph = PhotographManager.sharedInstance.selectedPhotograph,
					let tag: String = textField.text else { return false }
				photo.appendTag(tag: tag)
				self.tableView.reloadData()
				self.textField.text = ""
				self.textField.resignFirstResponder()
				return true
    }
    
    func keyboardSettings() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateTextView(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateTextView(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.textField.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    @objc func updateTextView(notification: Notification) {
        if let userInfo = notification.userInfo {
            let keyboardFrameScreenCoordinates = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            
            let keyboardFrame = self.view.convert(keyboardFrameScreenCoordinates, to: view.window)
            
            if notification.name == UIResponder.keyboardWillHideNotification {
                view.frame.origin.y = 0
            } else {
                view.frame.origin.y = -keyboardFrame.height
            }
        }
        fitting(animated: true)
    }
	
}
