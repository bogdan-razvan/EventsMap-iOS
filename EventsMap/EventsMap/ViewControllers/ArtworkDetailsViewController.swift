//
//  ArtworkDetailsViewController.swift
//  EventsMap
//
//  Created by bogdan razvan on 08/12/2017.
//  Copyright © 2017 bogdan razvan. All rights reserved.
//

import UIKit

class ArtworkDetailsViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var yearOfWorkLabel: UILabel!
    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var locationNotesLabel: UILabel!
    @IBOutlet weak var lastModifiedLabel: UILabel!
    
    @IBOutlet weak var viewWidth: NSLayoutConstraint!
    
    
    
    
    var artwork: Artwork?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewWidth.constant = self.view.bounds.size.width;

        setupTextFields()
    }
    
    private func setupTextFields() {
        idLabel.text = String(describing: artwork?.id!)
        titleLabel.text = artwork?.title
        artistLabel.text = artwork?.artist
        yearOfWorkLabel.text = artwork?.yearOfWork
        informationLabel.text = artwork?.information
        latitudeLabel.text = String(describing: artwork?.latitude!)
        longitudeLabel.text = String(describing: artwork?.longitude!)
        locationNotesLabel.text = artwork?.locationNotes
        lastModifiedLabel.text = artwork?.lastModified
        
    }
    
}
