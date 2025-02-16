import SwiftUI
struct ImagePickerView: View {
    @Binding var selectedImageData: Data?
    @Binding var image: Image?
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text("Choose a photo")
                .font(.headline)
            
            ImagePickerController(selectedImageData: $selectedImageData) { imageData in
                if let data = imageData {
                    self.selectedImageData = data
                    if let uiImage = UIImage(data: data) {
                        self.image = Image(uiImage: uiImage)
                    }
                }
                presentationMode.wrappedValue.dismiss()
            }
            
            Spacer()
        }
        .padding()
    }
}

struct ImagePickerController: UIViewControllerRepresentable {
    @Binding var selectedImageData: Data?
    var onImagePicked: (Data?) -> Void
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePickerController
        
        init(_ parent: ImagePickerController) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let editedImage = info[.editedImage] as? UIImage {
                if let imageData = editedImage.jpegData(compressionQuality: 0.8) {
                    parent.onImagePicked(imageData)
                }
            }
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.onImagePicked(nil)
        }
    }
}
