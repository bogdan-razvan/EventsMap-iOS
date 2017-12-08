//
//  APIArtwork.swift
//  EventsMap
//
//  Created by bogdan razvan on 07/12/2017.
//  Copyright © 2017 bogdan razvan. All rights reserved.
//

import Foundation

class APIArtwork {

    static func parseArtworks(JSON: [String: AnyObject]) -> [Artwork] {
        var result = [Artwork]()
        let artworkJSON = JSON["artworks"] as! [Dictionary<String, AnyObject>]

        for artworksJSON in artworkJSON {
            let id = artworksJSON["id"] as! String
            let title = artworksJSON["title"] as? String
            let artist = artworksJSON["artist"] as? String
            let yearOfWork = artworksJSON["yearOfWork"] as? String
            let information = artworksJSON["Information"] as? String
            let latitude = artworksJSON["lat"] as! String
            let longitude = artworksJSON["long"] as! String
            let locationNotes = artworksJSON["name"] as? String
            let fileName = artworksJSON["name"] as? String
            let lastModified = artworksJSON["lastModified"] as? String
            let artwork = Artwork(id: Int(id), title: title, artist: artist, yearOfWork: yearOfWork, information: information, latitude: Float(latitude), longitude: Float(longitude), locationNotes: locationNotes, fileName: fileName, lastModified: lastModified)
            result.append(artwork)
        }
        return result
    }
}
