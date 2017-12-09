//
//  ArtworkTableViewCell.swift
//  EventsMap
//
//  Created by bogdan razvan on 09/12/2017.
//  Copyright © 2017 bogdan razvan. All rights reserved.
//

import UIKit

class ArtworkTableViewCell: UITableViewCell {
    var artwork: Artwork!  { didSet { configureCell() } }
    
    private func configureCell() {
        self.textLabel?.text = artwork.title
    }
}
