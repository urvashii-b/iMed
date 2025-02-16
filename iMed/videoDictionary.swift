import Foundation

// Global dictionary storing only video metadata
let videoDictionary: [String: (title: String, date: String, videoName: String, description: String)] = [
    "seizure": ("Handling a seizure", "5:45", "seizure",
                "Learn how to assist someone having a seizure by ensuring safety and providing appropriate care."),
    
    "choking": ("Responding to choking", "2:30", "choking",
                "Step-by-step guide on how to help someone who is choking, including the Heimlich maneuver."),
    
    "heart_attack": ("Managing a heart attack", "4:15", "heart_attack",
                     "Recognize heart attack symptoms and provide essential first aid before emergency help arrives."),
    
    "stroke": ("Recognizing and reacting to a stroke", "6:10", "stroke",
               "Identify stroke warning signs using FAST (Face, Arms, Speech, Time) and take quick action."),
    
    "bleeding": ("Stopping severe bleeding", "3:55", "bleeding",
                 "Learn how to control heavy bleeding effectively and prevent excessive blood loss."),
    
    "burns": ("Treating burns", "2:20", "burns",
              "Understand different types of burns and how to treat them safely."),
    
    "anaphylaxis": ("Dealing with an allergic reaction (anaphylaxis)", "4:50", "anaphylaxis",
                    "Recognize severe allergic reactions and administer an EpiPen if necessary."),
    
    "fainting": ("Helping someone who faints", "3:10", "fainting",
                 "Know what to do when someone faints to ensure a safe recovery."),
    
    "poisoning": ("Responding to poisoning", "5:25", "poisoning",
                  "Steps to take if someone has been poisoned, including calling emergency services."),
    
    "cpr": ("How to perform CPR", "6:40", "cpr",
            "Learn how to perform CPR correctly to save a life in an emergency.")
]
