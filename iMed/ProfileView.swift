import SwiftUI
import UIKit

struct ProfileView: View {
    
    @State private var name: String = "Jess Doe"
    @State private var phoneNumber: String = "123-456-7890"
    @State private var profileImage: Image? = Image("user")
    @State private var selectedImageData: Data? = nil
    @State private var emergencyContacts: [EmergencyContact] = []
    @State private var showImagePicker: Bool = false
    
    // Medical details - default values
    @State private var bloodGroup: String = "O+"
    @State private var pastMedicalHistory: String = "Asthma"
    @State private var allergies: String = "Peanuts"
    
    @State private var isEditingMedicalCard: Bool = false
    
    // state vars for adding new emergency contacts
    @State private var newEmergencyContactName: String = ""
    @State private var newEmergencyContactPhone: String = ""
    
    init() {
        loadProfileImageFromDefaults()
        loadEmergencyContactsFromDefaults()
        loadMedicalDetailsFromDefaults()
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                // Profile Picture
                VStack {
                    ZStack {
                        profileImage?
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
                            .shadow(radius: 10)
                        
                        Button(action: {
                            showImagePicker.toggle()
                        }) {
                            Image(systemName: "camera.circle.fill")
                                .font(.title)
                                .foregroundColor(.blue)
                                .padding(8)
                        }
                        .background(Color.white)
                        .clipShape(Circle())
                        .offset(x: 40, y: 40)
                    }
                }
                .padding(.top, 30)
                .padding(.horizontal, 20)
                
                // Name and Phone Number
                Group {
                    Text("Name")
                        .font(.headline)
                    TextField("Enter your name", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.bottom, 10)

                    Text("Phone Number")
                        .font(.headline)
                    TextField("Enter your phone number", text: $phoneNumber)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.phonePad)
                        .padding(.bottom, 10)
                }
                .padding(.horizontal, 20)

                // Emergency Contacts
                VStack(alignment: .leading) {
                    Text("Emergency Contacts")
                        .font(.headline)
                        .foregroundColor(.red)
                        .padding(.bottom, 5)
                        .padding(.top, 20)

                    ForEach(emergencyContacts, id: \.id) { contact in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(contact.name)
                                    .font(.subheadline)
                                    .bold()
                                Text(contact.phoneNumber)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Button(action: {
                                // Remove contact functionality
                                removeEmergencyContact(contact)
                            }) {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundColor(.red)
                            }
                        }
                        .padding(.vertical, 5)
                    }.padding(.horizontal, 20)
                    
                    // new emergency contact
                    VStack(alignment: .leading) {
                        Text("Add New Contact")
                            .font(.subheadline)
                            .padding(.top, 10)
                        TextField("Enter Name", text: $newEmergencyContactName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.bottom, 5)
                        TextField("Enter Phone Number", text: $newEmergencyContactPhone)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.phonePad)
                            .padding(.bottom, 10)
                        
