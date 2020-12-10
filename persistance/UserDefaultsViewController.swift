//
//  UserDefailtsViewController.swift
//  persistance
//
//  Created by Ekaterina Stepanova on 25.09.20.
//

import UIKit

class UserDefaultsViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.text = Persistance.shared.userName
        surnameTextField.text = Persistance.shared.userSurname
    }
    
   
    @IBAction func nameChange(_ sender: Any) {
        Persistance.shared.userName = nameTextField.text!
    }
    
    @IBAction func surnameChange(_ sender: Any) {
        Persistance.shared.userSurname = surnameTextField.text!
    }
    

}
