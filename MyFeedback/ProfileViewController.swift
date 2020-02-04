//
//  SecondViewController.swift
//  MyFeedback
//
//  Created by Francis Ngunjiri on 03/02/2020.
//  Copyright © 2020 Francis Ngunjiri. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblFirstName: UILabel!
    @IBOutlet weak var lblLastName: UILabel!
    @IBOutlet weak var lblPassport: UILabel!
    var imageName: String = "profile.png"
    var users = [User]()
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        do {
            users = try context.fetch(User.fetchRequest())
            if(!users.isEmpty){
                getImage(imageName: imageName)
                lblFirstName.text = users[0].firstName
                lblLastName.text = users[0].lastName
                lblPassport.text = String(users[0].passport ?? "")
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
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
}