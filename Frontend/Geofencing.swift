import Foundation
import CoreLocation

class Geofencing: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    @Published var userLocation: CLLocationCoordinate2D? = nil
    @Published var didEnterRegion = false

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }

    func setupGeofenceAtCurrentLocation() {
        locationManager.requestLocation()
    }

    private func setupGeofence(coordinate: CLLocationCoordinate2D) {
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            let region = CLCircularRegion(center: coordinate, radius: 100.0, identifier: "TimeCapsuleLocation")
            region.notifyOnEntry = true
            region.notifyOnExit = false
            locationManager.startMonitoring(for: region)
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            userLocation = location.coordinate
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location: \(error.localizedDescription)")
    }

    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region.identifier == "TimeCapsuleLocation" {
            didEnterRegion = true
        }
    }

    func requestGeofenceLocation() {
        locationManager.requestLocation()
    }
}
