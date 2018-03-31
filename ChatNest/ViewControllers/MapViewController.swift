import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var messages: [Message]?

    @IBAction func Close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationManager.shared.start()
        // draw the region in mapview
         findCoordinates()
        
        mapView.showsUserLocation = true
        NSLog("Got messages \(String(describing: messages?.count))")
        messages?.forEach() { item in
            plotUsersonGraph(latitude: item.latitude,longitude: item.longitude,title: item.senderName,subtitle: item.text)
        }
    }
    
    func plotUsersonGraph(latitude:Double,longitude:Double,title:String,subtitle:String){
      
        let userlocation = CLLocationCoordinate2DMake(latitude, longitude)
        let annotation = MKPointAnnotation()
        annotation.coordinate = userlocation
        annotation.title = title
        annotation.subtitle = subtitle
        mapView.addAnnotation(annotation)
    }
    
    //this function returns boundary coordinates for box
    
    func findCoordinates() {
        
        guard let latMax = messages?.first?.latitude else {
            return
        }
        messages?.forEach() { item in
            if latMax <= item.latitude {
                let latMax = item.latitude
            }
        }
        NSLog("LAT MAX IS: \(String(describing: latMax))")
        guard let latMin = messages?.first?.latitude else {
            return
        }
        messages?.forEach() { item in
            if latMin >= item.latitude {
                let latMin = item.latitude
            }
        }
        NSLog("LAT MIN IS: \(String(describing: latMin))")

        guard let longMax = messages?.first?.longitude else {
            return
        }
        messages?.forEach() { item in
            if longMax <= item.longitude {
              let longMax = item.longitude
            }
        }
        NSLog("LONG MAX IS: \(String(describing: longMax))")

        guard let longMin = messages?.first?.longitude else {
            return
        }
        messages?.forEach() { item in
            if longMin >= item.longitude {
              let longMin = item.longitude
            }
        }
        NSLog("LONG MIN IS: \(String(describing: longMin))")
        
        guard let userLoc = LocationManager.shared.coord else {
            return
        }
        
    
      //mapReg = MKMapView(frame: CGRect(x: longMin, y: latMax, width: longMin - longMax, height: latMax - latMin))
        let mapSpan = MKCoordinateSpan(latitudeDelta: latMax - latMin, longitudeDelta: longMin - longMax)
        let mapReg = MKCoordinateRegionMake(userLoc, mapSpan)
        self.mapView.setRegion(mapReg, animated: true)
    }
  
}
