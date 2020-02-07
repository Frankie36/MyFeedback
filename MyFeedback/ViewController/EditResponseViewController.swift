//
//  EditResponseViewController.swift
//  MyFeedback
//
//  Created by Francis Ngunjiri on 04/02/2020.
//  Copyright © 2020 Francis Ngunjiri. All rights reserved.
//

import UIKit

class EditResponseViewController: UIViewController {
    @IBOutlet weak var txtNewQuestion: UITextView!
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var queryList = [CustomQuery]()
    var response:CustomQuery?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if(response != nil){
            self.title = "Edit Question"
            txtNewQuestion.text = response?.title
            
            //don't allow editing if is sent
            if(response!.sent){
                //disable text input
                txtNewQuestion.isEditable = false
                
                //Disable done button
                self.navigationItem.rightBarButtonItem?.isEnabled = false

                
                //display message to the user
                showAlertController(title: "Hello There", message: "Sorry but you cannot edit a sent question")
            }
        }
    }
    
    @IBAction func submitOrUpdate(_ sender: Any) {
        if(txtNewQuestion.text!.isEmpty){
            showAlertController(title: "Field Empty", message: "Question is empty")
            return
        }
        // get the current date and time
        let currentDateTime = Date()
        let title = txtNewQuestion.text
        
        //check if is an edit or new query
        if(response==nil){
            //add new query
            let query = CustomQuery(entity: CustomQuery.entity(), insertInto: context)
            
            query.title = title
            query.date = currentDateTime
            appDelegate.saveContext()
            queryList.append(query)
            self.navigationController?.popViewController(animated: true)
        } else {
            //edit query
            switch editQuery(title : title!, date: currentDateTime, oldQuery: response!) {
            case 1:                self.navigationController?.popViewController(animated: true)
                break
            default:
                showAlertController(title: "Error", message: "Couldn't edit content")
                break
            }
        }
        
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
