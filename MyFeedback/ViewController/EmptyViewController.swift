//
//  EmptyViewController.swift
//  MyFeedback
//
//  Created by Francis Ngunjiri on 07/02/2020.
//  Copyright © 2020 Francis Ngunjiri. All rights reserved.
//

import UIKit

class EmptyViewController: UIViewController {
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var responses = [CustomQuery]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(true)
           DispatchQueue.main.async {
               self.initData()
           }
       }
    
    func initData(){
        //get survey data
        do{
            responses = try context.fetch(CustomQuery.fetchRequest())
            if(!responses.isEmpty){
            self.navigationController?.popViewController(animated: true)
            }
        }catch let error as NSError {
            print("Could not fetch queries. \(error), \(error.userInfo)")
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
