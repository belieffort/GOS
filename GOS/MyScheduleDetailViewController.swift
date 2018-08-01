//
//  MyScheduleDetailViewController.swift
//  GOS
//
//  Created by 한병두 on 2018. 7. 31..
//  Copyright © 2018년 Byungdoo Han. All rights reserved.
//

import UIKit

class MyScheduleDetailViewController: UIViewController {

    @IBOutlet weak var my_writerUserId: UILabel!
    @IBOutlet weak var my_detailTitle: UILabel!
    @IBOutlet weak var my_detailTime: UILabel!
    @IBOutlet weak var my_detailLocation: UILabel!
    @IBOutlet weak var my_detailPeople: UILabel!
    @IBOutlet weak var my_detailPosition: UILabel!
    @IBOutlet weak var my_detailNotice: UITextView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
