//
//  DetailsViewController.swift
//  cities-list
//
//  Created by Sunil Targe on 2022/2/26.
//

import UIKit
import MapKit

class DetailsViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    var city: City?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showDetails()
    }
    
    private func showDetails() {
        if let coord = city?.coord {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: coord.lat, longitude: coord.lon)
            if let name = city?.name, let country = city?.country {
                self.title = "\(name), \(country)"
                annotation.title = self.title
            }
            mapView.addAnnotation(annotation)
            let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 12000, longitudinalMeters: 12000)
            mapView.setRegion(region, animated: true)
        }
    }
}

