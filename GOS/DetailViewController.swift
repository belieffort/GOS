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

    @IBOutlet var detailViewController: UIView!
    var ref: DatabaseReference!
    var messages: [DataSnapshot]! = []
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
    
    var keyofview:String?
    var anotherUserUID:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserUID()
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
        print("FACT CHECKKKKKKKKKKKK \(isJoin)")
        
        if isJoin! == true {
            //삭제
            ref.child("Recruitment").child("\(keyofview!)").child("Join").child("\(userUid!)").removeValue()
            self.joinStatusText.setTitle("참석하기", for: .normal)
            self.isJoin = false
            print("TTTTTTTTTTTTTTTTTTTTT \(isJoin)")

        } else if isJoin! == false {
            //업로드
            ref.child("Recruitment").child("\(keyofview!)").child("Join").updateChildValues(["\(userUid!)" : "\(userEmail!)"])
            self.joinStatusText.setTitle("참석 취소하기", for: .normal)
            self.isJoin = true
            print("FFFFFFFFFFFFFFFFFFFF \(isJoin)")

        }
    }
    
    @IBAction func checkAttendant(_ sender: Any) {
//         performSegue(withIdentifier: "AttendantSegue", sender: self)
        
    }
    
    func getUserUID() {
        ref = Database.database().reference()
            ref.child("Users").queryOrdered(byChild: "email").queryEqual(toValue: userID).observe(.childAdded, with: {snapshot in
                let writerUID = snapshot.key
//                print("NOW!!! \(writerUID)")
                if writerUID != self.userID! {
                    self.anotherUserUID = writerUID
//                    print("configureDatabase \(self.anotherUserUID!)")
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "AttendantSegue" {
            let attendantViewController = segue.destination as! AttendantViewController
            attendantViewController.passedKey = joinKey
        }
    }
}
