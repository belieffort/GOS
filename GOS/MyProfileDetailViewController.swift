//
//  MyProfileDetailViewController.swift
//  GOS
//
//  Created by 한병두 on 2018. 7. 31..
//  Copyright © 2018년 Byungdoo Han. All rights reserved.
//


//TODO - 이미지를 파이어베이스에서 불러오는데 12초가 걸림
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class MyProfileDetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var myID: UILabel!
    let userUID = Auth.auth().currentUser?.uid
    let ref = Database.database().reference()
    let storageRef = Storage.storage().reference()


    override func viewDidLoad() {
        super.viewDidLoad()
        myID.text = Auth.auth().currentUser?.email
        showImage()
        view.addSubview(myImage)
        myImage.layer.cornerRadius = 90
        myImage.layer.masksToBounds = true
        
    
        // create tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(gesture:)))
        // add it to the image view;
        myImage.addGestureRecognizer(tapGesture)
        // make sure imageView can be interacted with by user
        myImage.isUserInteractionEnabled = true
    }
    
    @objc func imageTapped(gesture: UIGestureRecognizer) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePickerController.allowsEditing = false
        self.present(imagePickerController, animated: true, completion: nil)

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            myImage.image = image
            dismiss(animated: true, completion: nil)
            uploading(img: myImage!) { (url) in
                print(url)
                self.ref.child("Users").child(self.userUID!).updateChildValues(["profileImage":url])
                print(self.userUID!)
            }
        }
    }
    
    func uploading( img : UIImageView, completion: @escaping ((String) -> Void)) {
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
                        self.myImage.image = image
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

