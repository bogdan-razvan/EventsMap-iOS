//
//  ViewController.swift
//  EventsMap
//
//  Created by Laszlo Palfi on 07/12/2017.
//  Copyright © 2017 Laszlo Palfi. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import MapKit
import Cluster
import CoreData

/// URL where to download the Artwork information from
let ARTWORK_URL = "https://cgi.csc.liv.ac.uk/~phil/Teaching/COMP327/artworksOnCampus/data.php?class=artworks&lastUpdate=2017-11-01"

class MapViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!

    private let clusterManager = ClusterManager()
    private var artworks = [Artwork]()
    private var selectedArtwork: Artwork?
    private var buildingDictionary: [String: [Artwork]] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        setupClusterManager()
        setupMap()
        fetchArtworks()
    }


    /// Shifts the stackview's axis so that the table appears on the right of the map when in landscape.
    ///
    /// - Parameters:
    ///   - size: size.
    ///   - coordinator: coordinator
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

    /// Setup for the cluster manager which is used to keep the annotations which are displayed on the map.
    private func setupClusterManager() {
        clusterManager.cellSize = nil
        clusterManager.maxZoomLevel = 17
        clusterManager.minCountForClustering = 3
        clusterManager.shouldRemoveInvisibleAnnotations = false
        clusterManager.clusterPosition = .nearCenter
    }

    /// Sets the initial location of the map.
    private func setupMap() {
        let initialLocation = CLLocation(latitude: 53.406566, longitude: -2.966531)
        let regionRadius: CLLocationDistance = 1000

        let coordinateRegion = MKCoordinateRegionMakeWithDistance(initialLocation.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    /// Reads the artwork information from the internet and creates annotations based on their latitude and longitude.

    private func fetchArtworks() {
        Alamofire.request(ARTWORK_URL).responseJSON { response in
            let result = response.result
            if let dict = result.value as? [String: AnyObject] {
                let parsedArtworks = APIArtwork.parseArtworks(JSON: dict)
                for artwork in parsedArtworks {
                    context.insert(artwork)
                }
            }
            self.readArtworksFromDatabase()
            self.fetchArtworkImages()
            self.configureBuildingDictionary()
            self.tableView.reloadData()
        }
    }
    /// Fetches the images for each artwork, and creates an annotations to be displayed on the map.
    private func fetchArtworkImages() {
        var fileNameArtworksMap: [String: Artwork] = [:]
        for artwork in artworks {
            fileNameArtworksMap[artwork.fileName!] = artwork
        }
        let baseURL = "https://cgi.csc.liv.ac.uk/~phil/Teaching/COMP327/artwork_images/"

        for entry in fileNameArtworksMap {
            let URL = "\(baseURL)\(entry.key)"
            let urlString = URL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            Alamofire.request(urlString!).responseImage { response in
                let artwork = entry.value
                if let image = response.result.value {
                    artwork.image = UIImagePNGRepresentation(image)! as NSData
                }
                let annotation = ArtworkAnnotation()
                annotation.artwork = artwork
                self.clusterManager.add(annotation)
            }
        }
    }

/// Creates a dictionary which contains the Buildings' as keys and the Artworks which take place there as values. The 'location notes' value is used to determine the building.
    private func configureBuildingDictionary() {
        for artwork in artworks {
            if buildingDictionary[artwork.locationNotes!] == nil {
                buildingDictionary[artwork.locationNotes!] = []
            }
            buildingDictionary[artwork.locationNotes!]?.append(artwork)
        }
    }

    private func readArtworksFromDatabase() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Artwork")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [Artwork] {
                if !artworks.contains(data) {
                    artworks.append(data)
                }
            }
        } catch {
            print("Failed")
        }
    }
}

extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else { return }

        if let cluster = annotation as? ClusterAnnotation {
            /// If a cluster of annotations is selected on the map, the map zooms further to that area.
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
        } else if let annotation = annotation as? ArtworkAnnotation {
            /// If a simple annotation is selected on the map, we save its value.
            selectedArtwork = annotation.artwork
        }
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? ClusterAnnotation {
            /// If the annotation is a Cluster of annotations, it is configured as such.
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
            /// If the annotation is a simple annotation, it is configured as such.
            guard let annotation = annotation as? ArtworkAnnotation else { return nil }
            let identifier = "Pin"
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
            if let view = view {
                view.annotation = annotation
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)

                /// Configures the tooltip which appears when selecting an annotation.
                view!.canShowCallout = true

                /// Setting the  artwork image to the annotation on the left side
                let imageView = UIImageView(frame: CGRect(x: 50, y: 50, width: 50, height: 50))
                imageView.image = UIImage(data: (annotation.artwork.image)! as Data, scale: 1.0)

                view!.leftCalloutAccessoryView = imageView

                /// Setting the information button on the right
                let informationButton = UIButton(type: .detailDisclosure)
                view!.rightCalloutAccessoryView = informationButton
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
        return (Array(buildingDictionary.values)[section]).count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return buildingDictionary.keys.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Array(buildingDictionary.keys)[section]
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ArtworkTableViewCell()
        cell.artwork = (Array(buildingDictionary.values)[indexPath.section])[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /// If we select a row in the table, the map is zoomed to that annotation, and its tooltip appears.
        let selectedArtwork = (Array(buildingDictionary.values)[indexPath.section])[indexPath.row]
        for annotation in clusterManager.annotations {
            if annotation.title! == selectedArtwork.title! {

                let location = CLLocation(latitude: Double.init(selectedArtwork.latitude!)!, longitude: Double.init(selectedArtwork.longitude!)!)
                let regionRadius: CLLocationDistance = 30
                let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)

                mapView.setRegion(coordinateRegion, animated: true)
                mapView.selectAnnotation(annotation, animated: true)
            }
        }
    }


}

