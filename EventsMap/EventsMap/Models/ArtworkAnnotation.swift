//
//  ArtworkAnnotation.swift
//  EventsMap
//
//  Created by bogdan razvan on 08/12/2017.
//  Copyright © 2017 bogdan razvan. All rights reserved.
//

import UIKit
import Cluster
import MapKit

class ArtworkAnnotation: Annotation {
    
    var artwork: Artwork! { didSet { configureAnnotation() } }

    private func configureAnnotation() {
        self.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(artwork.latitude!), longitude: CLLocationDegrees(artwork.longitude!))
        self.title = artwork?.title
        self.subtitle = artwork?.artist
        self.style = .color(.orange, radius: 25)
    }
}
