//
//  AttendantViewController.swift
//  GOS
//
//  Created by 한병두 on 2018. 8. 2..
//  Copyright © 2018년 Byungdoo Han. All rights reserved.
//


//TODO 글 작성자는 동시에 참가자로 속하도록 한다!
import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage


class AttendantViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var attendantTableView: UITableView!

    var profileImage:UIImageView!
    var ref: DatabaseReference!
    var attendants: [DataSnapshot]! = []
    var _refHandle: DatabaseHandle?

    var passedKey:String?
    var usersUID:String?
    
    var tempUID = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attendantTableView.tableFooterView = UIView()
        configureDatabase()
    }
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attendants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AttendantCell", for: indexPath) as! AttendantCell

        let attendantSnapshot: DataSnapshot! = self.attendants[indexPath.row]
        guard let attendant = attendantSnapshot.value as? [String:AnyObject] else { return cell }
        
        cell.attendantEmail.text = attendant["Email"] as! String
        
        if let url = attendant["ProfileImage"] {
            URLSession.shared.dataTask(with: URL(string: url as! String)!) { data, response, error in
            
            if error != nil {
                print(error as Any)
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: data!)
                cell.attendantImage.image = image
            }
            }.resume()
        }
        
        return cell
    }
    
    deinit {
        if let refHandle = _refHandle {
            self.ref.child("Users").removeObserver(withHandle: refHandle)}
    }
    
    func configureDatabase() {
        
        ref = Database.database().reference()
        _refHandle = self.ref.child("Join").child("\(passedKey!)").child("UserInfo")
            .observe(.childAdded, with: { [weak self] (snapshot) in
                    guard let strongSelf = self else { return }
                    strongSelf.attendants.append(snapshot)
                    strongSelf.attendantTableView.insertRows(at: [IndexPath(row: strongSelf.attendants.count-1, section: 0)], with: .automatic)
            })
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
