//
//  ProfileVC.swift
//  Linkon
//
//  Created by Avion on 7/10/18.
//  Copyright © 2018 Avion. All rights reserved.
//

import UIKit
import LIHImageSlider
import MapKit

class CustomPin:NSObject,MKAnnotation
{
    var coordinate: CLLocationCoordinate2D
    var subtitle: String?
    var title: String?
    
    init(pinTitle:String,pinSubTitle:String,location:CLLocationCoordinate2D) {
        
        self.title = pinTitle
        self.subtitle = pinSubTitle
        self.coordinate = location
        
    }
}

class VendorProfileVC: UIViewController,UIScrollViewDelegate,LIHSliderDelegate,MKMapViewDelegate{

    @IBOutlet weak var mainProfileView: UIView!
    @IBOutlet weak var webVideo: UIWebView!
    
    //for image slider
     @IBOutlet weak var photoGalleryView: UIView!
     fileprivate var sliderVc1: LIHSliderViewController!
    
    // rating view
    @IBOutlet weak var FullstarRating: CosmosView!
     private let starRating:Float = 2.0
    
    //video view
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var myMap: MKMapView!
    @IBOutlet weak var imgProfileView: UIImageView!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControll: UIPageControl!

    @IBOutlet weak var profileView: UIView!
    // for Scroll view
    var images : [String] = ["cell","cell","cell","cell","cell"]

    // for video : https://www.youtube.com/watch?v=_Xk4i44sq38
    //https://www.youtube.com/watch?v=4BCxqrhsjOw
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateMapView()
        self.setNavigationBarItem()
        self.imgProfileView.makeCircle()
        self.btnShare.btnMakeCircle()
        self.btnLike.btnMakeCircle()
        self.videoView.setCardLayoutEffect()
        self.photoGalleryView.setCardLayoutEffect()
        self.mapView.setCardLayoutEffect()
        self.title = "Vendor Profile"
        let value = Double(starRating)
        self.FullstarRating.rating = value
        
        //Image slider configurations
        let images: [UIImage] = [UIImage(named: "cell")!,UIImage(named: "cell")!,UIImage(named: "cell")!,UIImage(named: "cell")!,UIImage(named: "cell")!,UIImage(named: "cell")!]
    
        let slider1: LIHSlider = LIHSlider(images: images)
//        slider1.sliderDescriptions = ["Image 1 description","Image 2 description","Image 3            description","Image 4 description","Image 5 description","Image 6 description"]
        self.sliderVc1  = LIHSliderViewController(slider: slider1)
        sliderVc1.delegate = self
        self.addChildViewController(self.sliderVc1)
        self.sliderVc1.view.setCardLayoutEffect()
        self.mainProfileView.addSubview(self.sliderVc1.view)
        self.sliderVc1.didMove(toParentViewController: self)
      
    }
    // set custom pin
    func updateMapView(){
        
        let location = CLLocationCoordinate2D(latitude: 18.520430, longitude: 73.856744)
        let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        self.myMap.setRegion(region, animated: true)
        
        let pin = CustomPin(pinTitle: "I am Here ", pinSubTitle: "my location", location: location)
        self.myMap.addAnnotation(pin)
        self.myMap.delegate = self
    }
    
    // MKmapView Delegate
    
    // for slider image
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    
        if annotation is MKUserLocation
        {
            return nil
        }
        
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custompin")
        annotationView.image = UIImage(named: "mapIcon")
        annotationView.canShowCallout = true
        return annotationView
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        print("Annotation Title= \(view.annotation?.title!)")
        
    }
    override func viewDidLayoutSubviews() {
        
        self.sliderVc1!.view.frame = self.photoGalleryView.frame
    }
    
    func itemPressedAtIndex(index: Int) {
        
        print("index \(index) is pressed")
    }
 

}
