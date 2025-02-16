import SwiftUI
import MapKit

struct Accident: Identifiable {
    let id = UUID()
    let status: String
    let code: String
    let time: String
    let location: String
    let coordinate: CLLocationCoordinate2D
}

struct BackEndView: View {
    @State private var selectedTab = "New"
    
    let mapRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), 
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.05)
        )
    
    let accidents = [
        Accident(status: "New", code: "123455/ZB", time: "10.07 15:35", location: "750 6th Avenue", coordinate: CLLocationCoordinate2D(latitude: 40.748817, longitude: -73.985428)),
        Accident(status: "New", code: "A12398/ZB", time: "10.07 15:35", location: "12 Maplewood Drive", coordinate: CLLocationCoordinate2D(latitude: 40.749817, longitude: -73.986428)),
        Accident(status: "Proceeding", code: "Z23345/ZB", time: "10.07 15:35", location: "750 6th Avenue", coordinate: CLLocationCoordinate2D(latitude: 40.750817, longitude: -73.987428)),
        Accident(status: "New", code: "B456/ZB", time: "10.07 15:35", location: "52 12th Main", coordinate: CLLocationCoordinate2D(latitude: 40.750817, longitude: -73.987428)),
        Accident(status: "New", code: "D1256/ZB", time: "10.07 15:35", location: "23 Long Street Name, San Francisco, CA", coordinate: CLLocationCoordinate2D(latitude: 40.750817, longitude: -73.987428)),
        Accident(status: "Proceeding", code: "C93723/ZB", time: "10.07 15:35", location: "456 Another Road, Oakland, CA", coordinate: CLLocationCoordinate2D(latitude: 40.750817, longitude: -73.987428)),
        Accident(status: "Completed", code: "323345/ZB", time: "10.07 15:35", location: "789 Short Ave, Cupertino, CA", coordinate: CLLocationCoordinate2D(latitude: 40.750817, longitude: -73.987428))
    ]
    
    var filteredAccidents: [Accident] {
        accidents.filter {selectedTab=="All" || $0.status == selectedTab }
    }
    
    var new_filteredAccidents: [Accident] {
        accidents.filter { $0.status == "New" }
    }
    var proceeding_filteredAccidents: [Accident] {
        accidents.filter { $0.status == "Proceeding" }
    }
    var completed_filteredAccidents: [Accident] {
        accidents.filter { $0.status == "Completed" }
    }
    
    
    var body: some View {
        VStack {
            // Left Side - List View
            VStack(alignment: .leading) {
                Text("Accidents")
                    .font(.title)
                    .bold()
                    .padding(.horizontal)
                
                HStack {
                    Spacer()
                    VStack {
                        Text("New")
                            .font(.title3)
                            .bold()
                            .foregroundColor(Color.blue)
                        Text("\(new_filteredAccidents.count)")
                            .font(.title3)
                            .bold()
                            .foregroundColor(Color.blue)
                    }
                    Spacer()
                    Spacer()
                    VStack {
                        Text("Proceeding")
                            .font(.title3)
                            .bold()
                            .foregroundColor(Color.red)
                        Text("\(proceeding_filteredAccidents.count)")
                            .font(.title3)
                            .bold()
                            .foregroundColor(Color.red)
                    }
                    Spacer()
                    Spacer()
                    VStack {
                        Text("Completed")
                            .font(.title3)
                            .bold()
                            .foregroundColor(Color.green)
                        Text("\(completed_filteredAccidents.count)")
                            .font(.title3)
                            .bold()
                            .foregroundColor(Color.green)
                    }
                    Spacer()
                }
                .foregroundColor(.gray)
                
                HStack {
                    ForEach(["All", "New", "Proceeding", "Completed"], id: \.self) { tab in
                        Button(action: { selectedTab = tab }) {
                            Text(tab)
                                .padding()
                                .background(selectedTab == tab ? Color.red : Color.clear)
                                .foregroundColor(selectedTab == tab ? .white : .black)
                                .cornerRadius(10)
                        }
                    }
                }.frame(maxWidth: .infinity, alignment: .center)
                .background(Color(red: 0.9, green: 0.9, blue: 0.9))
                .cornerRadius(10)
                .padding(10)
                
                List(filteredAccidents) { accident in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(accident.status)
                                .bold().font(.system(size:15))
                                .foregroundColor(
                                    colorForStatus(status: accident.status)
                                )
                            Text(accident.code).font(.subheadline)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        VStack(alignment: .leading) {
                            Text("Incident time")
                                .bold().font(.system(size:12))
                            Text(accident.time).font(.subheadline)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        VStack(alignment: .leading) {
                            Text("Location")
                                .bold().font(.system(size:12))
                            Text(accident.location.prefix(9)+"...")
                                .font(.subheadline)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .frame(width: 120)
//                        .background(Color.red)
                        
                        
                    }
                }
                .frame(width: 400)
            }
//            .frame(width: 350)
//            .padding()
            
            Divider()
                .background(Color.red)
            
            Map(coordinateRegion: .constant(mapRegion), showsUserLocation: true)
                            .edgesIgnoringSafeArea(.all)
                            .frame(height: 300)
//            MapView(region: $region)
//                .frame(height: 45)
//                .onTapGesture {
//                    withAnimation {
//                        showFullMap = true
//                        showsUserLocation = false
//                    }
//                }
        }
    }
}

func colorForStatus(status: String) -> Color {
    switch status {
    case "Proceeding":
        return .red
    case "Completed":
        return .green
    default:
        return .blue 
    }
}


struct BackEndView_Previews: PreviewProvider {
    static var previews: some View {
        BackEndView()
    }
}
