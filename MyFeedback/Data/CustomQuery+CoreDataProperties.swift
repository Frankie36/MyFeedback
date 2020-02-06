//
//  CustomQuery+CoreDataProperties.swift
//  
//
//  Created by Francis Ngunjiri on 06/02/2020.
//
//

import Foundation
import CoreData


extension CustomQuery {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CustomQuery> {
        return NSFetchRequest<CustomQuery>(entityName: "CustomQuery")
    }

    @NSManaged public var answered: Bool
    @NSManaged public var date: Date?
    @NSManaged public var desc: String?
    @NSManaged public var id: Int16
    @NSManaged public var sent: Bool
    @NSManaged public var title: String?

}
