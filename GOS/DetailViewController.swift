//
//  DetailViewController.swift
//  GOS
//
//  Created by 한병두 on 2018. 7. 20..
//  Copyright © 2018년 Byungdoo Han. All rights reserved.
//

import UIKit
import Firebase

class DetailViewController: UIViewController {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        writerUserID.text = userID
        detailTitle.text = titleBox
        detailTime.text = time
        detailLocation.text = location
        detailPeople.text = people
        detailPosition.text = position
        detailNotice.text = notice

        
        let likeitButton = UIButton(type: .system)
        likeitButton.setImage(UIImage(named: "beforeStar")?.withRenderingMode(.alwaysOriginal), for: .normal)
        likeitButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        likeitButton.contentMode = .scaleAspectFit
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: likeitButton)
        
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "star.png"), style: UIBarButtonItem.Style.plain, target: self, action: Selector(("pressedSearch")))

        // Do any additional setup after loading the view.
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
