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
import Cluster

let ARTWORK_URL = "https://cgi.csc.liv.ac.uk/~phil/Teaching/COMP327/artworksOnCampus/data.php?class=artworks&lastUpdate=2017-11-01"

class MapViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet var mapView: MKMapView!

    private let clusterManager = ClusterManager()
    private var artworks = [Artwork]()
    private var selectedArtwork: Artwork?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupClusterManager()
        setupMap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewArtworkDetails" {
            let nextViewController = segue.destination as! ArtworkDetailsViewController
            nextViewController.artwork = selectedArtwork
        }
    }
    
    private func setupClusterManager() {
        clusterManager.cellSize = nil
        clusterManager.maxZoomLevel = 17
        clusterManager.minCountForClustering = 3
        clusterManager.shouldRemoveInvisibleAnnotations = false
        clusterManager.clusterPosition = .nearCenter
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

                    let annotation = ArtworkAnnotation()
                    annotation.artwork = artwork
                    self.clusterManager.add(annotation)

//                    let annotation = MKPointAnnotation()
//                    annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(artwork.latitude!), longitude: CLLocationDegrees(artwork.longitude!))
//                    self.mapView.addAnnotation(annotation)
                }
            }
        }
    }
}

extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else { return }

        if let cluster = annotation as? ClusterAnnotation {
            var zoomRect = MKMapRectNull
            for annotation in cluster.annotations {
                let annotationPoint = MKMapPointForCoordinate(annotation.coordinate)
                let pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0)
                if MKMapRectIsNull(zoomRect) {
                    zoomRect = pointRect
                } else {
                    zoomRect = MKMapRectUnion(zoomRect, pointRect)
                }
            }
            mapView.setVisibleMapRect(zoomRect, animated: true)
        } else if let cluster = annotation as? ArtworkAnnotation {
            selectedArtwork = cluster.artwork
        }
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? ClusterAnnotation {
            guard let style = annotation.style else { return nil }
            let identifier = "Cluster"
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            if let view = view as? ClusterAnnotationView {
                view.annotation = annotation
                view.configure(with: style)
            } else {
                view = ClusterAnnotationView(annotation: annotation, reuseIdentifier: identifier, style: style)
            }
            return view
        } else {
            guard let annotation = annotation as? Annotation, let style = annotation.style else { return nil }
            let identifier = "Pin"
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
            if let view = view {
                view.annotation = annotation
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view!.canShowCallout = true
                let informationButton = UIButton(type: .detailDisclosure)
                view!.rightCalloutAccessoryView = informationButton
            }
            if #available(iOS 9.0, *), case let .color(color, _) = style {
                view?.pinTintColor = color
            } else {
                view?.pinTintColor = .green
            }
            return view
        }
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        clusterManager.reload(mapView, visibleMapRect: mapView.visibleMapRect)
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            performSegue(withIdentifier: "viewArtworkDetails", sender: self)
        }
    }
}

extension MapViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Cell \(indexPath.row)"
        return cell
    }


}

