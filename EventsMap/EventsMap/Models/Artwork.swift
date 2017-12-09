//
//  Artwork.swift
//  EventsMap
//
//  Created by bogdan razvan on 07/12/2017.
//  Copyright © 2017 bogdan razvan. All rights reserved.
//

import Foundation
import UIKit

class Artwork {
    var id: Int?
    var title: String?
    var artist: String?
    var yearOfWork: String?
    var information: String?
    var latitude: Float?
    var longitude: Float?
    var locationNotes: String?
    var fileName: String?
    var lastModified: String?
    var image: UIImage?

     init(
        id: Int? = nil,
        title: String? = nil,
        artist: String? = nil,
        yearOfWork: String? = nil,
        information: String? = nil,
        latitude: Float? = nil,
        longitude: Float? = nil,
        locationNotes: String? = nil,
        fileName: String? = nil,
        lastModified: String? = nil
    ) {
        self.id = id
        self.title = title
        self.artist = artist
        self.yearOfWork = yearOfWork
        self.information = information
        self.latitude = latitude
        self.longitude = longitude
        self.locationNotes = locationNotes
        self.fileName = fileName
        self.lastModified = lastModified
    }

}

