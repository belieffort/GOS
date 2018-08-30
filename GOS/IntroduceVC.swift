//
//  IntroduceVC.swift
//  GOS
//
//  Created by 한병두 on 2018. 8. 16..
//  Copyright © 2018년 Byungdoo Han. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

let notificationKey = "co.dbh.btndone"

class IntroduceVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userProfileEmail: UILabel!
    @IBOutlet weak var userIntroduceText: UITextView!
    var ref: DatabaseReference!
    var myIntroduce: [DataSnapshot]! = []
    var _refHandle: DatabaseHandle?
    var userEmail = Auth.auth().currentUser?.email
    let userUID = Auth.auth().currentUser?.uid
    let storageRef = Storage.storage().reference()
    var uploadSign:Bool?
    
    let save = Notification.Name(rawValue: notificationKey)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        getUserData()
        creatObservers()
        userProfileEmail.text = userEmail!

        view.addSubview(userProfileImage)
        userProfileImage.layer.cornerRadius = 90
        userProfileImage.layer.masksToBounds = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(gesture:)))
        userProfileImage.addGestureRecognizer(tapGesture)
        userProfileImage.isUserInteractionEnabled = true
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func creatObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(IntroduceVC.inputTextField(notification:)), name: save, object: nil)
    }
    
    @objc func inputTextField(notification: Notification) {
        var mdata = [String:String]()
        mdata["IntroduceText"] = userIntroduceText.text
        print(mdata)
        self.ref.child("Users").child("\(userUID!)").child("Introduce").setValue(mdata)
    
    }
    
    @objc func imageTapped(gesture: UIGestureRecognizer) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePickerController.allowsEditing = false
            self.present(imagePickerController, animated: true, completion: nil)
        }
    
    func getUserData() {
        ref.child("Users").child(userUID!).child("Introduce").observe(.value, with: { (snapshot) in
            let following = snapshot.children.allObjects as! [DataSnapshot]
            for i in following {
                self.userIntroduceText.text = i.value as! String
            }
        })
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            userProfileImage.image = image
            dismiss(animated: true, completion: nil)
//                if selected segmented index == 0
            uploading(img: userProfileImage!) { (url) in
                print(url)
                //TODO - 만약 버튼을 누른다면, 올리고 아니면 놉
                //TODO - error 발생!!
                self.ref.child("Users").child(self.userUID!).updateChildValues(["profileImage":url])
                print(self.userUID!)
            }
        }
    }

    func uploading(img : UIImageView, completion: @escaping ((String) -> Void)) {
        var strURL = ""
        let imageName = NSUUID().uuidString
        let storeImage = self.storageRef.child(imageName)

        if let uploadImageData = (img.image)!.pngData(){
            storeImage.putData(uploadImageData, metadata: nil, completion: { (metaData, error) in
                storeImage.downloadURL(completion: { (url, error) in
                    if let urlText = url?.absoluteString {
                        strURL = urlText
                        completion(strURL)
                    }
                })
            })
        }
    }

    func showImage() {
        Database.database().reference().child("Users").child(self.userUID!).child("profileImage").observeSingleEvent(of: .value, with: { snapshot in
            if let url = snapshot.value as? String {
                URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in

                    if error != nil {
                        print(error as Any)
                        return
                    }
                    DispatchQueue.main.async {
                        let image = UIImage(data: data!)
                        self.userProfileImage.image = image
                    }
                }.resume()
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
