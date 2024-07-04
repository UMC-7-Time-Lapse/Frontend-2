import Foundation
import CoreLocation
import UserNotifications

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    @Published var userLocation: CLLocationCoordinate2D?
    private var monitoredRegions: [CLCircularRegion] = []

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func startMonitoringRegion(for memory: Memory) {
        let region = CLCircularRegion(center: memory.location, radius: 100, identifier: memory.id.uuidString)
        region.notifyOnEntry = true
        locationManager.startMonitoring(for: region)
        monitoredRegions.append(region)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        DispatchQueue.main.async {
            self.userLocation = location.coordinate
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location: \(error.localizedDescription)")
    }

    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if let circularRegion = region as? CLCircularRegion {
            triggerNotification(for: circularRegion)
        }
    }

    private func triggerNotification(for region: CLCircularRegion) {
        let content = UNMutableNotificationContent()
        content.title = "캡슐을 열 수 있습니다!"
        content.body = "현재 위치에서 캡슐을 열 수 있습니다. 캡슐을 확인해보세요."
        content.sound = UNNotificationSound.default

        let request = UNNotificationRequest(identifier: region.identifier, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("알림 트리거 실패: \(error.localizedDescription)")
            }
        }
    }
}
