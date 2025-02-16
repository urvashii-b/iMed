import SwiftUI
import AVFAudio
import AVKit
import AVFoundation

struct Message: Identifiable {
    let id = UUID()
    let text: String
    let isUserMessage: Bool
    let timestamp: Date
    let isFeedback: Bool
    let foundVideo: String
    
}

struct ChatView: View {
    @State private var messages: [Message] = []
    @State private var userInput: String = ""
    var genaiURL = URL(string:"https://api.com/v2/chat/completions")!
    private var a3tok:String =  "<tok>"
    
    func sendRequest(message: String) async throws -> String {
        print(genaiURL)
        var request = URLRequest(url: genaiURL)
        print(request.allHTTPHeaderFields)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("171042", forHTTPHeaderField: "X-Client-App-ID")
        request.setValue(a3tok, forHTTPHeaderField: "X--Token")
        
        let messageList = messages.filter{ $0.isUserMessage }.suffix(min(10, messages.count)).map { ["text": $0.text] }

        
        let reqBody: [String: Any] = [
            "model_id": "x",
            "messages": [
                [
                    "role": "system",
                    "contents": [
                        [
//                            "text": "You are an AI assistant working for critical medical purposes. Your task is to understand the medical condition in the user prompt and any criticalities conveyed by them and respond with first-aid steps to help them in emergency. Only respond to user questions related to medical emergencies or medical queries. Your response must be easily readable and understandable to the user. Your response must include only the steps to take in bullet format and not have any introductory or concluding paragraphs. Each bullet must contain minimum number of words possible to correctly convey what is to be done. Do not add false information. "
                            "text": "You are iMED, an AI assistant designed to provide quick and accurate guidance in medical and emergency situations. Your responses must be short, direct, and medically relevant. Do not use more than 30 words"
                        ]
                    ]
                ],
                [
                    "role": "user",
                    "contents": [
                        [
                        "text": message
                    ]
                    ]
                ]
            ],
            "generation_config": [
                "temperature": 0,
                "top_p": 1
            ]
        ]
        
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: reqBody, options: .prettyPrinted)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print(jsonString)
            }
        } catch {
            let jsonString = ""
            print("Error converting dictionary to JSON: \(error)")
        }
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: reqBody, options: [])
        
        print(request.allHTTPHeaderFields)
        print(Date())


        let (res,_) = try await URLSession.shared.data(for: request)
        var text: String = ""
        
        do {
            guard let responseBody = try JSONSerialization.jsonObject(with: res, options: []) as? [String: Any] else {
                print("Error: Could not serialize JSON")
                return ""
            }

            // "choices" -> index 0 -> "message" -> "text"
            print(responseBody)
            let choices = responseBody["choices"] as? [[String: Any]]
            let message = choices?.first?["message"] as? [String: Any]
            text = message?["text"] as? String ?? ""
            print("Field Value: \(text)")
            

        } catch {
            print("Error parsing JSON: \(error)")
        }
        
        return text
        
    }
    
    
    
    @State private var typingAnimation = ""
    @State private var typingTimer: Timer? = nil
    @State private var chatbotResponse = ""
    private let typingInterval: TimeInterval = 0.5 
    private let typingMaxDots = 3 
    
    var body: some View {
        VStack {
            Text("iMed Chatbot")
                .font(.title)
                .background(Image(systemName:""))
            
            ScrollView {
                VStack {
                    ForEach(messages) { message in
                        HStack(alignment: .top) {
                                if message.isUserMessage {
                                    Spacer()
                                    Text(message.text)
                                        .padding()
                                        .background(Color.blue)
                                        .cornerRadius(25)
                                        .foregroundColor(.white)
                                } else {
                                    Image(systemName: "bandage.fill")
                                        .padding(.top, 10)
                                        .foregroundColor(.green)
                                        .font(.title)
                                    
                                    Text("\(message.text)")
                                        .padding()
                                        .background(Color(.systemGray6))
                                        .cornerRadius(25)
                                        .animation(.easeIn, value: message.text)
                                    Spacer()
                                }
//                                if (message.isFeedback){
//                                    HStack{
//                                        Spacer()
//                                        Button(action:{
//                                            Task {
//                                                    do {
//                                                        messages.removeLast()
//                                                        try await sendMessage(message: "Thanks") // Call the async function inside the Task
//                                                    } catch {
//                                                        print("Error: \(error)")
//                                                    }
//                                                }
//                                        }){
//                                            Text("Yes") // Customize the font
//                                                .foregroundColor(.white) // Text color
//                                                .padding() // Padding around the text
//                                                .background(.green) // Gradient background
//                                                .cornerRadius(10) // Rounded corners
//                                        }
//                                        Button(action:{
//                                            Task {
//                                                    do {
//                                                        messages.removeLast()
//                                                        try await sendMessage(message: "Give me a better response") // Call the async function inside the Task
//                                                    } catch {
//                                                        print("Error: \(error)")
//                                                    }
//                                                }
//                                        }){
//                                            Text("No") // Customize the font
//                                                .foregroundColor(.white) // Text color
//                                                .padding() // Padding around the text
//                                                .background(.red) // Gradient background
//                                                .cornerRadius(10) // Rounded corners
//                                        }
//                                        Spacer()
//                                    }
//                                }
                            }
                        if (message.foundVideo != ""){
                            VStack{
                                HStack{
                                    Image(systemName: "bandage.fill")
                                        .padding(.top, 10)
                                        .foregroundColor(.green)
                                        .font(.title)
                                    
                                    Text("Take a look at the below video!")
                                        .padding()
                                        .background(Color(.systemGray6))
                                        .cornerRadius(25)
                                        .animation(.easeIn, value: message.text)
                                    Spacer()
                                
                                }
                                videoDictionary[message.foundVideo]?.padding()
                            }
                                
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 5)
        }
        
        Spacer()
        
        HStack {
            TextField("Enter your emergency", text: $userInput)
                .padding()
                .background(Color.white)
                .cornerRadius(30)
                .shadow(radius: 5)
                .overlay {
                    HStack {
                        Spacer()
                        Button(action: {
                            Task {
                                    do {
                                        let tempInput = userInput
                                        userInput = ""
                                        try await sendMessage(message: tempInput) 
                                    } catch {
                                        print("Error: \(error)")
                                    }
                                }
                        }) {
                            Image(systemName: "paperplane.fill")
                                .foregroundColor(.red)
                                .font(.title)
                        }
                        .disabled(userInput.isEmpty)
                        .padding(.horizontal)
                    }
                }
                .padding(.horizontal)
            
            Button(action: {
                getAudioInput()
            }) {
                Image(systemName:"microphone.fill")
                    .font(.title)
                    .foregroundColor(.blue)
            }
            .padding()
            
            Spacer()
        }
        .padding(.top, 10)
        
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        let player = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource:"CPR", ofType:"mov")!)
//                              )
//        let layer = AVPlayerLayer(player: player)
////        layer.frame = view.bounds
////        view.layer.addSublayer(layer)
//        player.play()
//    }
        
        private func getAudioInput() {
            let recording = AVAudioRecorder()
            repeat {
                recording.record()
            } while (recording.isRecording)
            print("Done Recording")
        }
        
        
        // Start the typing animation with a Timer
        func startTypingAnimation() {
            var dotCount = 0
            typingTimer = Timer.scheduledTimer(withTimeInterval: typingInterval, repeats: true) { timer in
                // Update the typing animation with a changing number of dots
                dotCount = (dotCount % typingMaxDots) + 1
                typingAnimation = String(repeating: ".", count: dotCount)
            }
        }
    
    func findFirstMatchingVideo(in sentence: String) -> String {
        let words = sentence.lowercased().split(separator: " ").map { String($0) }

        for key in videoDictionary.keys {
            if words.contains(key) {
                return key // ✅ Return the first matching key
            }
        }
        
        return "" // ❌ No match found
    }

        
    private func sendMessage(message: String) async throws -> Void {
        let newMessage = Message(text: message, isUserMessage: true, timestamp: Date(), isFeedback: false, foundVideo: "")
            messages.append(newMessage)
        
        let thinkingMessage = Message(text: "Thinking...", isUserMessage: false, timestamp: Date(), isFeedback: false, foundVideo: "")
        messages.append(thinkingMessage)

        
        
            chatbotResponse = ""
            typingAnimation = ""
        
        let response: String = try await sendRequest(message: message)
            

            
            

  
                    messages.removeLast()
                    let botMessage = Message(
                        text: response,
                        isUserMessage: false,
                        timestamp: Date(),
                        isFeedback: false,
                        foundVideo: findFirstMatchingVideo(in: message)
                    )
                    messages.append(botMessage)
                
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                    // Create and append the bot response
//                    let botMessage = Message(
//                        text: "Did this help?",
//                        isUserMessage: false,
//                        timestamp: Date(),
//                        isFeedback: true,
//                        foundVideo: ""
//                    )
//                    messages.append(botMessage)
//                }
        }
    }
    

#Preview {
    ChatView()
}
