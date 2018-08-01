//
//  DetailViewController.swift
//  GOS
//
//  Created by 한병두 on 2018. 7. 20..
//  Copyright © 2018년 Byungdoo Han. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase


class DetailViewController: UIViewController {

    var ref: DatabaseReference!
    var likeit: [DataSnapshot]! = []
    var _refHandle: DatabaseHandle?

    var homeViewController = HomeViewController()
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
    var userUIDBox:[String] = []
   
    
    
    var writeNumberBox:String!
    
    var favoriteBarButtonOn:UIBarButtonItem!
    var favoriteBarButtonOFF:UIBarButtonItem!
    var favoriteStatus:Bool = true
    var uid = Auth.auth().currentUser?.uid
    var passedIndex:IndexPath!
    var userEmail = Auth.auth().currentUser!.email!
    var keyBox:[String] = []
    var keyofview:String?
    var likeKeyValue:String?
    
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
        
        favoriteBarButtonOn = UIBarButtonItem(image: UIImage(named: "beforeStar"), style: .plain, target: self, action: #selector(didTapFavoriteBarButtonOn))
        favoriteBarButtonOFF = UIBarButtonItem(image: UIImage(named: "afterStar"), style: .plain, target: self, action: #selector(didTapFavoriteBarButtonOFF))
        
}
    

    func initialButton() {
        ref.child("Users").child(uid!).child("Likeit").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapDict = snapshot.value as? [String:AnyObject]{
                for each in snapDict{
                    self.nowKey.append(each.key)
//                    print(self.nowKey)
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
            
            self.ref.child("Users").child(uid!).child("Likeit").child("\(keyofview!)").setValue(mdata)
        }
        
        print("Show Favorites")
    }
    
    @objc func didTapFavoriteBarButtonOFF() {
        self.navigationItem.setRightBarButtonItems([self.favoriteBarButtonOn], animated: false)
        print("Show All Chat Rooms")
    
        ref.child("Users").child(uid!).child("Likeit").child("\(keyofview!)").removeValue()
        
    }
         deinit {
                if let refHandle = _refHandle {
                    self.ref.child("Users").removeObserver(withHandle: refHandle)
                }
    }
    
    
    func getUserUID() {
        ref = Database.database().reference()
//         Listen for new messages in the Firebase database
        _refHandle = self.ref.child("Users").observe(.childAdded, with: { [weak self] (snapshot) -> Void in
            guard let strongSelf = self else { return }

            let writerSnapshot: DataSnapshot! = snapshot
            guard let writerInfo = writerSnapshot.value as? [String:String] else { return }
            print(writerSnapshot.value)
            let writer = writerInfo["email"]
            if writer == strongSelf.userID! {
                strongSelf.anotherUserUID = writerSnapshot.key
                print("configureDatabase \(strongSelf.anotherUserUID!)")
                self?.showProfileImage()
            } else {
                self?.showProfileImage()
//                현재 유저의 이미지
            }
    })

}


    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "DetailViewController" {
//            let detailViewController:DetailViewController = segue.destination as! DetailViewController
//
//
//        }
//
//    }

    
    func showProfileImage() {
//        print("showProfileImage \(self.anotherUserUID!)")
        if uid != anotherUserUID {
        Database.database().reference().child("Users").child(anotherUserUID!).child("profileImage").observeSingleEvent(of: .value, with: { snapshot in
            if let url = snapshot.value as? String {
                URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            
                        if error != nil {
                            print(error)
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
            Database.database().reference().child("Users").child(self.uid!).child("profileImage").observeSingleEvent(of: .value, with: { snapshot in
                if let url = snapshot.value as? String {
                    URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
                        
                        if error != nil {
                            print(error)
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
    
}
