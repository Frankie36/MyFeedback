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
    var imageName: String = ""
    var users = [User]()
    var isUsersEmpty : Bool = true
    var isPhotoEdited: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageName = String(getCurrentMillis()) + ".png"
        
        //make imageview circular
        imgProfile.layer.masksToBounds = true
        imgProfile.layer.cornerRadius = imgProfile.bounds.width / 2
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        do {
            users = try context.fetch(User.fetchRequest())
            if(!users.isEmpty){
                isUsersEmpty = false
                
                getImage(imageName: users[0].image ?? "")
                txtFirstName.text = users[0].firstName
                txtLastName.text = users[0].lastName
                txtPassport.text = String(users[0].passport ?? "")
                
            }else {
                isUsersEmpty = true
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
        
        var selectedImage: UIImage?
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImage = editedImage
            self.imgProfile.image = selectedImage!.fixedOrientation()
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
            self.imgProfile.image = selectedImage!.fixedOrientation()
        }

//        let selectedImage = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage)!
//
//                //fix orientation on getting image
//        imgProfile.image = selectedImage.fixedOrientation()
        
        isPhotoEdited = true
        picker.dismiss(animated: true, completion: nil)

        //imagePickerController.dismiss(animated: true, completion: nil)
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
    
    func getCurrentMillis()->Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
    
    @IBAction func saveOrUpdateData(_ sender: Any) {
        
        if(txtFirstName.text!.isEmpty){
            showAlertController(title: "Field Empty", message: "First name is required")
            return
        }
        if(txtLastName.text!.isEmpty){
            showAlertController(title: "Field Empty", message: "Last name is required")
            return
        }
        
        if(imgProfile.image == nil){
            showAlertController(title: "No Image", message: "A photo is required")
            return
        }else{
            if(isPhotoEdited){
                //Save the image
                saveImage(imageName: imageName)
            }
        }
        
        
        
        if(isUsersEmpty){
            //create new data
            let user = User(entity: User.entity(), insertInto: context)
            
            user.firstName = txtFirstName.text
            user.lastName = txtLastName.text
            user.passport = txtPassport.text
            if(isPhotoEdited){
            user.image = imageName
            }
            appDelegate.saveContext()
            
        }else{
            //update existing data
            do {
                users = try context.fetch(User.fetchRequest())
                if(!users.isEmpty){
                    let user = users[0]
                    if(isPhotoEdited){
                    user.setValue(imageName, forKey: "image")
                    }
                    user.setValue(txtFirstName.text, forKey: "firstName")
                    user.setValue(txtLastName.text, forKey: "lastName")
                    user.setValue(txtPassport.text, forKey: "passport")
                    appDelegate.saveContext()
                }
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
        self.navigationController?.popViewController(animated: true)
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
//extension to fix irregular orientation when a photo is taken
extension UIImage {
    
    func fixedOrientation() -> UIImage? {
        
        guard imageOrientation != UIImage.Orientation.up else {
            //This is default orientation, don't need to do anything
            return self.copy() as? UIImage
        }
        
        guard let cgImage = self.cgImage else {
            //CGImage is not available
            return nil
        }
        
        guard let colorSpace = cgImage.colorSpace, let ctx = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
            return nil //Not able to create CGContext
        }
        
        var transform: CGAffineTransform = CGAffineTransform.identity
        
        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat.pi)
            break
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2.0)
            break
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: CGFloat.pi / -2.0)
            break
        case .up, .upMirrored:
            break
        }
        
        //Flip image one more time if needed to, this is to prevent flipped image
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform.translatedBy(x: size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
            break
        case .leftMirrored, .rightMirrored:
            transform.translatedBy(x: size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case .up, .down, .left, .right:
            break
        }
        
        ctx.concatenate(transform)
        
        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        default:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            break
        }
        
        guard let newCGImage = ctx.makeImage() else { return nil }
        return UIImage.init(cgImage: newCGImage, scale: 1, orientation: .up)
    }
}
