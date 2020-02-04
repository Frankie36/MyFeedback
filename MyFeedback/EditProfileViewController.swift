//
//  EditProfileViewController.swift
//  MyFeedback
//
//  Created by Francis Ngunjiri on 04/02/2020.
//  Copyright © 2020 Francis Ngunjiri. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtPassport: UITextField!
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var imagePickerController : UIImagePickerController!
    var imageName: String = "profile.png"
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        do {
          users = try context.fetch(User.fetchRequest())
            if(!users.isEmpty){
                getImage(imageName: imageName)
                txtFirstName.text = users[0].firstName
                txtLastName.text = users[0].lastName
                txtPassport.text = String(users[0].passport ?? "")
            }
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage)!
        imgProfile.image = selectedImage
        
        imagePickerController.dismiss(animated: true, completion: nil)
    }
    
    func saveImage(imageName: String){
        //create an instance of the FileManager
        let fileManager = FileManager.default
        //get the image path
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        //get the image we took with camera
        let image = self.imgProfile.image
        
        //get the PNG data for this image
        let data = image?.pngData()
        
        //store it in the document directory
        fileManager.createFile(atPath: imagePath as String, contents: data, attributes: nil)
    }
    
    func getImage(imageName: String){
        //This creates an instance of the FileManager again:
        let fileManager = FileManager.default
        
        //This gets the path again:
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        
        //This then checks the path for the image, if it exists it sets the imageView on imageview
        
        if fileManager.fileExists(atPath: imagePath){
            imgProfile.image = UIImage(contentsOfFile: imagePath)
        }else{
            print("Image is missing")
        }
    }
    
    
    @IBAction func saveOrUpdateData(_ sender: Any) {
        if(imgProfile.image == nil){
            showAlertController(title: "No Image", message: "A photo is required")
            return
        }else{
            //Save the image
            saveImage(imageName: imageName)
        }
        
        
        if(txtFirstName.text!.isEmpty){
            showAlertController(title: "Field Empty", message: "First name is required")
            return
        }
        if(txtLastName.text!.isEmpty){
            showAlertController(title: "Field Empty", message: "Last name is required")
            return
        }
             
        let user = User(entity: User.entity(), insertInto: context)

        user.firstName = txtFirstName.text
        user.lastName = txtLastName.text
        user.passport = txtPassport.text
        user.image = imageName
        appDelegate.saveContext()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    private func showAlertController(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        self.present(alert, animated: true)
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
