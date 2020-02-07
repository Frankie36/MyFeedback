//
//  SurveyRepo.swift
//  MyFeedback
//
//  Created by Francis Ngunjiri on 06/02/2020.
//  Copyright © 2020 Francis Ngunjiri. All rights reserved.
//

import Foundation
import UIKit
import RxAlamofire
import Alamofire
import CoreData

private let appDelegate = UIApplication.shared.delegate as! AppDelegate
private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

func getQueries() -> [CustomQuery] {
    var queries = [CustomQuery]()
    do{ queries = try context.fetch(CustomQuery.fetchRequest())
    }catch let error as NSError {
        print("Could not fetch queries. \(error), \(error.userInfo)")
    }
    return queries
}

func getUnsentQueries() -> [CustomQuery] {
    var queries = [CustomQuery]()
    
    let request = NSFetchRequest<CustomQuery>(entityName: "CustomQuery")
    
    //get data where sent = false
    request.predicate = NSPredicate(format: "sent == %@", false)
    
    do{ queries = try context.fetch(request)
    }catch let error as NSError {
        print("Could not fetch queries. \(error), \(error.userInfo)")
    }
    return queries
}

func deleteResponse(position: Int) -> Int{
    var statusCode: Int
    let queries = getQueries()
    do{
        context.delete(queries[position])
        try context.save()
        statusCode = 1
    }catch let error as NSError {
        print("Could not delete. \(error), \(error.userInfo)")
        statusCode = 0
    }
    return statusCode
}


func markSent(customQuery:CustomQuery)->Int{
 var statusCode: Int
    do{
        customQuery.setValue(true, forKey: "sent")
        try context.save()
        statusCode = 1
    }catch let error as NSError {
        print("Could not update. \(error), \(error.userInfo)")
        statusCode = 0
    }
    return statusCode
}

func editQuery(title: String, date: Date, oldQuery:CustomQuery)->Int{
 var statusCode: Int
    do{
        oldQuery.setValue(title, forKey: "title")
        oldQuery.setValue(date, forKey: "date")
        
        try context.save()
        statusCode = 1
    }catch let error as NSError {
        print("Could not update. \(error), \(error.userInfo)")
        statusCode = 0
    }
    return statusCode
}
