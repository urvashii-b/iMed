import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var showFullMap = false
    @State private var showsUserLocation = false
    @State private var profileImage: Image? = Image("user")
    
    @State private var countdown: Int = 5
    @State private var isCountdownActive: Bool = false
    @State private var timer: Timer? = nil
    @State private var showCancelAlert: Bool = false
    @State private var ambulanceOnTheWay: Bool = false
    @State private var userCannotHear: Bool = false
    @State private var userCannotSpeak: Bool = false
    
    @State private var frameOffset: CGFloat = 0
    
    @State private var showTopNotification: Bool = false
    @State private var topNotificationText: String = ""
    
    @State private var isCountdownFinished: Bool = false

    private func startCountdown() {
        countdown = 5
        isCountdownActive = true
        ambulanceOnTheWay = false 
        showTopNotification = false 
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if countdown > 1 {
                countdown -= 1
            } else {
                timer?.invalidate() 
                isCountdownActive = false
                ambulanceOnTheWay = true 
               
                isCountdownFinished = true

                withAnimation(.easeInOut(duration: 1)) {
                    frameOffset = 600 
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation {
                        topNotificationText = "Help is on the way!"
                        showTopNotification = true
                    }
                    
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation {
                            showTopNotification = false
                        }
                    }
                }
            }
        }
    }

    private func stopCountdown() {
        timer?.invalidate()
        isCountdownActive = false
        countdown = 5
        ambulanceOnTheWay = false
        frameOffset = 0 
        showTopNotification = false 
    }
    
    private func dialEmergency() {
        if let url = URL(string: "tel://911") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                print("Cant make calls from this device")
            }
        }
    }

    private func confirmCancelCountdown() {
        showCancelAlert = true
    }

    private func resetFrameOffset() {
        withAnimation(.easeInOut(duration: 1)) {
            frameOffset = 0
        }
    }

    var body: some View {
        NavigationView {
            ZStack {
                MapView(showsUserLocation: $showsUserLocation)
                    .edgesIgnoringSafeArea(.all)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            if isCountdownFinished {
                                Button(action: resetFrameOffset) {
                                    Image(systemName: "house.fill")
                                        .foregroundColor(.red)
                                        .font(.system(size: 22))
                                }
                            }
                        }
                    }

                VStack {
                    
                    if ambulanceOnTheWay {
                        VStack {
                            // Buttons for "I can't hear" and "I can't speak"
                            HStack {
                                NavigationLink(destination: ChatView()) {
                                    Text("I can't hear")
                                        .font(.system(size: 14))
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .padding()
                                        .frame(height: 100)  
                                        .frame(maxWidth: .infinity) 
                                        .background(Color.red)
                                        .cornerRadius(12)
                                        .shadow(radius: 8)
                                        .padding(.top, 15)
                                        .lineLimit(2)  
                                        .truncationMode(.tail)  
                                }
                                
                                NavigationLink(destination: VideoCallView()){
                                    Text("I can't speak")
                                        .font(.system(size: 14))
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .padding()
                                        .frame(height: 100)  
                                        .frame(maxWidth: .infinity) 
                                        .background(Color.red)
                                        .cornerRadius(12)
                                        .shadow(radius: 8)
                                        .padding(.top, 15)
                                        .lineLimit(2)
                                        .truncationMode(.tail)
                                }
                                
                                NavigationLink(destination: EmergencyContactsView()){
                                    Text("Emergency Contacts")
                                        .font(.system(size: 14))
                                        .fontWeight(.bold)
                                        .foregroundColor(.red)
                                        .padding()
                                        .frame(height: 100)  
                                        .frame(maxWidth: .infinity) 
                                        .background(Color.white)
                                        .cornerRadius(12)
                                        .shadow(radius: 8)
                                        .padding(.top, 15)
                                        .lineLimit(2)
                                        .truncationMode(.tail)
                                }
                            }
                            .padding(.horizontal)
                        }
                        Text("Help is On the Way!")
                            .font(.system(size: 24))
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                            .padding(.top, 100)
                            
                    }

                    if !ambulanceOnTheWay {
                        VStack {
                            if showFullMap {
                                MapView(showsUserLocation: $showsUserLocation)
                            } else {
                                MapView(showsUserLocation: $showsUserLocation)
                                    .frame(height: 45)
                                    .onTapGesture {
                                        withAnimation {
                                            showFullMap = true
                                        }
                                    }
                                
                                HStack {
                                    NavigationLink(destination: ProfileView()) {
                                        Image("user")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 45, height: 45)
                                            .clipShape(Circle())
                                            .shadow(radius: 5)
                                            .padding(.leading)
                                    }
                                    
                                    VStack(alignment: .leading) {
                                        Text("Hello, Jess")
                                            .font(.system(size: 16))
                                            .bold()
                                            .foregroundStyle(.secondary)
                                            .padding(.bottom, 2)
                                        NavigationLink(destination: VideoView()){
                                            Text("Do you need help?")
                                                .font(.system(size: 12))
                                                .bold()
                                                .foregroundColor(.red)
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    VStack(alignment: .trailing) {
                                        Text("Emergency Mode")
                                            .font(.system(size: 16))
                                            .bold()
                                            .foregroundStyle(.secondary)
                                            .padding(.bottom, 2)
                                            .padding(.trailing)
                                        
                                        Text("Share your location")
                                            .font(.system(size: 12))
                                            .bold()
                                            .foregroundColor(.red)
                                            .padding(.trailing)
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.top, 10)
                            }

                            VStack {
                                if isCountdownActive {
                                    VStack {
                                        Text("\(countdown)")
                                            .font(.system(size: 120, weight: .bold))
                                            .foregroundColor(.white)
                                            .frame(width: 250, height: 250)
                                            .background(Circle().fill(Color.red).shadow(radius: 10))
                                            .overlay(Circle().stroke(Color.white, lineWidth: 5))
                                        
                                        Button(action: confirmCancelCountdown) {
                                            Text("Cancel")
                                                .font(.title2)
                                                .foregroundColor(.red)
                                                .padding(.top, 15)
                                                .padding(.bottom, 15)
                                        }
                                        .alert(isPresented: $showCancelAlert) {
                                            Alert(
                                                title: Text("Cancel Countdown"),
                                                message: Text("Are you sure you want to cancel?"),
                                                primaryButton: .destructive(Text("Yes")) {
                                                    stopCountdown()
                                                },
                                                secondaryButton: .cancel()
                                            )
                                        }
                                    }
                                    .padding(.top, 160)
                                } else {
                                    VStack {
                                        Text("Emergency Help Needed?")
                                            .bold()
                                            .font(.largeTitle)
                                            .multilineTextAlignment(.center)
                                            .padding(.bottom, 7)
                                        
                                        Text("Just hold the button to book an ambulance.")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                            .multilineTextAlignment(.center)
                                    }
                                    .padding(.bottom, 25)
                                    .padding(.top, 40)
                                    Button(action: startCountdown) {
                                        Image("logo")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 250, height: 250)
                                            .clipShape(Circle())
                                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                            .shadow(radius: 10)
                                    }
                                    
                                }
                            }
                        }
                    }

                    Spacer()
                    
                    HStack {
                        Spacer()
                        NavigationLink(destination: VideoView()) {
                            VStack {
                                Image(systemName: "book.fill")
                                    .font(.title2)
                                Text("Videos")
                                    .font(.caption)
                            }
                        }
                        Spacer()
                        NavigationLink(destination: MapView(showsUserLocation: $showsUserLocation)) {
                            VStack {
                                Image(systemName: "map.fill")
                                    .font(.title2)
                                Text("Maps")
                                    .font(.caption)
                            }
                        }

                        Spacer()
                        NavigationLink(destination: PhoneCallView()) {
                            VStack {
                                Image(systemName: "phone.fill")
                                    .font(.title2)
                                Text("Phone")
                                    .font(.caption)
                                    .onTapGesture {
                                        dialEmergency()
                                    }
                            }
                        }
                        
                        Spacer()
                        NavigationLink(destination: ChatView()) {
                            VStack {
                                Image(systemName: "bubble.left.and.bubble.right.fill")
                                    .font(.title2)
                                Text("Chat")
                                    .font(.caption)
                            }
                        }
                        Spacer()
                    }
                    .padding()
                    .background(Color.white)
                    .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: -2)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemGroupedBackground))
                .offset(y: frameOffset) 
                
                if showTopNotification {
                    VStack {
                        Spacer()
                        HStack {
                            Text(topNotificationText)
                                .font(.headline)
                                .bold()
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                                .padding(.top)
                                .frame(maxWidth: .infinity)
                                .transition(.move(edge: .top)) 
                        }
                        .padding(.horizontal)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top) 
                    .animation(.easeInOut(duration: 1))
                }
            }
        }
    }
}
#Preview {
    ContentView()
}
