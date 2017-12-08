//
//  ViewController.swift
//  EventsMap
//
//  Created by bogdan razvan on 07/12/2017.
//  Copyright © 2017 bogdan razvan. All rights reserved.
//

import UIKit
import Alamofire
import MapKit

let ARTWORK_URL = "https://cgi.csc.liv.ac.uk/~phil/Teaching/COMP327/artworksOnCampus/data.php?class=artworks&lastUpdate=2017-11-01"

class ViewController: UIViewController {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet var mapView: MKMapView!
    
    private var artworks = [Artwork]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMap()
        
        populateMapWithPins()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (context) -> Void in
            let orientation = UIApplication.shared.statusBarOrientation
            
            if orientation.isPortrait {
                self.stackView.axis = .vertical
            } else {
                self.stackView.axis = .horizontal
            }
            
        }, completion: nil)
    }
    
    
    private func setupMap() {
        let initialLocation = CLLocation(latitude: 53.406566, longitude: -2.966531)
        let regionRadius: CLLocationDistance = 1000
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(initialLocation.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    private func populateMapWithPins() {
        Alamofire.request(ARTWORK_URL).responseJSON { response in
            let result = response.result
            if let dict = result.value as? [String: AnyObject] {
                self.artworks = APIArtwork.parseArtworks(JSON: dict)
                
                for artwork in self.artworks {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(artwork.latitude!), longitude: CLLocationDegrees(artwork.longitude!))
                    self.mapView.addAnnotation(annotation)
                }
            }
        }
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let anno = view.annotation as? MKPointAnnotation {
            //let marker_tag = anno.userData!
            print(anno.coordinate)
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Cell \(indexPath.row)"
        return cell
    }
    
    
}
