//
//  SearchViewController.swift
//  TagIt
//
//  Created by 신재혁 on 24/02/2019.
//  Copyright © 2019 ninetyfivejae. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //텍스트필드에 포커스
        self.searchTextField.becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.view.endEditing(true)
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        self.view.endEditing(true)

        self.dismiss(animated: true, completion: nil)
    }
}
