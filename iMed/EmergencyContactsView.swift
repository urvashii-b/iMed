import SwiftUI
import UIKit

struct EmergencyContact1: Identifiable {
    let id = UUID()
    let name: String
    let relation: String
    let phoneNumber: String
    let icon: String
}

struct EmergencyContactsView: View {
    let contacts: [EmergencyContact1] = [
        EmergencyContact1(name: "Mom", relation: "Family", phoneNumber: "+1 123-456-7890", icon: "heart.fill"),
        EmergencyContact1(name: "John", relation: "Friend", phoneNumber: "+1 987-654-3210", icon: "person.fill"),
        EmergencyContact1(name: "Sara", relation: "Doctor", phoneNumber: "+1 456-789-0123", icon: "cross.case.fill")
    ]
    
    var body: some View {
        NavigationStack {
            List(contacts) { contact in
                HStack(spacing: 16) {
                    // Contact Icon
                    Circle()
                        .fill(Color.red.opacity(0.1))
                        .frame(width: 50, height: 50)
                        .overlay(
                            Image(systemName: contact.icon)
                                .foregroundColor(.red)
                                .font(.system(size: 22))
                        )
                    
                    // Contact Info
                    VStack(alignment: .leading, spacing: 6) {
                        Text(contact.name)
                            .font(.system(size: 20, weight: .semibold))
                        Text(contact.relation)
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                        Text(contact.phoneNumber)
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    // Call Button
                    Button(action: {
                        if let url = URL(string: "tel://\(contact.phoneNumber)"),
                           UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Circle()
                            .fill(Color.green.opacity(0.1))
                            .frame(width: 44, height: 44)
                            .overlay(
                                Image(systemName: "phone.fill")
                                    .foregroundColor(.green)
                                    .font(.system(size: 20))
                            )
                    }
                }
                .padding(.vertical, 8)
            }
            .listStyle(.plain)
            .navigationTitle("Emergency Contacts")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: ProfileView()){
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.red)
                            .font(.system(size: 22))

                    }
                }
            }
        }
    }
}

#Preview {
    EmergencyContactsView()
}
