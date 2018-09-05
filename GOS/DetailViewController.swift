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
    var userUID = Auth.auth().currentUser?.uid
    var userEmail = Auth.auth().currentUser?.email
    var userImageURL:String?
    
    var postAutokey:String?
    var anotherUserUID:String?
    var commentKey:String?
    
    
    //get uid(test)
    var attendUIDArr = [String]()
    var attendPeopleSnapshot:[DataSnapshot]! = []
    
    
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
        getAttendUID()
        
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
        ref.child("Join").child(userUID!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapDict = snapshot.value as? [String:AnyObject]{
                for each in snapDict {
                    if each.key == self.postAutokey! && each.value as! Bool == true {
                        self.joinStatusText.setTitle("참석 취소하기", for: .normal)
                        self.isJoin = true
                        break
                    } else {
                        self.joinStatusText.setTitle("참석하기", for: .normal)
                        self.isJoin = false
                    }
                }
            } else {
                self.joinStatusText.setTitle("참석하기", for: .normal)
                self.isJoin = false
            }
        })
    }
    
    func initialButton() {
        ref.child("Users").child(userUID!).child("LikePost").observeSingleEvent(of: .value, with: { (snapshot) in

            if let snapDict = snapshot.value as? [String:AnyObject]{
                for each in snapDict {
                    if each.value as! Bool == true {
                    self.nowKey.append(each.key)
                    }
                }
            }
            if self.postAutokey != nil {
                if self.nowKey.contains("\(self.postAutokey!)") {
                    self.navigationItem.rightBarButtonItems = [self.favoriteBarButtonOFF]
                } else {
                    self.navigationItem.rightBarButtonItems = [self.favoriteBarButtonOn]
                }
            } else {
                print("현재 유저의 관심 일정이 없습니다.")
            }
        })
    }

    @objc func didTapFavoriteBarButtonOn() {
        self.navigationItem.setRightBarButtonItems([self.favoriteBarButtonOFF], animated: false)
        if favoriteStatus == true {
            self.navigationItem.rightBarButtonItem = self.favoriteBarButtonOFF
            
            var mdata = [String:Bool]()

            mdata["\(postAutokey!)"] = true
            ref.child("Users").child(userUID!).child("LikePost").updateChildValues(mdata)
   
        }
        print("Show Favorites")
    }
    
    @objc func didTapFavoriteBarButtonOFF() {
        self.navigationItem.setRightBarButtonItems([self.favoriteBarButtonOn], animated: false)
        print("Show All Chat Rooms")
        var mdata = [String:Bool]()

        mdata["\(postAutokey!)"] = false
        ref.child("Users").child(userUID!).child("LikePost").updateChildValues(mdata)

    }
    
    
    //TODO: - AttendantVC에 attendUIDArr전달한다.
    func getAttendUID() {
        ref.child("Join").queryOrdered(byChild: "\(postAutokey!)").queryEqual(toValue: true).observe(.value, with: { (snapshot) in
            if let getTestUID = snapshot.value as? [String:AnyObject]{
                for each in getTestUID {
                    self.attendUIDArr.append(each.key)
                }
            }
            self.getAttendSnapshot()
        })
    }
    
    func getAttendSnapshot() {
        for i in attendUIDArr {
            ref.child("Users").child(i).observe(.value, with: { (snapshot) in
                self.attendPeopleSnapshot.append(snapshot)
            })
        }
    }
    
    @IBAction func joinSports(_ sender: Any) {
        var mdata = [String:Bool]()
        
        if isJoin! == true {
            //삭제
            mdata["\(postAutokey!)"] = false
            ref.child("Join").child(userUID!).updateChildValues(mdata)

            self.joinStatusText.setTitle("참석하기", for: .normal)
            self.isJoin = false

        } else if isJoin! == false {
            //업로드
            mdata["\(postAutokey!)"] = true
            ref.child("Join").child(userUID!).updateChildValues(mdata)

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
        ref.child("Users").child(userUID!).child("profileImage").observeSingleEvent(of: .value, with: { (snapshot) in
            if let userInfo = snapshot.value as? String {
            self.userImageURL = userInfo
            }
        })
    }
    
    func showProfileImage() {
        if userUID != anotherUserUID {
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
            Database.database().reference().child("Users").child(self.userUID!).child("profileImage").observeSingleEvent(of: .value, with: { snapshot in
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
        
        // Push data to Firebase Database
        self.ref.child("Recruitment").child("\(postAutokey!)").child("Comment").childByAutoId().setValue(mdata)
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
        _refHandle = self.ref.child("Recruitment").child("\(postAutokey!)").child("Comment").observe(.childAdded, with: { [weak self] (snapshot) -> Void in
            guard let strongSelf = self else { return }

                strongSelf.comments.append(snapshot)
                strongSelf.replyTableView.insertRows(at: [IndexPath(row: strongSelf.comments.count-1, section: 0)], with: .automatic)
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AttendantSegue" {
            let attendantViewController = segue.destination as! AttendantViewController
            attendantViewController.attendPeople = attendPeopleSnapshot
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
        
//        if let url = comment["UserProfileImage"] {
//            URLSession.shared.dataTask(with: URL(string: url as! String)!) { data, response, error in
//
//                if error != nil {
//                    print(error as Any)
//                    return
//                }
//                DispatchQueue.main.async {
//                    let image = UIImage(data: data!)
//                    cell.reply_UserImage.image = image
//                }
//                }.resume()
//        }
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
            ref.child("Recruitment").child("\(postAutokey!)").child("Comment")
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

