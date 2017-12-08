//
//  Artwork.swift
//  EventsMap
//
//  Created by bogdan razvan on 07/12/2017.
//  Copyright © 2017 bogdan razvan. All rights reserved.
//

import Foundation

class Artwork {
    let id: Int?
    let title: String?
    let artist: String?
    let yearOfWork: String?
    let information: String?
    let latitude: Float?
    let longitude: Float?
    let locationNotes: String?
    let fileName: String?
    let lastModified: String?

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

