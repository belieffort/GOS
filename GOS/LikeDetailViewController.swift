//
//  LikeDetailViewController.swift
//  GOS
//
//  Created by 한병두 on 2018. 7. 30..
//  Copyright © 2018년 Byungdoo Han. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class LikeDetailViewController: UIViewController {

    @IBOutlet weak var writerImage: UIImageView!
    @IBOutlet weak var like_writerUserId: UILabel!
    @IBOutlet weak var like_detailTitle: UILabel!
    @IBOutlet weak var like_detailTime: UILabel!
    @IBOutlet weak var like_detailLocation: UILabel!
    @IBOutlet weak var like_detailPeople: UILabel!
    @IBOutlet weak var like_detailPosition: UILabel!
    @IBOutlet weak var like_detailNotice: UITextView!

    var like_userId:String!
    var like_titleBox:String!
    var like_time:String!
    var like_location:String!
    var like_people:String!
    var like_position:String!
    var like_notice:String!
    var like_sports:String!

    var keyOfUserLike:String!
    var uid = Auth.auth().currentUser?.uid
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showProfileImage()
        
        like_writerUserId.text = like_userId
        like_detailTitle.text = like_titleBox
        like_detailTime.text = like_time
        like_detailLocation.text = like_location
        like_detailPeople.text = like_people
        like_detailPosition.text = like_position
        like_detailNotice.text = like_notice
        like_detailNotice.isEditable = false
//        configureDatabase()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func showProfileImage() {
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
