//
//  Artwork+CoreDataProperties.swift
//  EventsMap
//
//  Created by Laszlo Palfi on 10/12/2017.
//  Copyright © 2017 Laszlo Palfi. All rights reserved.
//
//

import Foundation
import CoreData


extension Artwork {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Artwork> {
        return NSFetchRequest<Artwork>(entityName: "Artwork")
    }

    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var artist: String?
    @NSManaged public var yearOfWork: String?
    @NSManaged public var information: String?
    @NSManaged public var latitude: String?
    @NSManaged public var longitude: String?
    @NSManaged public var locationNotes: String?
    @NSManaged public var fileName: String?
    @NSManaged public var lastModified: String?
    @NSManaged public var image: NSData?

}
