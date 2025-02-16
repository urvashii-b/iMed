import SwiftUI

struct PhoneCallView: View {
    @State private var callDuration: Int = 0
    @State private var isCallActive: Bool = false
    @State private var beforeCallActive: Bool = true
    @State private var phoneNumber: String = "911"  // Replace with any number
    @State private var timerIsRunning: Bool = true
    
    let timerInterval: TimeInterval = 1 // Interval for the timer to tick
    let cameraAction = "Switch to Camera"
    let endCallAction = "End Call"
    let volumeControlAction = "Volume/Speaker Control"
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.clear, Color.red]), // Start with clear, end with red
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                // Phone number and call duration
                VStack {
                    Text(phoneNumber)
                        .font(.system(size: 70, weight: .bold, design: .default))
                    //                    .padding()
                    if beforeCallActive{
                        Text(".....")
                            .font(.title)
                            .foregroundColor(.gray)
                    }else{
                        Text(callDurationString)
                            .font(.title)
                            .foregroundColor(.gray)
                    }
                    //                    .padding()
                    //                    .backgroundColor(.red)
                }.padding(.top, 20)
                
                Spacer()
                
                // Bottom buttons: Switch to Camera, End Call, Volume/Speaker Control
                HStack {
                    Spacer()
                    Button(action: switchToCamera) {
                        Image(systemName: "camera.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .padding(25)
                            .background(Circle().fill(Color.white))
                            .foregroundColor(.black)
                            .shadow(radius: 5)
                    }
                    .padding(.leading)
                    Spacer()
                    Button(action: endCall) {
                        Image(systemName: "phone.down.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .padding(40)
                            .background(Circle().fill(Color.red))
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                    }
                    Spacer()
                    Button(action: volumeControl) {
                        Image(systemName: "speaker.3.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .padding(25)
                            .background(
                                Circle().fill(Color.white))
                            .foregroundColor(.black)
                            .shadow(radius: 5)
                    }
                    .padding(.trailing)
                    Spacer()
                }
                .padding(.bottom, 30)
            }
            .onAppear {
                delayedTimer()
            }
        }
    }
    // Start the call timer
    func delayedTimer(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            beforeCallActive = false
            isCallActive = true
            startTimer()
        }
    }
    
    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true) { _ in
            if isCallActive {
                callDuration += 1
            }
        }
    }
    
    // Timer as a formatted string (e.g., "00:30")
    var callDurationString: String {
        let minutes = callDuration / 60
        let seconds = callDuration % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    // Actions for the buttons
    func switchToCamera() {
        print("Switch to Camera tapped")
        // Simulate switching to camera (In real app, this would open the camera view)
    }
    
    func endCall() {
        print("End Call tapped")
        isCallActive = false
        
        // Simulate ending the call (In real app, this would hang up the call)
    }
    
    func volumeControl() {
        print("Volume/Speaker Control tapped")
        // Simulate volume/speaker control (In real app, you would control the speaker volume)
    }
}

struct PhoneCallView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneCallView()
    }
}
