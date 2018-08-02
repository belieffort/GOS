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

    var userID:String!
    var titleBox:String!
    var time:String!
    var location:String!
    var people:String!
    var position:String!
    var notice:String!
    var sports:String!
    var nowKey:[String] = []
   
    
    var favoriteBarButtonOn:UIBarButtonItem!
    var favoriteBarButtonOFF:UIBarButtonItem!
    var favoriteStatus:Bool = true
    var userUid = Auth.auth().currentUser?.uid
    var userEmail = Auth.auth().currentUser?.email
    var keyofview:String?
    var anotherUserUID:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialButton()
        getUserUID()
        
        writerUserID.text = userID
        detailTitle.text = titleBox
        detailTime.text = time
        detailLocation.text = location
        detailPeople.text = people
        detailPosition.text = position
        detailNotice.text = notice
        detailNotice.isEditable = false
//        showProfileImage()

        
        favoriteBarButtonOn = UIBarButtonItem(image: UIImage(named: "beforeStar"), style: .plain, target: self, action: #selector(didTapFavoriteBarButtonOn))
        favoriteBarButtonOFF = UIBarButtonItem(image: UIImage(named: "afterStar"), style: .plain, target: self, action: #selector(didTapFavoriteBarButtonOFF))
        
}
    func initialButton() {
        ref = Database.database().reference()
        ref.child("Users").child(userUid!).child("Likeit").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapDict = snapshot.value as? [String:AnyObject]{
                for each in snapDict {
                    self.nowKey.append(each.key)
                }
            }
            
            if self.nowKey.contains("\(self.keyofview!)") {
                self.navigationItem.rightBarButtonItems = [self.favoriteBarButtonOFF]
                } else {
                self.navigationItem.rightBarButtonItems = [self.favoriteBarButtonOn]
            }
        })
    }

    @objc func didTapFavoriteBarButtonOn() {
        
        self.navigationItem.setRightBarButtonItems([self.favoriteBarButtonOFF], animated: false)
        favoriteStatus = true
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
            
            self.ref.child("Users").child(userUid!).child("Likeit").child("\(keyofview!)").setValue(mdata)
        }
        
        print("Show Favorites")
    }
    
    @objc func didTapFavoriteBarButtonOFF() {
        self.navigationItem.setRightBarButtonItems([self.favoriteBarButtonOn], animated: false)
        print("Show All Chat Rooms")
    
        ref.child("Users").child(userUid!).child("Likeit").child("\(keyofview!)").removeValue()
        
    }
    
    @IBAction func joinSports(_ sender: Any) {
        //TODO - 버튼을 눌렀을 때, User의 Email을 Recruitment 의 JoinPeople에 추가한다.
        //누를 때에는 로그인한 사람의 정보를 얻을 수 있다.
        //error 1. 버튼을 누르면 해당 셀이 흰색으로 변하면서, 해당 셀을 누르면 keyofview에서 오류가 난다.
        
        self.ref.child("Recruitment").child("\(keyofview!)").child("Join").setValue(["\(userUid!)" : "\(userEmail!)"])
        viewWillAppear(true)
 
    }
    
    @IBAction func checkAttendant(_ sender: Any) {
         performSegue(withIdentifier: "AttendantSegue", sender: self)
        
    }
    
    func getUserUID() {
        ref = Database.database().reference()
            ref.child("Users").queryOrdered(byChild: "email").queryEqual(toValue: userID).observe(.childAdded, with: {snapshot in
                let writerUID = snapshot.key
                print("NOW!!! \(writerUID)")
                if writerUID != self.userID! {
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "AttendantSegue" {
            
            //        let recruitmentSnapshot: DataSnapshot! = self.recruitment[seletedCollectionViewCell.item]
            //        guard let recruit = recruitmentSnapshot.value as? [String:String] else { return }
            //
            //        // TODO - Recruitment의 child name을 찾으면 된다!!
            //        let detailViewController = segue.destination as! DetailViewController
            //        detailViewController.userID = recruit["Writer"] ?? "[Writer]"
            //        detailViewController.titleBox = recruit["Title"] ?? "[Title]"
            //        detailViewController.time = recruit["Time"] ?? "[Time]"
            //        detailViewController.location = recruit["Location"] ?? "[Location]"
            //        detailViewController.people = recruit["NumberOfPeople"] ?? "[NumberOfPeople]"
            //        detailViewController.position = recruit["Position"] ?? "[Position]"
            //        detailViewController.notice = recruit["Detail"] ?? "[Detail]"
            //        detailViewController.sports = recruit["Sports"] ?? "[Sports]"
            //
            //        let keySnapshot: DataSnapshot! = self.recruitment[seletedCollectionViewCell.item]
            //        keyOfNowView = keySnapshot.key
            //        detailViewController.keyofview = keyOfNowView

            
        }
        
        
    }
    

}
