//
//  MapViewController.swift
//  OpenMRS-iOS
//
//  Created by Parker on 4/19/16.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController : UIViewController
{
    @objc var patient: MRSPatient! {
        didSet {
            self.title = patient.name

            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(patient.formattedPatientAddress()) { (placemark: [CLPlacemark]?, error: Error?) in
                if placemark != nil && !(placemark?.isEmpty)!
                {
                    let place = placemark![0]
                    self.mapView.setCenter((place.location?.coordinate)!, animated: true)

                    let span = MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3)
                    let region = MKCoordinateRegion(center: (place.location?.coordinate)!, span: span)

                    self.mapView.setRegion(region, animated: true)

                    let annotation = PatientAddressAnnotation(coordinate: (place.location?.coordinate)!, title: self.patient.displayName, subtitle: self.patient.formattedPatientAddress())
                    self.mapView.addAnnotation(annotation)
                }
                else
                {
                    self.navigationController?.popViewController(animated: true)

                    let alert = UIAlertController(title: "Couldn't find address", message: "It may be spelled incorrectly", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))

                    self.navigationController?.present(alert, animated: true, completion: nil)
                }
            }
        }
    }

    var mapView: MKMapView!

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        mapView = MKMapView(frame: self.view.bounds)

        mapView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(mapView)

        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview" : mapView]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview" : mapView]))
    }

}
