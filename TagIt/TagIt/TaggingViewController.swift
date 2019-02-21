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
        
        navigationBar.barTintColor = BGColor
        view.backgroundColor = BGColor
        
//        navigationBar.layer.masksToBounds = true
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

    private var isFirst: Bool = true
    
    private var selectedIndexPath: IndexPath?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = BGColor
        tableView.backgroundColor = BGColor
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateTextView(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateTextView(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - keyboard handle
    
    //키보드 사라지게 하기위해서 구현
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.view.endEditing(true)
        //self.myUITextView.resignFirstResponder()
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
    
    // MARK: - Navigation
    
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

    @IBAction func done(_ sender: Any) {
        self.view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
}

extension TaggingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 3
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = "태그 추가"
        case 1:
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "여행"
            case 1:
                cell.textLabel?.text = "음식"
            case 2:
                cell.textLabel?.text = "가족"
            default: break
            }
            
        default:
            break
        }
        
        cell.accessoryType = indexPath == selectedIndexPath ? .checkmark : .none
        cell.backgroundColor = UIColor.clear
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = BGColor
        cell.backgroundView = backgroundView
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return CardCell.cellHeight
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 26
//    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let cell = tableView.cellForRow(at: indexPath), cell.selectionStyle == .none {
//            return
//        }
//
//        for visibleIndexPath in tableView.indexPathsForVisibleRows ?? [] {
//            if let cell = tableView.cellForRow(at: visibleIndexPath) {
//                cell.accessoryType = visibleIndexPath == indexPath ? .checkmark : .none
//            }
//        }
//
//        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "SuggestTagSegue", sender: self)
    }
}
