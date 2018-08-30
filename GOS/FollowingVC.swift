//
//  FollowingVC.swift
//  GOS
//
//  Created by 한병두 on 2018. 8. 28..
//  Copyright © 2018년 Byungdoo Han. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class FollowingVC: UIViewController {
    
    @IBOutlet weak var followingTableView: UITableView!
    
    var userUID = Auth.auth().currentUser?.uid
    var ref: DatabaseReference!
    var followings: [DataSnapshot]! = []
    var followingData: [DataSnapshot]! = []
    var _refHandle: DatabaseHandle?

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        followingTableView.tableFooterView = UIView()

    }
    
    deinit {
        if let refHandle = _refHandle {
            self.ref.child("Users").removeObserver(withHandle: refHandle)}
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension FollowingVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followingData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = followingTableView.dequeueReusableCell(withIdentifier: "Following", for: indexPath) as! FollowingCell
        
        let followingSnapshot: DataSnapshot! = self.followingData[indexPath.row]
        guard let follow = followingSnapshot.value as? [String:AnyObject] else { return cell }
        let email = follow["email"]
        cell.followingEmail.text = email as! String
        
        if let url = follow["profileImage"] {
            print(url)
            URLSession.shared.dataTask(with: URL(string: url as! String)!) { data, response, error in
                
                if error != nil {
                    print(error as Any)
                    return
                }
                DispatchQueue.main.async {
                    let image = UIImage(data: data!)
                    cell.followingImage.image = image
                }
                }.resume()
        }
        return cell
    }
}

