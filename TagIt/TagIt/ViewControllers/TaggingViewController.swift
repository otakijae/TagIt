//
//  TaggingViewController.swift
//  TagIt
//
//  Created by 신재혁 on 20/02/2019.
//  Copyright © 2019 ninetyfivejae. All rights reserved.
//

import UIKit

let BGColor = UIColor(displayP3Red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)

class ModalNavigationController: UINavigationController {
    
    weak var semiModalPresentationController: SemiModalPresentationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        semiModalPresentationController = presentationController as? SemiModalPresentationController
        
        navigationBar.backgroundColor = BGColor
        view.backgroundColor = BGColor
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
    private var selectedIndexPath: IndexPath?
    
    var tagList = ["여행", "음식", "가족"]
    
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
        self.view.backgroundColor = BGColor
        self.tableView.backgroundColor = BGColor
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section:Int) -> String? {
        return "추가된 태그"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tagList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaggingViewCell", for: indexPath) as? TaggingViewCell else {
            return UITableViewCell()
        }
        
        cell.tagLabel.text = tagList[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "AddTagSegue", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddTagSegue" {
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
            
            var tagString: String = ""
            for tag in tagList {
                tagString.append("●" + tag + "\n")
            }
            
            destination.textView.text = tagString
            destination.textView.resolveHashTags()
            destination.textView.linkTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.blue]
        }
    }
}

extension TaggingViewController: UpdateColorDelegate {
    func updateColor(indexPath: IndexPath, selectedColor: String) {
        guard let cell = self.tableView.cellForRow(at: indexPath) as? TaggingViewCell else {
            return
        }
        cell.colorTagView.backgroundColor = UIColor(hexFromString: selectedColor)
    }
}

// MARK: - keyboard handle

extension TaggingViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tagList.append(String(textField.text!))
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
