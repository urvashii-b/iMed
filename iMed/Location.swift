import MapKit

struct Location: Identifiable {
    var id: UUID = UUID()
    var coordinate: CLLocationCoordinate2D
}
