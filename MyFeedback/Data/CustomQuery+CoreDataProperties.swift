//
//  CustomQuery+CoreDataProperties.swift
//  MyFeedback
//
//  Created by Francis Ngunjiri on 05/02/2020.
//  Copyright © 2020 Francis Ngunjiri. All rights reserved.
//
//

import Foundation
import CoreData


extension CustomQuery {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CustomQuery> {
        return NSFetchRequest<CustomQuery>(entityName: "CustomQuery")
    }

    @NSManaged public var date: Date?
    @NSManaged public var title: String?
    @NSManaged public var desc: String?
    @NSManaged public var sent: Bool
    @NSManaged public var id: Int16
    @NSManaged public var answered: Bool

}
