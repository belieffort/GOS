//
//  ScheduleViewController.swift
//  GOS
//
//  Created by 한병두 on 2018. 7. 13..
//  Copyright © 2018년 Byungdoo Han. All rights reserved.
//

import UIKit
import Firebase

class FavoriteController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var likeTableView: UITableView!
    @IBOutlet weak var scheduleview_Schedule: UILabel!
    @IBOutlet weak var schedule_Location: UILabel!
    @IBOutlet weak var schedule_Person: UILabel!
    
    var ref: DatabaseReference!
    var likeit: [DataSnapshot]! = []
    var _refHandle: DatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDatabase()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likeit.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IlikeCell", for: indexPath) as! FavoriteTableViewCell
        
        let likeitSnapshot: DataSnapshot! = self.likeit[indexPath.row]
        guard let ilikeit = likeitSnapshot.value as? [String:String] else {return cell }
        
        cell.schedule_Time.text = ""
        cell.schedule_Location.text = ""
        cell.schedule_Person.text = ""

        
        return cell
    }

    
    deinit {
        if let refHandle = _refHandle {
            self.ref.child("messages").removeObserver(withHandle: refHandle)
        }
    }
    
    func configureDatabase() {
        ref = Database.database().reference()
        // Listen for new messages in the Firebase database
        _refHandle = self.ref.child("messages").observe(.childAdded, with: { [weak self] (snapshot) -> Void in
            guard let strongSelf = self else { return }
            strongSelf.likeit.append(snapshot)
            strongSelf.likeTableView.insertRows(at: [IndexPath(row: strongSelf.likeit.count-1, section: 0)], with: .automatic)
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
