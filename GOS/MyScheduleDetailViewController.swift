//
//  MyScheduleDetailViewController.swift
//  GOS
//
//  Created by 한병두 on 2018. 7. 31..
//  Copyright © 2018년 Byungdoo Han. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class MyScheduleDetailViewController: UIViewController {

    
    @IBOutlet weak var my_writerImage: UIImageView!
    @IBOutlet weak var my_writerUserId: UILabel!
    @IBOutlet weak var my_detailTitle: UILabel!
    @IBOutlet weak var my_detailTime: UILabel!
    @IBOutlet weak var my_detailLocation: UILabel!
    @IBOutlet weak var my_detailPeople: UILabel!
    @IBOutlet weak var my_detailPosition: UILabel!
    @IBOutlet weak var my_detailNotice: UITextView!
    
    
    var my_userID:String!
    var my_titleBox:String!
    var my_time:String!
    var my_location:String!
    var my_people:String!
    var my_position:String!
    var my_notice:String!
    var my_sports:String!
    var passedSelectedIndexpath:DataSnapshot!
    
    var ref: DatabaseReference!
    var uid = Auth.auth().currentUser?.uid
    var anotherUserUID:String?
    


    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserUID()

        
        my_writerUserId.text = my_userID
        my_detailTitle.text = my_titleBox
        my_detailTime.text = my_time
        my_detailLocation.text = my_location
        my_detailPeople.text = my_people
        my_detailPosition.text = my_position
        my_detailNotice.text = my_notice
        
        
        let edit = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped))
        let delete = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(trashTapped))

        navigationItem.rightBarButtonItems = [delete, edit]
    }
    
    @objc func editTapped() {
        self.performSegue(withIdentifier: "EditPageSegue", sender: self)
        
        
    }
    @objc func trashTapped() {
    }

    
    func getUserUID() {
        ref = Database.database().reference()
        ref.child("Users").queryOrdered(byChild: "email").queryEqual(toValue: my_userID).observe(.childAdded, with: {snapshot in
            let writerUID = snapshot.key
            print("NOW!!! \(writerUID)")
            if writerUID != self.my_userID! {
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
        if uid != anotherUserUID {
            Database.database().reference().child("Users").child(anotherUserUID!).child("profileImage").observeSingleEvent(of: .value, with: { snapshot in
                if let url = snapshot.value as? String {
                    URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
                        
                        if error != nil {
                            print(error as Any)
                            return
                        }
                        DispatchQueue.main.async {
                            let image = UIImage(data: data!)
                            self.my_writerImage.image = image
                            
                        }
                        }.resume()
                }
            })
        } else {
            Database.database().reference().child("Users").child(self.uid!).child("profileImage").observeSingleEvent(of: .value, with: { snapshot in
                if let url = snapshot.value as? String {
                    URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
                        
                        if error != nil {
                            print(error as Any)
                            return
                        }
                        DispatchQueue.main.async {
                            let image = UIImage(data: data!)
                            self.my_writerImage.image = image
                            
                        }
                        }.resume()
                }
            })
        }
    }
    

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let myWriteEdit: DataSnapshot! = passedSelectedIndexpath
        guard let writeEdit = myWriteEdit.value as? [String:String] else { return }

        
        let myWriteEditViewController = segue.destination as! MyWriteEditViewController
        myWriteEditViewController.passedBox = writeEdit["Location"] ?? "[Location]"
    }
    
    
    

}
