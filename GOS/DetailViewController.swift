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

class DetailViewController: UIViewController {

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
    var postKey:[String] = []
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
    var commentKey:String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        replyTableView.endUpdates()
        replyTableView.estimatedRowHeight = replyTableView.rowHeight
        replyTableView.rowHeight = UITableView.automaticDimension
        replyTableView.tableFooterView = UIView()

        getUserUID()
        configureDatabase()
        getUserImageURL()
        initialButton()
        joinStatus()
        
        writerUserID.text = userID
        detailTitle.text = titleBox
        detailTime.text = time
        detailLocation.text = location
        detailPeople.text = people
        detailPosition.text = position
        detailNotice.text = notice
        detailNotice.isEditable = false
        self.hideKeyboardTappedAround()
        
        favoriteBarButtonOn = UIBarButtonItem(image: UIImage(named: "beforeStar"), style: .plain, target: self, action: #selector(didTapFavoriteBarButtonOn))
        favoriteBarButtonOFF = UIBarButtonItem(image: UIImage(named: "afterStar"), style: .plain, target: self, action: #selector(didTapFavoriteBarButtonOFF))
        
        writerImage.isUserInteractionEnabled = true
        writerImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped)))
        
}
    
   
    
    
    @objc private func imageTapped(_ recognizer: UITapGestureRecognizer) {
        performSegue(withIdentifier: "MainToUserProfileDetail", sender: self)
    }
    
    func joinStatus() {
        ref = Database.database().reference()
        ref.child("Join").child("\(keyofview!)").child("UserInfo")
            .observeSingleEvent(of: .value, with: { (snapshot) in

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
            mdata["WriterEmail"] = userID
            mdata["ProfileImage"] = userImageURL

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
        var mdata = [String:String]()
        
        if isJoin! == true {
//            //삭제
            ref.child("Join").child("\(keyofview!)").child("UserInfo").child("\(userUid!)").removeValue()
            ref.child("Users").child("\(userUid!)").child("\(keyofview!)").removeValue()

            self.joinStatusText.setTitle("참석하기", for: .normal)
            self.isJoin = false

        } else if isJoin! == false {
            //업로드
    
            mdata["Email"] = userEmail
            mdata["ProfileImage"] = userImageURL
            mdata["Title"] = titleBox
            mdata["Time"] = time
            mdata["Location"] = location
            
            ref.child("Join").child("\(keyofview!)").child("UserInfo").child("\(userUid!)").setValue(mdata)
            ref.child("Users").child("\(userUid!)").child("Join").child("\(keyofview!)").setValue(mdata)

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
            } else {
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
    
    
    @IBAction func btnSendReply(_ sender: Any) {
        //TODO - 만약 TextField에 작성된 내용이 있다면, TextField에 작성된 내용을 Firebase에 업로드한다. ㅇ
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
        if segue.identifier == "AttendantSegue" {
            let attendantViewController = segue.destination as! AttendantViewController
            attendantViewController.passedKey = keyofview!
        } else if segue.identifier == "MainToUserProfileDetail" {

            
            let mainToUserProfileDetail = segue.destination as! ProfileUserInfoViewController
            mainToUserProfileDetail.passEmail = userID
            mainToUserProfileDetail.passUID = anotherUserUID
            ref.child("Recruitment").observeSingleEvent(of: .value, with: { (snapshot) in
                if let snapDict = snapshot.value as? [String:AnyObject]{
                    for each in snapDict {
                        self.postKey.append(each.key)
                    }
                    mainToUserProfileDetail.passKeyBox = self.postKey
                }
            })
            
        }
    }
}

extension DetailViewController:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = replyTableView.dequeueReusableCell(withIdentifier: "ReplyCell", for: indexPath) as! ReplyTableViewCell
        
        let commentSnapshot: DataSnapshot! = self.comments[indexPath.row]
        guard let comment = commentSnapshot.value as? [String:String] else { return cell }
        
        cell.delegate = self
        cell.reply_UserEmail.text = comment["Replier"] ?? "[Replier]"
        cell.reply_UserComment.text = comment["Comment"] ?? "[Comment]"
        
        if userEmail != comment["Replier"] {
            cell.btnDeleteBackGroundView.isHidden = true
        }
        
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
}


//댓글 삭제 부분
extension DetailViewController:ReplyDeleteDelegate {
    func didTapDelete(_ sender: UIButton) {

        let btnPosition = sender.convert(sender.bounds.origin, to: replyTableView)
        if let indexPath = replyTableView.indexPathForRow(at: btnPosition) {
            let rowIndex =  indexPath.row
            let replierSnapshot: DataSnapshot! = self.comments?[rowIndex]
            commentKey = replierSnapshot.key
            ref.child("Recruitment").child("\(keyofview!)").child("Comment")
                .child("\(commentKey!)").removeValue()
            comments.remove(at: rowIndex)
            replyTableView.reloadData()
        } else {
            print("index error")
        }
    }
}

//키보드
extension DetailViewController {
    func hideKeyboardTappedAround() {
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DetailViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
        }
    }

