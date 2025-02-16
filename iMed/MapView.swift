import SwiftUI
import MapKit
import CoreLocation

// Extend MKPointAnnotation to conform to Identifiable
extension MKPointAnnotation: Identifiable {
    public var id: UUID {
        return UUID()
    }
}

struct MapView: View {
    @Binding var showsUserLocation: Bool
    @State private var region: MKCoordinateRegion
    @State private var annotations: [MKPointAnnotation] = []
    @State private var selectedAnnotation: MKPointAnnotation? // Store the selected annotation
    @State private var showInfoModal = false // Whether to show info modal
    @State private var userLocation: CLLocationCoordinate2D? // Store the user's location
    @State private var userAddress: String? // Store the user's address
    @State private var route: MKRoute? // Store the calculated route
    
    init(showsUserLocation: Binding<Bool>) {
        self._showsUserLocation = showsUserLocation
        self._region = State(initialValue: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.3349, longitude: -122.0090), // Apple Headquarters, Cupertino, CA
            span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02) // Adjusted zoom level to zoom out
        ))
    }
    
    var body: some View {
        Map(coordinateRegion: $region, showsUserLocation: showsUserLocation, annotationItems: annotations) { annotation in
            // Using MapAnnotation to provide custom views
            MapAnnotation(coordinate: annotation.coordinate) {
                VStack {
                    // Replace Circle() with a custom image (star)
                    Image(systemName: "star.fill") // Using SF Symbol for a star
                        .foregroundColor(annotation.title == "User Location" ? .green : .red)
                        .font(.title) // Change size of the star (this makes it bigger)
                        .frame(width: 30, height: 30) // Increase the size here
                    
                    Text(annotation.title ?? "")
                        .foregroundColor(.black)
                        .font(.caption)
                        .padding(5)
                        .background(Color.white)
                        .cornerRadius(5)
                        .shadow(radius: 3)
                }
                .onTapGesture {
                    // Show info modal when a red pin is tapped
                    if annotation.title != "User Location" {
                        selectedAnnotation = annotation
                        showInfoModal.toggle()
                    }
                }
            }
        }
        .onAppear {
            setupAnnotations()
            requestUserLocation()
        }
        .edgesIgnoringSafeArea(.all)
        .alert(isPresented: $showInfoModal) {
            Alert(
                title: Text("Go to \(selectedAnnotation?.title ?? "Location")"),
                message: Text("Do you want to navigate to this location?"),
                primaryButton: .default(Text("Yes")) {
                    // Ensure the userLocation is not nil before calling navigateTo()
                    if let userLocation = userLocation, let destination = selectedAnnotation {
                        navigateTo(from: userLocation, to: destination)
                    }
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    private func requestUserLocation() {
        // Set the user location to Apple's headquarters (Cupertino, CA)
        userLocation = CLLocationCoordinate2D(latitude: 37.3349, longitude: -122.0090)
        
        // Use CLGeocoder to get the address for the user location
        if let location = userLocation {
            let geocoder = CLGeocoder()
            let userCLLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
            
            geocoder.reverseGeocodeLocation(userCLLocation) { placemarks, error in
                if let placemark = placemarks?.first {
                    // Format the address from the placemark and set it to the user location annotation
                    let address = "\(placemark.thoroughfare ?? ""), \(placemark.locality ?? ""), \(placemark.administrativeArea ?? "")"
                    userAddress = address
                    
                    // Create the user location annotation
                    let userLocationAnnotation = MKPointAnnotation()
                    userLocationAnnotation.coordinate = location
                    userLocationAnnotation.title = "User Location" // Ensure the title is "User Location" for the green star
                    annotations.append(userLocationAnnotation) // Add annotation for user location
                    
                    // Set the region to center around user location
                    region.center = location
                    
                    // Enable user location visibility
                    showsUserLocation = true
                }
            }
        }
    }
    
    private func setupAnnotations() {
        // Sample nearby hospitals, healthcare centers, and pharmacies
        let hospitals = [
            CLLocationCoordinate2D(latitude: 37.3355, longitude: -122.0100), // Example Hospital 1
            CLLocationCoordinate2D(latitude: 37.3380, longitude: -122.0115), // Example Hospital 2
            CLLocationCoordinate2D(latitude: 37.3360, longitude: -122.0130), // Example Hospital 3
            CLLocationCoordinate2D(latitude: 37.3375, longitude: -122.0085), // Example Hospital 4
            CLLocationCoordinate2D(latitude: 37.3340, longitude: -122.0125)  // Example Hospital 5
        ]
        
        let pharmacies = [
            CLLocationCoordinate2D(latitude: 37.3365, longitude: -122.0105), // Example Pharmacy 1
            CLLocationCoordinate2D(latitude: 37.3350, longitude: -122.0090), // Example Pharmacy 2
            CLLocationCoordinate2D(latitude: 37.3370, longitude: -122.0140), // Example Pharmacy 3
            CLLocationCoordinate2D(latitude: 37.3345, longitude: -122.0075)  // Example Pharmacy 4
        ]
        
        let healthcareCenters = [
            CLLocationCoordinate2D(latitude: 37.3390, longitude: -122.0060), // Example Healthcare Center 1
            CLLocationCoordinate2D(latitude: 37.3355, longitude: -122.0075), // Example Healthcare Center 2
            CLLocationCoordinate2D(latitude: 37.3365, longitude: -122.0100)  // Example Healthcare Center 3
        ]
        
        // Add the annotations for hospitals
        for hospital in hospitals {
            let annotation = MKPointAnnotation()
            annotation.coordinate = hospital
            annotation.title = "Hospital"
            annotations.append(annotation)
        }
        
        // Add the annotations for pharmacies
        for pharmacy in pharmacies {
            let annotation = MKPointAnnotation()
            annotation.coordinate = pharmacy
            annotation.title = "Pharmacy"
            annotations.append(annotation)
        }
        
        // Add the annotations for healthcare centers
        for healthcare in healthcareCenters {
            let annotation = MKPointAnnotation()
            annotation.coordinate = healthcare
            annotation.title = "Healthcare Center"
            annotations.append(annotation)
        }
    }
    
    private func navigateTo(from userCoordinate: CLLocationCoordinate2D, to destination: MKPointAnnotation) {
        // Ensure destination coordinate is valid
        let destinationCoordinate = destination.coordinate
        
        // Create MKMapItems for user location and destination
        let userMapItem = MKMapItem(placemark: MKPlacemark(coordinate: userCoordinate))
        let destinationMapItem = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinate))
        
        userMapItem.name = "User Location"
        destinationMapItem.name = destination.title
        
        // Open Apple Maps directly for navigation
        let launchOptions: [String: Any] = [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ]
        
        destinationMapItem.openInMaps(launchOptions: launchOptions)
    }
}
