//
//  ChatVC.swift
//  GOS
//
//  Created by 한병두 on 2018. 8. 22..
//  Copyright © 2018년 Byungdoo Han. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class ChatVC: UIViewController {
    
    @IBOutlet weak var chatTableView:UITableView!
    @IBOutlet weak var chatTextField:UITextField!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    var ref: DatabaseReference!
    var Messages: [DataSnapshot]! = []
    var _refHandle: DatabaseHandle?
    
    var userUID = Auth.auth().currentUser?.uid
    var receiverUID:String?
    var receriverImage:String?
    var roomUID:String?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        configureDatabase()
        self.chatTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        //tableview line 제거해준다.
        self.tabBarController?.tabBar.isHidden = true
        
        let tap :UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
   
    //시작
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    //종료
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @objc func keyboardWillShow(notification:Notification) {
        if let keyboardSize = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.bottomConstraint.constant = keyboardSize.height + 5
        }
        
        UIView.animate(withDuration: 0, animations: {
            self.view.layoutIfNeeded()
        }, completion: {
            (complete) in
            if self.Messages.count > 0 {
                self.chatTableView.scrollToRow(at: IndexPath(item: self.Messages.count-1 , section: 0), at: UITableView.ScrollPosition.bottom, animated: true)
            }
            
        })
    }
    
    @objc func keyboardWillHide(notification:Notification) {
        self.bottomConstraint.constant = 5
        self.view.layoutIfNeeded()
        
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    
    @IBAction func btnSend(_ sender: Any) {
        var mdata = [String:String]()
        mdata["text"] = chatTextField.text
        mdata["sender"] = userUID!
        mdata["receiver"] = receiverUID!
        
        ref.child("chatroom").childByAutoId().setValue(mdata, withCompletionBlock: { (err, ref) in
            self.chatTextField.text = ""
            
        })
      
    }
    
    deinit {
        if let refHandle = _refHandle {
            self.ref.child("chatroom").removeObserver(withHandle: refHandle)}
    }
    
    func configureDatabase() {

        _refHandle = self.ref.child("chatroom")
            .observe(.childAdded, with: { [weak self] (snapshot) in
                guard let strongSelf = self else { return }

                let messageSnapshot:DataSnapshot! = snapshot
                guard let message = messageSnapshot.value as? [String:String] else { return }

                let sender = message["sender"]
                let receiver = message["receiver"]

                    if (sender == self?.receiverUID || sender == Auth.auth().currentUser?.uid)
                        && (receiver == self?.receiverUID || receiver == Auth.auth().currentUser?.uid) {
                        strongSelf.Messages.append(snapshot)
                        strongSelf.chatTableView.insertRows(at: [IndexPath(row: strongSelf.Messages.count-1, section: 0)], with: .automatic)
                        if strongSelf.Messages.count > 0 {
                            strongSelf.chatTableView.scrollToRow(at: IndexPath(item: strongSelf.Messages.count-1 , section: 0), at: UITableView.ScrollPosition.bottom, animated: true)
                        }

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

class SenderCell: UITableViewCell {
    
    @IBOutlet weak var sender_message:UILabel!
    
}

class ReceiverCell: UITableViewCell {
    
    @IBOutlet weak var receiver_message:UILabel!
    @IBOutlet weak var receiver_Image: UIImageView!
    
}


extension ChatVC:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let messageSnapshot:DataSnapshot! = self.Messages[indexPath.row]
        guard let message = messageSnapshot.value as? [String:String] else { return UITableViewCell()}
        let sender = message["sender"]
        
        if (sender == receiverUID!) {
            let cell = chatTableView.dequeueReusableCell(withIdentifier: "ReceiverCell") as! ReceiverCell
            let messageSnapshot:DataSnapshot! = self.Messages[indexPath.row]
            guard let message = messageSnapshot.value as? [String:String] else { return cell }
            let text = message["text"] ?? "[text]"
            cell.receiver_message.text = text
            return cell

        } else {
            let cell = chatTableView.dequeueReusableCell(withIdentifier: "SenderCell") as! SenderCell
            let messageSnapshot:DataSnapshot! = self.Messages[indexPath.row]
            guard let message = messageSnapshot.value as? [String:String] else { return cell }
            let text = message["text"] ?? "[text]"
            cell.sender_message.text = text
            return cell
        }
    }
}
