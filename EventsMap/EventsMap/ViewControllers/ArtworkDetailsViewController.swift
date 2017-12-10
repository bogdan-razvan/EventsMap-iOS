//
//  ArtworkDetailsViewController.swift
//  EventsMap
//
//  Created by Laszlo Palfi on 08/12/2017.
//  Copyright © 2017 Laszlo Palfi. All rights reserved.
//

import UIKit

class ArtworkDetailsViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var yearOfWorkLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var lastModifiedLabel: UILabel!
    @IBOutlet weak var informationTextView: UITextView!
    @IBOutlet weak var locationNotesTextView: UITextView!

    @IBOutlet weak var viewWidth: NSLayoutConstraint!

    var artwork: Artwork?

    override func viewDidLoad() {
        super.viewDidLoad()
        viewWidth.constant = self.view.bounds.size.width

        setupTextFields()
    }

    private func setupTextFields() {
        idLabel.text = artwork?.id
        titleLabel.text = artwork?.title
        artistLabel.text = artwork?.artist
        yearOfWorkLabel.text = artwork?.yearOfWork
        informationTextView.text = artwork?.information
        latitudeLabel.text = artwork?.latitude
        longitudeLabel.text = artwork?.longitude
        locationNotesTextView.text = artwork?.locationNotes
        lastModifiedLabel.text = artwork?.lastModified
        imageView.image = UIImage(data:(artwork?.image)! as Data,scale:1.0)
        [informationTextView, locationNotesTextView].forEach { textField in
            textField!.layer.borderWidth = 1
            textField!.layer.borderColor = UIColor.black.cgColor }

    }
}
