//
//  VideoUploadViewController.swift
//  qfluence
//
//  Created by Don Sirivat on 1/14/21.
//  Copyright © 2021 Don Sirivat. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseStorage
import Firebase

class VideoUploadViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    @IBOutlet weak var checkmark: UIImageView!
    @IBOutlet weak var idField: UITextField!
    @IBOutlet weak var questionField: UITextField!
    
    var videoUrl: String?
    
    @IBAction func saveToDatabasePressed(_ sender: Any) {
        let influencerId = idField.text!
        let questionText = questionField.text!
        
        var ref = Database.database().reference()
        ref = ref.child("videos")
        ref.child(randomString(length: 10)).setValue(["influencerId": influencerId, "questionText": questionText, "imageUrl": "na", "videoUrl": self.videoUrl!])
        
        idField.text = ""
        questionField.text = ""
        self.checkmark.isHidden = true
    }
    
    @IBAction func uploadVideoPressed(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary) ?? []
        picker.mediaTypes = ["public.movie"]
        picker.videoQuality = .typeHigh
        picker.videoExportPreset = AVAssetExportPresetHEVCHighestQuality
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        guard var movieUrl = info[.mediaURL] as? URL else { return }
        let storageRef = Storage.storage().reference()
        let videosRef = storageRef.child("uploads/" + randomString(length: 10) + ".mp4")
        
        do {
            let data = try Data(contentsOf: movieUrl)
            print("YESSSSSSSSS")
            
            let uploadTask = videosRef.putData(data, metadata: nil) { (metadata, error) in
              guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
              }
              // Metadata contains file metadata such as size, content-type.
              let size = metadata.size
              // You can also access to download URL after upload.
              videosRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                  // Uh-oh, an error occurred!
                  return
                }
                self.checkmark.isHidden = false
                self.videoUrl = "\(downloadURL)"
                print("===========================================")
                print(self.videoUrl)
              }
            }
        } catch {
        }
    }

    func randomString(length: Int) -> String {
      let letters = "0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkmark.isHidden = true
        initializeHideKeyboard()
        
        
        // Do any additional setup after loading the view.
    }
    
    func initializeHideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissMyKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissMyKeyboard() {
        view.endEditing(true)
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
