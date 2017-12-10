//
//  ArtworkTableViewCell.swift
//  EventsMap
//
//  Created by Laszlo Palfi on 09/12/2017.
//  Copyright © 2017 Laszlo Palfi. All rights reserved.
//

import UIKit

class ArtworkTableViewCell: UITableViewCell {
    var artwork: Artwork!  { didSet { configureCell() } }
    
    private func configureCell() {
        self.textLabel?.text = artwork.title
    }
}
