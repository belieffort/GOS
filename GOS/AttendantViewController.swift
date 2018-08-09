//
//  AttendantViewController.swift
//  GOS
//
//  Created by 한병두 on 2018. 8. 2..
//  Copyright © 2018년 Byungdoo Han. All rights reserved.
//


//TODO DetailViewController에서 Button을 누르면 바로 업데이트 되어 화면에 나타나는 것이 아니라, RootView까지 돌아간 후 다시 참석자를 확인해야 정보를 확인할 수 있다.
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

    var passedKey:[String] = []
    var usersUIDBox:[String] = []
    var usersUID:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDatabase()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attendants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AttendantCell", for: indexPath) as! AttendantCell
        
        let attendantSnapshot: DataSnapshot! = self.attendants[indexPath.row]
        guard let attendant = attendantSnapshot.value as? [String:AnyObject] else { return cell }
        
        cell.attendantEmail.text = attendant["email"] as! String
        if let url = attendant["profileImage"] {
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
            _refHandle = self.ref.child("Users").observe(.childAdded, with: { [weak self] (snapshot) in
            let userSnapshot: DataSnapshot! = snapshot
            guard let strongSelf = self else { return }
                self?.usersUID = userSnapshot.key
                if (self?.passedKey.contains((self?.usersUID)!))! {
                strongSelf.attendants.append(snapshot)
                strongSelf.attendantTableView.insertRows(at: [IndexPath(row: strongSelf.attendants.count-1, section: 0)], with: .automatic)
                }
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
