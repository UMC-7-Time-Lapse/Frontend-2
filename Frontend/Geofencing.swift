import Foundation
import CoreLocation

/// Geofencing 클래스는 CLLocationManager를 사용하여 지오펜싱 기능을 제공합니다.
/// 사용자가 특정 위치에 들어갔을 때 didEnterRegion 변수를 true로 설정합니다.
class Geofencing: NSObject, ObservableObject, CLLocationManagerDelegate {
    // CLLocationManager 인스턴스를 생성하여 위치 서비스를 관리합니다.
    private var locationManager = CLLocationManager()
    
    // 사용자의 현재 위치를 저장하는 변수
    @Published var userLocation: CLLocationCoordinate2D? = nil
    
    // 사용자가 지오펜싱 영역에 들어갔을 때를 나타내는 퍼블리시드 변수.
    @Published var didEnterRegion = false
    
    /// 초기화 메서드
    override init() {
        super.init()
        // CLLocationManager 델리게이트 설정
        locationManager.delegate = self
        // 위치 사용 권한 요청
        locationManager.requestAlwaysAuthorization()
        // 사용자 위치 업데이트 시작
        locationManager.startUpdatingLocation()
    }
    
    /// 사용자가 현재 위치에 지오펜싱을 설정하는 메서드
    /// 이 메서드는 사용자가 "캡슐 보관하기" 버튼을 눌렀을 때 호출됩니다.
    func setupGeofenceAtCurrentLocation() {
        // 현재 위치 요청
        locationManager.requestLocation()
    }
    
    /// 지오펜싱 설정 메서드
    /// - Parameter coordinate: 지오펜싱을 설정할 좌표
    private func setupGeofence(coordinate: CLLocationCoordinate2D) {
        // CLCircularRegion을 사용하여 지오펜싱이 가능한지 확인
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            // 지오펜싱 영역 설정 (반경 100미터)
            let region = CLCircularRegion(center: coordinate, radius: 100.0, identifier: "TimeCapsuleLocation")
            // 영역에 진입할 때 알림 설정
            region.notifyOnEntry = true
            // 영역을 떠날 때 알림 설정 (여기서는 사용하지 않음)
            region.notifyOnExit = false
            // 지오펜싱 모니터링 시작
            locationManager.startMonitoring(for: region)
        }
    }
    
    /// CLLocationManagerDelegate 메서드: 위치 업데이트 처리
    /// - Parameters:
    ///   - manager: CLLocationManager 인스턴스, 위치 이벤트를 제공하는 객체
    ///   - locations: CLLocation 객체의 배열, 새로운 위치 데이터가 포함됨
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 배열의 첫 번째 위치 객체를 가져옵니다.
        if let location = locations.first {
            // 사용자의 현재 위치를 업데이트합니다.
            userLocation = location.coordinate
        }
    }
    
    /// CLLocationManagerDelegate 메서드: 위치 업데이트 실패 처리
    /// - Parameters:
    ///   - manager: CLLocationManager 인스턴스, 위치 이벤트를 제공하는 객체
    ///   - error: 발생한 오류를 설명하는 Error 객체
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // 위치 업데이트 실패에 대한 오류 메시지를 출력합니다.
        print("Failed to get user location: \(error.localizedDescription)")
    }
    
    // 사용자가 지오펜싱 영역에 들어갔을 때 호출되는 메서드
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region.identifier == "TimeCapsuleLocation" {
            didEnterRegion = true
        }
    }
    
    /// 현재 위치를 요청하는 메서드
    func requestLocation() {
        locationManager.requestLocation()
    }
}
