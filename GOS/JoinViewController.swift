//
//  JoinViewController.swift
//  GOS
//
//  Created by 한병두 on 2018. 7. 16..
//  Copyright © 2018년 Byungdoo Han. All rights reserved.
//

import UIKit
import Firebase

class JoinViewController: UIViewController {

    @IBOutlet weak var join_emailTextField: UITextField!
    @IBOutlet weak var join_passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func join_btnPressed(_ sender: Any) {
        Auth.auth().createUser(withEmail: join_emailTextField.text!, password: join_passwordTextField.text!, completion: {_, error in
            if (error == nil) {
                self.performSegue(withIdentifier: "ToMainThroughJoin", sender: sender)
            }
        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
