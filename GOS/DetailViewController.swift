//
//  DetailViewController.swift
//  GOS
//
//  Created by 한병두 on 2018. 7. 20..
//  Copyright © 2018년 Byungdoo Han. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var replyTableView: UITableView!
    @IBOutlet var detailViewController: UIView!
    var ref: DatabaseReference!
    var comments: [DataSnapshot]! = []
    var _refHandle: DatabaseHandle?

    @IBOutlet weak var writerImage: UIImageView!
    @IBOutlet weak var writerUserID: UILabel!
    @IBOutlet weak var detailTitle: UILabel!
    @IBOutlet weak var detailTime: UILabel!
    @IBOutlet weak var detailLocation: UILabel!
    @IBOutlet weak var detailPeople: UILabel!
    @IBOutlet weak var detailPosition: UILabel!
    @IBOutlet weak var detailNotice: UITextView!
    @IBOutlet weak var joinStatusText: UIButton!
    @IBOutlet weak var replyWriteTextField: UITextField!
    
    var userID:String!
    var titleBox:String!
    var time:String!
    var location:String!
    var people:String!
    var position:String!
    var notice:String!
    var sports:String!
    var nowKey:[String] = []
    var joinKey:[String] = []
    var isJoin:Bool?
   
    var favoriteBarButtonOn:UIBarButtonItem!
    var favoriteBarButtonOFF:UIBarButtonItem!
    var favoriteStatus:Bool = true
    var userUid = Auth.auth().currentUser?.uid
    var userEmail = Auth.auth().currentUser?.email
    var userImageURL:String?
    
    var keyofview:String?
    var anotherUserUID:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        replyTableView.beginUpdates()
        replyTableView.endUpdates()

        configureDatabase()
        getUserUID()
        getUserImageURL()
        initialButton()
        joinStatus()
        
        replyTableView.rowHeight = UITableView.automaticDimension
        replyTableView.estimatedRowHeight = 80
        replyTableView.tableFooterView = UIView()


        writerUserID.text = userID
        detailTitle.text = titleBox
        detailTime.text = time
        detailLocation.text = location
        detailPeople.text = people
        detailPosition.text = position
        detailNotice.text = notice
        detailNotice.isEditable = false
        
        favoriteBarButtonOn = UIBarButtonItem(image: UIImage(named: "beforeStar"), style: .plain, target: self, action: #selector(didTapFavoriteBarButtonOn))
        favoriteBarButtonOFF = UIBarButtonItem(image: UIImage(named: "afterStar"), style: .plain, target: self, action: #selector(didTapFavoriteBarButtonOFF))
        
}
    
    func joinStatus() {
        ref = Database.database().reference()
        ref.child("Recruitment").child("\(keyofview!)").child("Join").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let snapDict = snapshot.value as? [String:AnyObject]{
                for each in snapDict {
                    self.joinKey.append(each.key)
                }
            }
            if self.joinKey.contains(self.userUid!) {
                self.joinStatusText.setTitle("참석 취소하기", for: .normal)
                self.isJoin = true
            } else {
                self.joinStatusText.setTitle("참석하기", for: .normal)
                self.isJoin = false
            }
        })
    }
    
    func initialButton() {
        ref.child("Users").child(userUid!).child("Likeit").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapDict = snapshot.value as? [String:AnyObject]{
                for each in snapDict {
                    self.nowKey.append(each.key)
                }
            }
            if self.keyofview != nil {
                if self.nowKey.contains("\(self.keyofview!)") {
                    self.navigationItem.rightBarButtonItems = [self.favoriteBarButtonOFF]
                } else {
                    self.navigationItem.rightBarButtonItems = [self.favoriteBarButtonOn]
                }
            }
        })
    }
    

    @objc func didTapFavoriteBarButtonOn() {
        
        self.navigationItem.setRightBarButtonItems([self.favoriteBarButtonOFF], animated: false)
        if favoriteStatus == true {
            self.navigationItem.rightBarButtonItem = self.favoriteBarButtonOFF
            
            var mdata = [String:String]()
            
            mdata["Title"] = titleBox
            mdata["Sports"] = sports
            mdata["Time"] = time
            mdata["Location"] = location
            mdata["NumberOfPeople"] = people
            mdata["Position"] = position
            mdata["Detail"] = notice
            mdata["Writer"] = userID
            
            ref.child("Users").child(userUid!).child("Likeit").child("\(keyofview!)").setValue(mdata)
        }
        print("Show Favorites")
    }
    
    @objc func didTapFavoriteBarButtonOFF() {
        self.navigationItem.setRightBarButtonItems([self.favoriteBarButtonOn], animated: false)
        print("Show All Chat Rooms")
    
        ref.child("Users").child(userUid!).child("Likeit").child("\(keyofview!)").removeValue()
    }
    
    @IBAction func joinSports(_ sender: Any) {
        
        if isJoin! == true {
            //삭제
            ref.child("Recruitment").child("\(keyofview!)").child("Join").child("\(userUid!)").removeValue()
            self.joinStatusText.setTitle("참석하기", for: .normal)
            self.isJoin = false

        } else if isJoin! == false {
            //업로드
            ref.child("Recruitment").child("\(keyofview!)").child("Join").updateChildValues(["\(userUid!)" : "\(userEmail!)"])
            self.joinStatusText.setTitle("참석 취소하기", for: .normal)
            self.isJoin = true

        }
    }
    
    @IBAction func checkAttendant(_ sender: Any) {
//         performSegue(withIdentifier: "AttendantSegue", sender: self)
        
    }
    
    func getUserUID() {
        ref = Database.database().reference()
        ref.child("Users").queryOrdered(byChild: "email").queryEqual(toValue: userID).observe(.childAdded, with: {snapshot in
            let writerUID = snapshot.key
            if writerUID != self.userID! {
                self.anotherUserUID = writerUID
                self.showProfileImage()
            } else {
                print("nope")
                self.showProfileImage()
            }
        })
    }
    
    func getUserImageURL() {
        ref = Database.database().reference()
        ref.child("Users").child(userUid!).child("profileImage").observeSingleEvent(of: .value, with: { (snapshot) in
            if let userInfo = snapshot.value as? String {
            self.userImageURL = userInfo
                print("IMAGE URLLLLLLLLLLLLLLLLL\(self.userImageURL!)")
            } else {
                print("User don't have a profileimage")
            }
        })
            
        
    }
    
    func showProfileImage() {
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

        let cell = replyTableView.dequeueReusableCell(withIdentifier: "ReplyCell", for: indexPath) as! ReplyTableViewCell
        
        let commentSnapshot: DataSnapshot! = self.comments[indexPath.row]
        guard let comment = commentSnapshot.value as? [String:String] else { return cell }
        
        
        cell.reply_UserEmail.text = comment["Replier"] ?? "[Replier]"
        cell.reply_UserComment.text = comment["Comment"] ?? "[Comment]"
        if let url = comment["UserProfileImage"] {
            URLSession.shared.dataTask(with: URL(string: url as! String)!) { data, response, error in
                
                if error != nil {
                    print(error as Any)
                    return
                }
                DispatchQueue.main.async {
                    let image = UIImage(data: data!)
                    cell.reply_UserImage.image = image
                }
                }.resume()
        }
        return cell

    }
    
    @IBAction func btnSendReply(_ sender: Any) {
        //TODO - 만약 TextField에 작성된 내용이 있다면, TextField에 작성된 내용을 Firebase에 업로드한다.
        //TODO - 작성자 User의 image를 함께 넣어 놓는다.
        if replyWriteTextField.text != nil {
        var mdata = [String:String]()
        mdata["Comment"] = replyWriteTextField.text
        mdata["Replier"] = userEmail
        mdata["UserProfileImage"] = userImageURL
        
        // Push data to Firebase Database
        self.ref.child("Recruitment").child("\(keyofview!)").child("Comment").childByAutoId().setValue(mdata)
            replyWriteTextField.text = nil

        } else {
            //TODO - 토스트 메세지를 보여준다.
            print("Comment를 입력해주세요.")
        }
    }
    
    deinit {
        if let refHandle = _refHandle {
            self.ref.child("Recruitment").removeObserver(withHandle: refHandle)}
    }
    
    func configureDatabase() {
        replyTableView.beginUpdates()

        ref = Database.database().reference()
        // Listen for new messages in the Firebase database
        _refHandle = self.ref.child("Recruitment").child("\(keyofview!)").child("Comment").observe(.childAdded, with: { [weak self] (snapshot) -> Void in
            guard let strongSelf = self else { return }

                strongSelf.comments.append(snapshot)
                strongSelf.replyTableView.insertRows(at: [IndexPath(row: strongSelf.comments.count-1, section: 0)], with: .automatic)
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //TODO - DetailView에서 참석하기 누른 후, 참석자를 확인하면 업데이트가 되어 있지 않아있다.
        if segue.identifier == "AttendantSegue" {
            let attendantViewController = segue.destination as! AttendantViewController
            attendantViewController.passedKey = joinKey
        }
    }
}
