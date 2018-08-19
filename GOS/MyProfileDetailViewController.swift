//
//  MyProfileDetailViewController.swift
//  GOS
//
//  Created by 한병두 on 2018. 7. 31..
//  Copyright © 2018년 Byungdoo Han. All rights reserved.
//


//TODO - 이미지를 파이어베이스에서 불러오는데 12초가 걸림
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage


class MyProfileDetailViewController: UIViewController {
    
    @IBOutlet weak var myAccountView: UIView!
    @IBOutlet weak var myPreferenceSportsView: UIView!
    
    @IBOutlet weak var segmentCheck: UISegmentedControl!
    var ref: DatabaseReference!
    var myIntroduce: [DataSnapshot]! = []
    var _refHandle: DatabaseHandle?
    
    let userUID = Auth.auth().currentUser?.uid
    let storageRef = Storage.storage().reference()
    
    var btnStore:UIBarButtonItem!
    var throughPath:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        configureDatabase()
        btnStore = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(addTapped))
        self.navigationItem.rightBarButtonItem = self.btnStore
//        myID.text = Auth.auth().currentUser?.email
//        showImage()
//        view.addSubview(myImage)
//        myImage.layer.cornerRadius = 90
//        myImage.layer.masksToBounds = true
//        btnOne.isMultipleSelectionEnabled = true
    }
    
    
    @objc func addTapped() {
        if segmentCheck.selectedSegmentIndex == 0 {
        
        let name = Notification.Name(rawValue: notificationKey)
        NotificationCenter.default.post(name: name, object: nil)
//        print("??")
        } else if segmentCheck.selectedSegmentIndex == 1 {
            
            
        }
    }
    
    
    @IBAction func switchViews(_ sender:UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            myAccountView.alpha = 1
            myPreferenceSportsView.alpha = 0
        } else {
            myAccountView.alpha = 0
            myPreferenceSportsView.alpha = 1
        }
    }
    
//    @IBAction func btnCheck(_ sender: DLRadioButton) {
//        if btnOne.isSelected {
//            print("true")
//            ref.child("Users").child("\(userUID!)").child("PreferenceSports").updateChildValues(["Basketball":true])
//        } else {
//            print("false")
//            ref.child("Users").child("\(userUID!)").child("PreferenceSports").child("Basketball").removeValue()
//        }
//        if btnTwo.isSelected {
//            print("true")
//            ref.child("Users").child("\(userUID!)").child("PreferenceSports").updateChildValues(["Badminton":true])
//        } else {
//            print("false")
//            ref.child("Users").child("\(userUID!)").child("PreferenceSports").child("Badminton").removeValue()
//        }
//        if btnThree.isSelected {
//            print("true")
//            ref.child("Users").child("\(userUID!)").child("PreferenceSports").updateChildValues(["Soccer":true])
//        } else {
//            print("false")
//            ref.child("Users").child("\(userUID!)").child("PreferenceSports").child("Soccer").removeValue()
//        }
//        if btnFour.isSelected {
//            print("true")
//            ref.child("Users").child("\(userUID!)").child("PreferenceSports").updateChildValues(["Ice Hockey":true])
//        } else {
//            print("false")
//            ref.child("Users").child("\(userUID!)").child("PreferenceSports").child("Ice Hockey").removeValue()
//        }
//        if btnFive.isSelected {
//            print("true")
//            ref.child("Users").child("\(userUID!)").child("PreferenceSports").updateChildValues(["Tennis":true])
//        } else {
//            print("false")
//            ref.child("Users").child("\(userUID!)").child("PreferenceSports").child("Tennis").removeValue()
//        }
//        if btnSix.isSelected {
//            print("true")
//            ref.child("Users").child("\(userUID!)").child("PreferenceSports").updateChildValues(["Baseball":true])
//        } else {
//            print("false")
//            ref.child("Users").child("\(userUID!)").child("PreferenceSports").child("Baseball").removeValue()
//        }
//        if btnSeven.isSelected {
//            print("true")
//            ref.child("Users").child("\(userUID!)").child("PreferenceSports").updateChildValues(["Volleyball":true])
//        } else {
//            print("false")
//            ref.child("Users").child("\(userUID!)").child("PreferenceSports").child("Volleyball").removeValue()
//        }
//        if btnEight.isSelected {
//            print("true")
//            ref.child("Users").child("\(userUID!)").child("PreferenceSports").updateChildValues(["Table Tennis":true])
//        } else {
//            print("false")
//            ref.child("Users").child("\(userUID!)").child("PreferenceSports").child("Table Tennis").removeValue()
//        }
//    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "IntroduceVC" {
            let introduceVC = segue.destination as! IntroduceVC
            introduceVC.introduceText = throughPath!
        }
    }

    
//    deinit {
//        if let refHandle = _refHandle {
//            self.ref.child("Users").removeObserver(withHandle: refHandle)}
//    }
//
//    func configureDatabase() {
//        ref = Database.database().reference()
//        // Listen for new messages in the Firebase database
//        _refHandle = self.ref.child("Users").child(userUID!)
//            .child("Introduce")
//            .observe(.childAdded, with: { [weak self] (snapshot) -> Void in
//                let vc = self?.storyboard?.instantiateViewController(withIdentifier: "IntroduceVC") as! IntroduceVC
//                vc.introduceText = snapshot.value! as! String
//                print(snapshot.value! as! String)
//        })
}
