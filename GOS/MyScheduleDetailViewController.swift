//
//  MyScheduleDetailViewController.swift
//  GOS
//
//  Created by 한병두 on 2018. 7. 31..
//  Copyright © 2018년 Byungdoo Han. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class MyScheduleDetailViewController: UIViewController {

    @IBOutlet weak var my_ReplyTextField: UITextField!
    @IBOutlet weak var my_ReplyTableView: UITableView!
    @IBOutlet weak var my_writerImage: UIImageView!
    @IBOutlet weak var my_writerUserId: UILabel!
    @IBOutlet weak var my_detailTitle: UILabel!
    @IBOutlet weak var my_detailTime: UILabel!
    @IBOutlet weak var my_detailLocation: UILabel!
    @IBOutlet weak var my_detailPeople: UILabel!
    @IBOutlet weak var my_detailPosition: UILabel!
    @IBOutlet weak var my_detailNotice: UITextView!
    @IBOutlet weak var my_btnJoinText: UIButton!
    
    var my_userID:String!
    var my_titleBox:String!
    var my_time:String!
    var my_location:String!
    var my_people:String!
    var my_position:String!
    var my_notice:String!
    var my_sports:String!
    var my_PostKey:String?
    var passedSelectedIndexpath:DataSnapshot!
    
    var ref: DatabaseReference!
    var comments: [DataSnapshot]! = []
    var _refHandle: DatabaseHandle?
    var userUid = Auth.auth().currentUser?.uid
    var userEmail = Auth.auth().currentUser?.email
    var userImageURL:String?
    var anotherUserUID:String?
    var isJoin:Bool?
    var joinKey:[String] = []
    var commentKey:String?


    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        my_ReplyTableView.endUpdates()
        my_ReplyTableView.tableFooterView = UIView()
        configureDatabase()
        getUserUID()
        joinStatus()

        
        my_writerUserId.text = my_userID
        my_detailTitle.text = my_titleBox
        my_detailTime.text = my_time
        my_detailLocation.text = my_location
        my_detailPeople.text = my_people
        my_detailPosition.text = my_position
        my_detailNotice.text = my_notice
        
        
        let edit = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped))
        let delete = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(trashTapped))
        my_writerImage.isUserInteractionEnabled = true
        my_writerImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped)))

        navigationItem.rightBarButtonItems = [delete, edit]
    }
    
    @objc private func imageTapped(_ recognizer: UITapGestureRecognizer) {
        print("image tapped")
        performSegue(withIdentifier: "MyToUserProfileDetail", sender: self)
    }
    
    @objc func editTapped() {
        self.performSegue(withIdentifier: "EditPageSegue", sender: self)
    }
    
    @objc func trashTapped() {
        
    }
    
    func joinStatus() {
        ref = Database.database().reference()
        ref.child("Recruitment").child("\(my_PostKey!)").child("Join").observeSingleEvent(of: .value, with: { (snapshot) in

            if let snapDict = snapshot.value as? [String:AnyObject]{
                for each in snapDict {
                    self.joinKey.append(each.key)
                }
            }
            if self.joinKey.contains(self.userUid!) {
                self.my_btnJoinText.setTitle("참석 취소하기", for: .normal)
                self.isJoin = true
            } else {
                self.my_btnJoinText.setTitle("참석하기", for: .normal)
                self.isJoin = false
            }
        })
    }
    
    
    @IBAction func my_JoinSports(_ sender: Any) {
        if isJoin! == true {
            //삭제
            ref.child("Recruitment").child("\(my_PostKey!)").child("Join").child("\(userUid!)").removeValue()
            self.my_btnJoinText.setTitle("참석하기", for: .normal)
            self.isJoin = false
            
        } else if isJoin! == false {
            //업로드
            ref.child("Recruitment").child("\(my_PostKey!)").child("Join").updateChildValues(["\(userUid!)" : "\(userEmail!)"])
            self.my_btnJoinText.setTitle("참석 취소하기", for: .normal)
            self.isJoin = true
        }

    }
    
    @IBAction func my_CheckAttendant(_ sender: Any) {
        
    }
    @IBAction func my_BtnSendReply(_ sender: Any) {
        
        if my_ReplyTextField.text != nil {
            var mdata = [String:String]()
            mdata["Comment"] = my_ReplyTextField.text
            mdata["Replier"] = userEmail
            mdata["UserProfileImage"] = userImageURL
            
            // Push data to Firebase Database
            self.ref.child("Recruitment").child("\(my_PostKey!)").child("Comment").childByAutoId().setValue(mdata)
            my_ReplyTextField.text = nil
            
        } else {
            //TODO - 토스트 메세지를 보여준다.
            print("Comment를 입력해주세요.")
        }
    }
    
    
    func getUserUID() {
        ref = Database.database().reference()
        ref.child("Users").queryOrdered(byChild: "email").queryEqual(toValue: my_userID).observe(.childAdded, with: {snapshot in
            let writerUID = snapshot.key
//            print("NOW!!! \(writerUID)")
            if writerUID != self.my_userID! {
                self.anotherUserUID = writerUID
//                print("configureDatabase \(self.anotherUserUID!)")
                self.showProfileImage()
            } else {
                print("nope")
                self.showProfileImage()
            }
        })
    }
    
    
    func showProfileImage() {
//        print("showProfileImage \(self.anotherUserUID!)")
        if userUid != anotherUserUID {
            Database.database().reference().child("Users").child(anotherUserUID!).child("profileImage").observeSingleEvent(of: .value, with: { snapshot in
                if let url = snapshot.value as? String {
                    URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
                        
                        if error != nil {
                            print(error as Any)
                            return
                        }
                        DispatchQueue.main.async {
                            let image = UIImage(data: data!)
                            self.my_writerImage.image = image
                            
                        }
                        }.resume()
                }
            })
        } else {
            Database.database().reference().child("Users").child(self.userUid!).child("profileImage").observeSingleEvent(of: .value, with: { snapshot in
                if let url = snapshot.value as? String {
                    URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
                        
                        if error != nil {
                            print(error as Any)
                            return
                        }
                        DispatchQueue.main.async {
                            let image = UIImage(data: data!)
                            self.my_writerImage.image = image
                            
                        }
                        }.resume()
                }
            })
        }
    }
    
   
    
    deinit {
        if let refHandle = _refHandle {
            self.ref.child("Recruitment").removeObserver(withHandle: refHandle)}
    }
    
    func configureDatabase() {
        my_ReplyTableView.beginUpdates()
        
        ref = Database.database().reference()
        // Listen for new messages in the Firebase database
        _refHandle = self.ref.child("Recruitment").child("\(my_PostKey!)").child("Comment").observe(.childAdded, with: { [weak self] (snapshot) -> Void in
            guard let strongSelf = self else { return }
            
            strongSelf.comments.append(snapshot)
            strongSelf.my_ReplyTableView.insertRows(at: [IndexPath(row: strongSelf.comments.count-1, section: 0)], with: .automatic)
        })
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "AttendantSegue" {
            let attendantViewController = segue.destination as! AttendantViewController
            attendantViewController.passedKey = joinKey
        } else if segue.identifier == "EditPageSegue" {
        let myWriteEdit: DataSnapshot! = passedSelectedIndexpath
        guard let writeEdit = myWriteEdit.value as? [String:String] else { return }
        
        let myWriteEditViewController = segue.destination as! MyWriteEditViewController
        myWriteEditViewController.passedBox = writeEdit["Location"] ?? "[Location]"
        } else if segue.identifier == "MyToUserProfileDetail" {
            let myToUserProfileDetail = segue.destination as! ProfileUserInfoViewController
//            myToUserProfileDetail.passedBox = "마이 페이지에서 온 데이터"
            
        }
    
    }
}

