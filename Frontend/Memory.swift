import Foundation
import CoreLocation

struct Memory: Identifiable {
    let id = UUID()
    let text: String
    let mediaData: [Data]
    let location: CLLocationCoordinate2D
    let date: Date
}
