//
//  User+CoreDataProperties.swift
//  MyFeedback
//
//  Created by Francis Ngunjiri on 04/02/2020.
//  Copyright © 2020 Francis Ngunjiri. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var image: String?
    @NSManaged public var firstName: String?
    @NSManaged public var passport: String?
    @NSManaged public var lastName: String?

}
