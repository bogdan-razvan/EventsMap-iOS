//
//  APIArtwork.swift
//  EventsMap
//
//  Created by Laszlo Palfi on 07/12/2017.
//  Copyright © 2017 Laszlo Palfi. All rights reserved.
//

import Foundation

class APIArtwork {

    static func parseArtworks(JSON: [String: AnyObject]) -> [Artwork] {
        var result = [Artwork]()
        let artworkJSON = JSON["artworks"] as! [Dictionary<String, AnyObject>]

        for artworksJSON in artworkJSON {
            let id = artworksJSON["id"] as? String
            let title = artworksJSON["title"] as? String
            let artist = artworksJSON["artist"] as? String
            let yearOfWork = artworksJSON["yearOfWork"] as? String
            let information = artworksJSON["Information"] as? String
            let latitude = artworksJSON["lat"] as? String
            let longitude = artworksJSON["long"] as? String
            let locationNotes = artworksJSON["locationNotes"] as? String
            let fileName = artworksJSON["fileName"] as? String
            let lastModified = artworksJSON["lastModified"] as? String

            let artwork = Artwork(context: context)
            artwork.id = id
            artwork.title = title
            artwork.artist = artist
            artwork.yearOfWork = yearOfWork
            artwork.information = information
            artwork.latitude = latitude
            artwork.longitude = longitude
            artwork.locationNotes = locationNotes
            artwork.fileName = fileName
            artwork.lastModified = lastModified

            result.append(artwork)
        }
        return result
    }
}
