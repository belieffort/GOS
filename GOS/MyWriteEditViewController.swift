//
//  MyWriteEditViewController.swift
//  GOS
//
//  Created by 한병두 on 2018. 8. 2..
//  Copyright © 2018년 Byungdoo Han. All rights reserved.
//


//TODO - 연결을 했으니까, 데이터 연결은 UI변경하면 적용!
import UIKit

class MyWriteEditViewController: UIViewController {

    @IBOutlet weak var sampleLbl: UILabel!
    
    var passedBox:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        sampleLbl.text = passedBox
        

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
