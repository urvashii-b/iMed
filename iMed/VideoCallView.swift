import SwiftUI

struct VideoCallView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text("Video Call in Progress")
                .font(.title)
                .bold()
                .padding(.top, 20)
            
            Text("The medical team is now on a video call with you.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.top, 10)
            
            Spacer()
            
            // Example of a button to end the video call
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("End Call")
                    .font(.headline)
                    .foregroundColor(.red)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            .padding(.bottom, 20)
        }
        .padding()
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Video Call")
    }
}

#Preview {
    VideoCallView()
}
