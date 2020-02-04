//
//  MainViewController.swift
//  MyFeedback
//
//  Created by Francis Ngunjiri on 04/02/2020.
//  Copyright © 2020 Francis Ngunjiri. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var users = [User]()
        
        // Do any additional setup after loading the view.
        do {
            users = try context.fetch(User.fetchRequest())
            if(users.isEmpty){
                dismiss(animated: true, completion: nil)
                //add profile details
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "vcEditProfile") as? EditProfileViewController
                
                self.navigationController?.pushViewController(vc!, animated: true)
                
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
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
