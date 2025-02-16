import SwiftUI

struct ArticlesView: View {
    var body: some View  {
        ScrollView {
        VStack(alignment: .leading) {
            
            Text("Articles")
                .font(.title)
                .foregroundColor(.red)
                .fontWeight(.bold)
                .padding(.horizontal, 24)
                .padding(.vertical, 20)
            
                .frame(maxWidth: .infinity, alignment: .center)
            
            Text("Most Popular")
                .font(.title3)
                .fontWeight(.bold)
                .padding(.horizontal, 24)
            
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    PopularArticleCard(title: "First Aid Instructions",imageName: "A1")
                    PopularArticleCard(title: "Recognizing the Signs of a Heart Attack",imageName: "A2")
                    PopularArticleCard(title: "Signs of Dehydration",imageName: "A3")                    
                }
                .padding(.horizontal, 24)
            }
            
            
            Text("Latest Articles")
                .font(.title3)
                .fontWeight(.bold)
                .padding(.horizontal, 24)
                .padding(.top, 16)
            
            VStack {
                ArticleRow(title: "Understanding Stroke: Symptoms & Treatment", date: "Feb 06, 2025")
                ArticleRow(title: "Allergic Reactions: What You Need to Know", date: "Jan 28, 2025")
                ArticleRow(title: "Medication Mistakes & How to Avoid Them", date: "Jan 15, 2025")
                ArticleRow(title: "Caring for Someone with the Flu", date: "Jan 08, 2025")
                ArticleRow(title: "Checking for Signs of Dehydration", date: "Jan 08, 2025")
            }.padding(.horizontal, 24)


            
            Spacer()
            
            // Bottom Tab Bar
//            HStack {
//                TabBarItem(icon: "house.fill", label: "Home")         // 🏠 Home
//                TabBarItem(icon: "map.fill", label: "Maps")          // 🗺️ Maps
//                TabBarItem(icon: "phone.fill", label: "Phone")       // 📞 Phone
//                TabBarItem(icon: "bubble.left.fill", label: "Chat")  // 💬 Chat
//            }
//            .padding()
//            .background(Color(.white))
        }
        .background(Color(.systemGray6))
        
    }
}
}

struct PopularArticleCard: View {
    var title: String
    var imageName: String 

    var body: some View {
        ZStack(alignment: .bottom) { 
            Image(imageName) 
                .resizable()
                .scaledToFill() 
                .frame(width: 150, height: 150)
                .clipped() 
                .overlay(
                    Color.black.opacity(0.4) 
                        .cornerRadius(12) 
                )
                .cornerRadius(12) 
            Text(title)
                .font(.headline)
                .fontWeight(.heavy)
                .frame(width: 120) 
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .truncationMode(.tail)
                .lineLimit(3)
                .padding(.bottom, 8) 
        }
    }
}


struct ArticleRow: View {
    var title: String
    var date: String

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "plus") 
                .foregroundColor(.red) 
                .font(.system(size: 28)) 
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)
                Text(date)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding() 
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white) 
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2) 
        )
    }
}




struct TabBarItem: View {
    var icon: String
    var label: String 

    var body: some View {
        VStack(spacing: 4) { 
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.black)
            Text(label) 
                .font(.caption)
                .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity) 
    }
}

struct ArticlesView_Previews: PreviewProvider {
    static var previews: some View {
        ArticlesView()
    }
}
