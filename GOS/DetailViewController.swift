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
    var messages: [DataSnapshot]! = []
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
    var favoriteStatus:Bool?
    
    
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
        
//        let likeitButton = UIButton(type: .system)
//        likeitButton.setImage(UIImage(named: "beforeStar")?.withRenderingMode(.alwaysOriginal), for: .normal)
//        likeitButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
//        likeitButton.contentMode = .scaleAspectFit
//        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: likeitButton)
        
        favoriteBarButtonOn = UIBarButtonItem(image: UIImage(named: "beforeStar"), style: .plain, target: self, action: #selector(didTapFavoriteBarButtonOn))
        favoriteBarButtonOFF = UIBarButtonItem(image: UIImage(named: "afterStar"), style: .plain, target: self, action: #selector(didTapFavoriteBarButtonOFF))
        
        self.navigationItem.rightBarButtonItems = [self.favoriteBarButtonOn]

        // Do any additional setup after loading the view.
    }
    
    @objc func didTapFavoriteBarButtonOn() {
        self.navigationItem.setRightBarButtonItems([self.favoriteBarButtonOFF], animated: false)
        
        favoriteStatus = true
        if favoriteStatus == true {
            self.navigationItem.rightBarButtonItem = self.favoriteBarButtonOFF
            
            let uid = Auth.auth().currentUser?.uid
            
            var mdata = [String:String]()
            mdata["likeit"] = "\(String(describing: favoriteStatus!))"
            // Push data to Firebase Database
//            self.ref.child("Users").childByAutoId().setValue(mdata)
//            self.ref.child(Auth.auth().currentUser?.uid ?? "Auth.auth().currentUser?.uid").childByAutoId().setValue(mdata)
//            self.ref.child("Users").child(uid!).setValue(mdata)
        self.ref.child("Users").child(uid!).updateChildValues(mdata)
//            print(Auth.auth().currentUser?.uid ?? "Auth.auth().currentUser?.uid")

            favoriteStatus = false
        } else {
            self.navigationItem.rightBarButtonItem = self.favoriteBarButtonOn
        }
        
        print("Show Favorites")
    }
    
    @objc func didTapFavoriteBarButtonOFF() {
        self.navigationItem.setRightBarButtonItems([self.favoriteBarButtonOn], animated: false)
        print("Show All Chat Rooms")
    }
    
    deinit {
        //        if let refHandle = _refHandle {
        //            self.ref.child("messages").removeObserver(withHandle: _refHandle)
        //        }
    }
    
    
    func configureDatabase() {
        ref = Database.database().reference()
        // Listen for new messages in the Firebase database
        //        _refHandle = self.ref.child("messages").observe(.childAdded, with: { [weak self] (snapshot) -> Void in
        //            guard let strongSelf = self else { return }
        //            strongSelf.messages.append(snapshot)
        //            strongSelf.clientTable.insertRows(at: [IndexPath(row: strongSelf.messages.count-1, section: 0)], with: .automatic)
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