                        Button(action: addEmergencyContact) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("Add Emergency Contact")
                                    .font(.subheadline)
                            }
                            .foregroundColor(.blue)
                        }
                    }
                }
                .padding(.horizontal)

                // Medical Card
                VStack(alignment: .leading) {
                    Text("Medical Card")
                        .font(.headline)
                        .foregroundColor(.red)
                        .padding(.top, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                    
                    //Blood group
                    HStack {
                        Text("Blood Group")
                            .font(.subheadline)
                        Spacer()
                        if isEditingMedicalCard{
                            TextField("Blood Group", text: $bloodGroup).textFieldStyle(RoundedBorderTextFieldStyle())
                        } else {
                            Text(bloodGroup)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.bottom, 10)
                    
                    // past medical history
                    HStack {
                        Text("Past Medical History")
                            .font(.subheadline)
                        Spacer()
                        if isEditingMedicalCard {
                            TextField("Past Medical History", text: $pastMedicalHistory).textFieldStyle(RoundedBorderTextFieldStyle())
                        } else {
                            Text(pastMedicalHistory)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.bottom, 10)
                    
                    // Allergies
                    HStack {
                        Text("Allergies")
                            .font(.subheadline)
                        Spacer()
                        if isEditingMedicalCard {
                            TextField("Allergies", text: $allergies).textFieldStyle(RoundedBorderTextFieldStyle())
                        } else {
                            Text(allergies)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.bottom, 10)

                    Button(action: toggleEditMedicalCard) {
                        HStack {
                            Image(systemName: isEditingMedicalCard ? "checkmark.circle.fill":"pencil.circle.fill")
                            Text(isEditingMedicalCard ? "Save": "Edit Medical Card")
                        }
                        .foregroundColor(.blue)
                    }
                    .padding(.top, 10)
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 30)
        }
        .navigationBarTitle("Profile", displayMode: .inline)
        .sheet(isPresented: $showImagePicker) {
            ImagePickerView(selectedImageData: $selectedImageData, image: $profileImage)
        }
        .onAppear {
            loadProfileImageFromDefaults()
            loadEmergencyContactsFromDefaults()
            loadMedicalDetailsFromDefaults()
        }
    }
    
    private func addEmergencyContact() {
        guard !newEmergencyContactName.isEmpty && !newEmergencyContactPhone.isEmpty else { return }
        let newContact = EmergencyContact(name: newEmergencyContactName, phoneNumber: newEmergencyContactPhone)
        emergencyContacts.append(newContact)
        saveEmergencyContactsToDefaults()  // Save after adding contact
        newEmergencyContactName = ""
        newEmergencyContactPhone = ""
    }
    
    private func removeEmergencyContact(_ contact: EmergencyContact) {
        if let index = emergencyContacts.firstIndex(where: { $0.id == contact.id }) {
            emergencyContacts.remove(at: index)
            saveEmergencyContactsToDefaults()  // Save after removing contact
        }
    }
    
    private func toggleEditMedicalCard() {
        isEditingMedicalCard.toggle()
        
        if !isEditingMedicalCard {
            saveMedicalDetailsToDefaults()  // Save changes when the user exits the edit mode
        }
    }

    private func saveProfileImageToDefaults() {
        if let selectedImageData = selectedImageData {
            UserDefaults.standard.set(selectedImageData, forKey: "profileImage")
        }
    }
    
    private func loadProfileImageFromDefaults() {
        if let savedImageData = UserDefaults.standard.data(forKey: "profileImage"),
           let uiImage = UIImage(data: savedImageData) {
            self.profileImage = Image(uiImage: uiImage)
        }
    }

    private func saveEmergencyContactsToDefaults() {
        if let encodedData = try? JSONEncoder().encode(emergencyContacts) {
            UserDefaults.standard.set(encodedData, forKey: "emergencyContacts")
        }
    }
    
    private func loadEmergencyContactsFromDefaults() {
        if let savedData = UserDefaults.standard.data(forKey: "emergencyContacts"),
           let decodedContacts = try? JSONDecoder().decode([EmergencyContact].self, from: savedData) {
            self.emergencyContacts = decodedContacts
        }
    }

    private func saveMedicalDetailsToDefaults() {
        UserDefaults.standard.set(bloodGroup, forKey: "bloodGroup")
        UserDefaults.standard.set(pastMedicalHistory, forKey: "pastMedicalHistory")
        UserDefaults.standard.set(allergies, forKey: "allergies")
    }
    
    private func loadMedicalDetailsFromDefaults() {
        if let savedBloodGroup = UserDefaults.standard.string(forKey: "bloodGroup") {
            self.bloodGroup = savedBloodGroup
        }
        if let savedPastHistory = UserDefaults.standard.string(forKey: "pastMedicalHistory") {
            self.pastMedicalHistory = savedPastHistory
        }
        if let savedAllergies = UserDefaults.standard.string(forKey: "allergies") {
            self.allergies = savedAllergies
        }
    }
}

struct EmergencyContact: Identifiable, Codable {
    let id = UUID()
    let name: String
    let phoneNumber: String
}
