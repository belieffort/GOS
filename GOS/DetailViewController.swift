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

    var mainViewController = HomeViewController()
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
    
    var favoriteBarButtonOn:UIBarButtonItem!
    var favoriteBarButtonOFF:UIBarButtonItem!
    var favoriteStatus:Bool = true
    var uid = Auth.auth().currentUser?.uid
    var passedIndex:IndexPath!
    

    override func viewDidLoad() {
        super.viewDidLoad()

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

        let likeitSnapshot: DataSnapshot! = self.likeit[passedIndex.item]
        guard let doyoulikeit = likeitSnapshot.value as? [String:String] else { return  }

        let likeitData = doyoulikeit["likeit"] ?? "[likeit]"

        if likeitData == "true" {
        self.navigationItem.rightBarButtonItems = [self.favoriteBarButtonOn]
        } else {
            self.navigationItem.rightBarButtonItems = [self.favoriteBarButtonOFF]
        }
        // Do any additional setup after loading the view.
        self.navigationItem.rightBarButtonItems = [self.favoriteBarButtonOn]

    }
    
    @objc func didTapFavoriteBarButtonOn() {
        self.navigationItem.setRightBarButtonItems([self.favoriteBarButtonOFF], animated: false)
    
        favoriteStatus = true
        if favoriteStatus == true {
            self.navigationItem.rightBarButtonItem = self.favoriteBarButtonOFF
            var mdata = [String:String]()
            mdata["likeit"] = "\(String(describing: favoriteStatus))"
            // Push data to Firebase Database
            self.ref.child("Users").child(uid!).updateChildValues(mdata)
//            print(self.ref.child("Recruitment"))
        }
        print("Show Favorites")
    }
    
    @objc func didTapFavoriteBarButtonOFF() {
        self.navigationItem.setRightBarButtonItems([self.favoriteBarButtonOn], animated: false)
        print("Show All Chat Rooms")

        favoriteStatus = false
        if favoriteStatus == false {
            var mdata = [String:String]()
            mdata["likeit"] = "\(String(describing: favoriteStatus))"
            // Push data to Firebase Database
            self.ref.child("Users").child("likeit").updateChildValues(mdata)
//            self.ref.child("Recruitmen").child("\(info)")
        }
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
//            strongSelf.recruitment.append(snapshot)
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
