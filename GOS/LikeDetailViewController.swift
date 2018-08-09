//
//  LikeDetailViewController.swift
//  GOS
//
//  Created by 한병두 on 2018. 7. 30..
//  Copyright © 2018년 Byungdoo Han. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class LikeDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var like_ReplyTableView: UITableView!
    @IBOutlet weak var writerImage: UIImageView!
    @IBOutlet weak var like_writerUserId: UILabel!
    @IBOutlet weak var like_detailTitle: UILabel!
    @IBOutlet weak var like_detailTime: UILabel!
    @IBOutlet weak var like_detailLocation: UILabel!
    @IBOutlet weak var like_detailPeople: UILabel!
    @IBOutlet weak var like_detailPosition: UILabel!
    @IBOutlet weak var like_detailNotice: UITextView!
    @IBOutlet weak var like_BtnJoinText: UIButton!
    @IBOutlet weak var like_ReplyTextField: UITextField!
    
    var like_userId:String!
    var like_titleBox:String!
    var like_time:String!
    var like_location:String!
    var like_people:String!
    var like_position:String!
    var like_notice:String!
    var like_sports:String!
    var keyOfUserLike:String!

    var ref: DatabaseReference!
    var comments: [DataSnapshot]! = []
    var _refHandle: DatabaseHandle?
    var userEmail = Auth.auth().currentUser?.email
    var userUid = Auth.auth().currentUser?.uid
    var anotherUserUID:String?
    var isJoin:Bool?
    var userImageURL:String?
    var joinKey:[String] = []


    
    override func viewDidLoad() {
        super.viewDidLoad()
        like_ReplyTableView.endUpdates()
        like_ReplyTableView.tableFooterView = UIView()

        configureDatabase()
        getUserUID()
        joinStatus()
        
        like_writerUserId.text = like_userId
        like_detailTitle.text = like_titleBox
        like_detailTime.text = like_time
        like_detailLocation.text = like_location
        like_detailPeople.text = like_people
        like_detailPosition.text = like_position
        like_detailNotice.text = like_notice
        like_detailNotice.isEditable = false
        

    }
    
    func joinStatus() {
        ref = Database.database().reference()
        ref.child("Recruitment").child("\(keyOfUserLike!)").child("Join").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let snapDict = snapshot.value as? [String:AnyObject]{
                for each in snapDict {
                    self.joinKey.append(each.key)
                }
            }
            if self.joinKey.contains(self.userUid!) {
                self.like_BtnJoinText.setTitle("참석 취소하기", for: .normal)
                self.isJoin = true
            } else {
                self.like_BtnJoinText.setTitle("참석하기", for: .normal)
                self.isJoin = false
            }
        })
    }
    
    
    @IBAction func like_JoinSports(_ sender: Any) {
        if isJoin! == true {
            //삭제
            ref.child("Recruitment").child("\(keyOfUserLike!)").child("Join").child("\(userUid!)").removeValue()
            self.like_BtnJoinText.setTitle("참석하기", for: .normal)
            self.isJoin = false
            
        } else if isJoin! == false {
            //업로드
            ref.child("Recruitment").child("\(keyOfUserLike!)").child("Join").updateChildValues(["\(userUid!)" : "\(userEmail!)"])
            self.like_BtnJoinText.setTitle("참석 취소하기", for: .normal)
            self.isJoin = true
        }
    }
    
    @IBAction func like_CheckAttendant(_ sender: Any) {
        
    }
    
    @IBAction func btnSendReply(_ sender: Any) {
        //TODO - 처음에는 프로필 사진이 없다가 추가했을 때에는, 어떻게 대응할 것인지?
        //TODO - 왜 if 조건이 안되는지...?
        if like_ReplyTextField.text != nil {
            var mdata = [String:String]()
            mdata["Comment"] = like_ReplyTextField.text
            mdata["Replier"] = userEmail
            mdata["UserProfileImage"] = userImageURL
            
            // Push data to Firebase Database
            self.ref.child("Recruitment").child("\(keyOfUserLike!)").child("Comment").childByAutoId().setValue(mdata)
            like_ReplyTextField.text = nil
            
        } else {
            //TODO - 토스트 메세지를 보여준다.
            print("Comment를 입력해주세요.")
        }
    }
    
    func getUserUID() {
        ref = Database.database().reference()
        ref.child("Users").queryOrdered(byChild: "email").queryEqual(toValue: like_userId).observe(.childAdded, with: {snapshot in
            let writerUID = snapshot.key
            print("NOW!!! \(writerUID)")
            if writerUID != self.like_userId! {
                self.anotherUserUID = writerUID
                print("configureDatabase \(self.anotherUserUID!)")
                self.showProfileImage()
            } else {
                print("nope")
                self.showProfileImage()
            }
        })
    }
    
    
    func showProfileImage() {
        print("showProfileImage \(self.anotherUserUID!)")
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
                            self.writerImage.image = image
                            
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
                            self.writerImage.image = image
                            
                        }
                        }.resume()
                }
            })
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = like_ReplyTableView.dequeueReusableCell(withIdentifier: "LikeReplyCell", for: indexPath) as! LikeReplyTableViewCell
        
        let commentSnapshot: DataSnapshot! = self.comments[indexPath.row]
        guard let comment = commentSnapshot.value as? [String:String] else { return cell }
        
        cell.like_ReplyUserEmail.text = comment["Replier"] ?? "[Replier]"
        cell.like_ReplyUserComment.text = comment["Comment"] ?? "[Comment]"
        cell.like_ReplyUserComment.sizeToFit()
        if let url = comment["UserProfileImage"] {
            URLSession.shared.dataTask(with: URL(string: url as! String)!) { data, response, error in
                
                if error != nil {
                    print(error as Any)
                    return
                }
                DispatchQueue.main.async {
                    let image = UIImage(data: data!)
                    cell.like_ReplyUserImage.image = image
                }
                }.resume()
        }
        return cell
        
    }
    
    deinit {
        if let refHandle = _refHandle {
            self.ref.child("Recruitment").removeObserver(withHandle: refHandle)}
    }
    
    func configureDatabase() {
        like_ReplyTableView.beginUpdates()
        
        ref = Database.database().reference()
        // Listen for new messages in the Firebase database
        _refHandle = self.ref.child("Recruitment").child("\(keyOfUserLike!)").child("Comment").observe(.childAdded, with: { [weak self] (snapshot) -> Void in
            guard let strongSelf = self else { return }
            
            strongSelf.comments.append(snapshot)
            strongSelf.like_ReplyTableView.insertRows(at: [IndexPath(row: strongSelf.comments.count-1, section: 0)], with: .automatic)
        })
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "AttendantSegue" {
            let attendantViewController = segue.destination as! AttendantViewController
            attendantViewController.passedKey = joinKey
        }
    }
   


}
