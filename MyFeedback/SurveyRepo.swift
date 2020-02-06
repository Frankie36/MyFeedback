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

private let appDelegate = UIApplication.shared.delegate as! AppDelegate
private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

func getQueries() -> [CustomQuery] {
    var queries = [CustomQuery]()
    do{ queries = try context.fetch(CustomQuery.fetchRequest())
    }catch let error as NSError {
        print("Could not fetch users. \(error), \(error.userInfo)")
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

