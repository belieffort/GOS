//
//  JoinViewController.swift
//  GOS
//
//  Created by 한병두 on 2018. 7. 16..
//  Copyright © 2018년 Byungdoo Han. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth


class JoinViewController: UIViewController {

    @IBOutlet weak var join_emailTextField: UITextField!
    @IBOutlet weak var join_passwordTextField: UITextField!
    
    var ref: DatabaseReference!
    var messages: [DataSnapshot]! = []
    var _refHandle: DatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDatabase()

    }
    
    @IBAction func join_btnPressed(_ sender: Any) {
        Auth.auth().createUser(withEmail: join_emailTextField.text!, password: join_passwordTextField.text!, completion: {_, error in
            if (error == nil) {
                self.performSegue(withIdentifier: "ToMainThroughJoin", sender: sender)
                
            }
        })
        
        var mdata = [String:String]()

        mdata["email"] = join_emailTextField.text

    self.ref.child("Users").childByAutoId().setValue(mdata)
    }
    
    deinit {
        //        if let refHandle = _refHandle {
        //            self.ref.child("messages").removeObserver(withHandle: _refHandle)
        //        }
    }
    
    func configureDatabase() {
        ref = Database.database().reference()
        // Listen for new messages in the Firebase database
        //        _refHandle = self.ref.child("messages").observe(.childAdded, with: { [weak self] (snapshot) -> Void in
        //            guard let strongSelf = self else { return }
        //            strongSelf.messages.append(snapshot)
        //            strongSelf.clientTable.insertRows(at: [IndexPath(row: strongSelf.messages.count-1, section: 0)], with: .automatic)
        //        })
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
