//
//  RecordsList+CoreDataProperties.swift
//  RecordsList
//
//  Created by Ellie Gadiel on 18/08/2021.
//
//

import Foundation
import CoreData


extension RecordsList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecordsList> {
        return NSFetchRequest<RecordsList>(entityName: "RecordsList")
    }

    @NSManaged public var dateCreated: Int64
    @NSManaged public var details: String?
    @NSManaged public var id: String?
    @NSManaged public var lastUpdated: Int64
    @NSManaged public var name: String?
    @NSManaged public var records: String?
    @NSManaged public var type: Int16
    @NSManaged public var userIds: String?

}