extension MyScheduleDetailViewController:UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = my_ReplyTableView.dequeueReusableCell(withIdentifier: "MyWriteReplyCell", for: indexPath) as! MyReplyTableViewCell
        
        let commentSnapshot: DataSnapshot! = self.comments[indexPath.row]
        guard let comment = commentSnapshot.value as? [String:String] else { return cell }

        cell.delegate = self
        cell.my_ReplyUserEmail.text = comment["Replier"] ?? "[Replier]"
        cell.my_ReplyUserComment.text = comment["Comment"] ?? "[Comment]"
        if userEmail != comment["Replier"] {
            cell.btnDeleteBackGroundView.isHidden = true
        }
        cell.my_ReplyUserComment.sizeToFit()
        if let url = comment["UserProfileImage"] {
            URLSession.shared.dataTask(with: URL(string: url as! String)!) { data, response, error in
                
                if error != nil {
                    print(error as Any)
                    return
                }
                DispatchQueue.main.async {
                    let image = UIImage(data: data!)
                    cell.my_ReplyUserImge.image = image
                }
                }.resume()
        }
        return cell
        
    }
    
}

extension MyScheduleDetailViewController:My_ReplyDeleteDelegate {
    
    func didTapDelete(_ sender: UIButton) {
        ref = Database.database().reference()
        
        let btnPosition = sender.convert(sender.bounds.origin, to: my_ReplyTableView)
        if let indexPath = my_ReplyTableView.indexPathForRow(at: btnPosition) {
            let rowIndex =  indexPath.row
            let replierSnapshot: DataSnapshot! = self.comments?[rowIndex]
            commentKey = replierSnapshot.key
            ref.child("Recruitment").child("\(my_PostKey!)").child("Comment").child("\(commentKey!)").removeValue()
            comments.remove(at: rowIndex)
            my_ReplyTableView.reloadData()
        } else {
            print("index error")
        }
    }
    
}
