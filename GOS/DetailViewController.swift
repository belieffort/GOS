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

class DetailViewController: UIViewController {

    var ref: DatabaseReference!
    var likeit: [DataSnapshot]! = []
    var _refHandle: DatabaseHandle?

    var homeViewController = HomeViewController()
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
    var writeNumber:String!
    
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
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        //Recruitment에 있는 모든 키를 얻었다.
        Database.database().reference().child("Recruitment").observeSingleEvent(of: .value, with: {(Snapshot) in
            if let snapDict = Snapshot.value as? [String:AnyObject]{
                for each in snapDict{
                    self.keyBox.append(each.key)
                }
            }
        })
        print("key \(String(describing: keyofview!))")
        
        writerUserID.text = userID
        detailTitle.text = titleBox
        detailTime.text = time
        detailLocation.text = location
        detailPeople.text = people
        detailPosition.text = position
        detailNotice.text = notice
        configureDatabase()
        
        favoriteBarButtonOn = UIBarButtonItem(image: UIImage(named: "beforeStar"), style: .plain, target: self, action: #selector(didTapFavoriteBarButtonOn))
        favoriteBarButtonOFF = UIBarButtonItem(image: UIImage(named: "afterStar"), style: .plain, target: self, action: #selector(didTapFavoriteBarButtonOFF))


        ref.child("Users").child(uid!).child("Likeit").child("\(keyofview!) 의 Index").observe(.value, with: { (snapshot) in
            self.likeKeyValue = snapshot.value as? String

            if self.likeKeyValue == self.keyofview {
                self.navigationItem.rightBarButtonItems = [self.favoriteBarButtonOFF]
            } else {
                self.navigationItem.rightBarButtonItems = [self.favoriteBarButtonOn]
            }
        })
}

    @objc func didTapFavoriteBarButtonOn() {
//        print(self.keyBox)
//        print(self.keyBox.count)
        self.navigationItem.setRightBarButtonItems([self.favoriteBarButtonOFF], animated: false)
        favoriteStatus = true
        if favoriteStatus == true {
            self.navigationItem.rightBarButtonItem = self.favoriteBarButtonOFF
            
            self.ref.child("Users").child(uid!).child("Likeit").updateChildValues(["\(keyofview!) 의 Index" : "\(keyofview!)"])
        }
        
        print("Show Favorites")
    }
    
    @objc func didTapFavoriteBarButtonOFF() {
        self.navigationItem.setRightBarButtonItems([self.favoriteBarButtonOn], animated: false)
        print("Show All Chat Rooms")
    
        ref.child("Users").child(uid!).child("Likeit").child("\(keyofview!) 의 Index").removeValue()
    }

         deinit {
//                if let refHandle = _refHandle {
//                    self.ref.child("Users").removeObserver(withHandle: refHandle)
//                }
    }
    
    
    func configureDatabase() {
        ref = Database.database().reference()
        // Listen for new messages in the Firebase database
//        _refHandle = self.ref.child("Recruitment").observe(.childAdded, with: { [weak self] (snapshot) -> Void in
//            guard let strongSelf = self else { return }
//            strongSelf.likeit.append(snapshot)
//            strongSelf.homeCollectionView.insertItems(at: [IndexPath(row: strongSelf.recruitment.count-1, section: 0)])
//
//        })
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


}
