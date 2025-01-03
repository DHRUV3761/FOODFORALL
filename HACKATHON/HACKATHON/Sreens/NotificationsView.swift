
import SwiftUI
import MapKit

//struct CharityHeader: View {
//    let headerHeight: CGFloat
//    
//    var body: some View {
//        VStack(spacing: 0) {
//            HStack {
//                Button(action: {
//                    // Back action
//                }) {
//                    Image(systemName: "chevron.left")
//                        .font(.system(size: 18, weight: .medium))
//                        .foregroundColor(.white)
//                }
//                .padding(.leading)
//                .frame(width: 50, alignment: .leading)
//
//                Text("Charity")
//                    .font(.system(size: 34, weight: .bold))
//                    .foregroundColor(.white)
//                    .frame(maxWidth: .infinity)
//                    .padding(.vertical, 10)
//
//                Color.clear
//                    .frame(width: 50)
//            }
//            .frame(height: headerHeight)
//            .background(Color(red: 0.1, green: 0.1, blue: 0.1))
//            .padding(.vertical, 8)
//        }
//    }
//}

// Tracking status enum
enum TrackingStatus {
    case completed
    case current
    case pending
    
    var color: Color {
        switch self {
        case .completed:
            return .green
        case .current:
            return .blue
        case .pending:
            return .gray
        }
    }
}

// Updated TrackingStep structure
struct TrackingStep: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let status: TrackingStatus
}
struct CharityApp: View {
    @State private var activeTab = "List of NGOs"
    @State private var favorites = Set<Int>()
    
    let notifications = [
        NotificationItem(id: 1, text: "Your donation is being delivered to NGO Food For All", time: "2:45 PM", type: .ongoing),
        NotificationItem(id: 2, text: "Upcoming donation scheduled for NGO Food For All", time: "1:30 PM", type: .upcoming),
        NotificationItem(id: 3, text: "Donation successfully delivered to Hope Foundation", time: "12:15 PM", type: .completed)
    ]
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                Color.clear.frame(height: geometry.safeAreaInsets.top)
                
//                CharityHeader(headerHeight: 50)
                
                VStack {
                    HStack(spacing: 8) {
                        Picker("Select Tab", selection: $activeTab) {
                            Text("List of NGOs").tag("List of NGOs")
                            Text("Notifications").tag("Notifications")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal)
                    }
                    .padding(.vertical, 10) // Add vertical padding for the space above and below
                    .background(Color(red: 0.1, green: 0.1, blue: 0.1))
                    .cornerRadius(10) // Optional: Add corner radius for a smoother appearance
                    .frame(height: 60) // Optional: Controls the height of the segment background
                }
                
                ScrollView {
                    if activeTab == "List of NGOs" {
                        NGOListView(favorites: $favorites)
                    } else {
                        NotificationsView(notifications: notifications)
                    }
                }
            }
            .background(Color(red: 0.1, green: 0.1, blue: 0.1))
            .edgesIgnoringSafeArea(.all)
        }
    }
}

import SwiftUI

// Define a structure to hold each NGO's information (name, address)
struct NGO: Identifiable {
    let id: Int
    let name: String
    let address: String
}

struct NGOListView: View {
    @Binding var favorites: Set<Int>
    
    // List of NGOs to be displayed
    let ngos: [NGO] = [
        NGO(id: 1, name: "FOOD FOR ALL : Waghodia", address: "Taksh Galaxy Mall, Waghodia Bypass NH 8, Madhavpura, Vadodara, Gujarat 390019, India"),
        NGO(id: 2, name: "NGO 2: Sample Name", address: "Sample Address, Sample City, Sample Country"),
        NGO(id: 3, name: "NGO 3: Helping Hands", address: "Helping Hands Street, City Name, Country Name"),
        NGO(id: 4, name: "NGO 4: Green Earth", address: "Green Earth Road, Another City, Another Country"),
        NGO(id: 5, name: "NGO 5: Bright Future", address: "Bright Future Avenue, Yet Another City, Yet Another Country")
    ]
    
    var body: some View {
        VStack(spacing: 16) {
            // Iterate over the NGO list and create a card for each NGO
            ForEach(ngos) { ngo in
                NGOCard(ngoId: ngo.id, isFavorite: favorites.contains(ngo.id), ngoName: ngo.name, ngoAddress: ngo.address)
                    .padding(.horizontal)
            }
        }
        .padding(.vertical)
    }
}

struct NGOCard: View {
    let ngoId: Int
    let isFavorite: Bool
    let ngoName: String  // The name of the NGO
    let ngoAddress: String  // The address of the NGO
    
    @State private var isDonationFormPresented = false  // Track form presentation state
    
    var body: some View {
        VStack(spacing: 16) {
            Text(ngoName)  // Display the NGO's name dynamically
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(red: 0.15, green: 0.15, blue: 0.15))
                .cornerRadius(10)
            
            MapMockupView()
                .frame(height: 200)
                .cornerRadius(10)
            
            VStack(spacing: 12) {
                Button(action: {}) {
                    HStack(alignment: .top) {
                        Image(systemName: "mappin")
                            .foregroundColor(.white)
                        Text(ngoAddress)
                            .foregroundColor(.white)
                            .font(.system(size: 14))
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 0.15, green: 0.15, blue: 0.15))
                    .cornerRadius(10)
                }
                
                Button(action: {}) {
                    HStack {
                        Image(systemName: "heart")
                            .foregroundColor(.white)
                        Text("Tap to add to your favorite NGO")
                            .foregroundColor(.white)
                            .font(.system(size: 14))
                        Spacer()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 0.15, green: 0.15, blue: 0.15))
                    .cornerRadius(10)
                }
                
                Button(action: {
                    self.isDonationFormPresented.toggle()  // Show donation form
                }) {
                    Text("Donate")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.orange)
                        .cornerRadius(40)
                }
                .fullScreenCover(isPresented: $isDonationFormPresented) {
                    DonationFormView(ngoName: ngoName)  // Pass the NGO name to the donation form
                }
            }
        }
        .padding()
        .background(Color(red: 0.12, green: 0.12, blue: 0.12))
        .cornerRadius(25)
    }
}

import SwiftUI

struct DonationFormView: View {
    @Environment(\.dismiss) var dismiss  // Dismiss the full-screen view
    @StateObject private var viewModel = DonationFormViewModel()
    @State private var name = ""
    @State private var amount = ""
    @State private var message = ""
    @State private var showSuccessScreen = false  // Add a state to control success screen visibility
    @State private var showNGOListView = false  // Add a state to control NGOListView visibility
    
    let ngoName: String  // NGO name passed from NGOCard
    
    var body: some View {
        NavigationView {
            ZStack {
                // Main UI
                if showNGOListView {
                    // Show the NGOListView after 5 seconds
                    DashboardView()
                        .transition(.opacity)  // Fade in/out transition
                } else {
                    ScrollView {
                        VStack(spacing: 0) {
                            // Header
                            VStack(alignment: .leading, spacing: 16) {
                                Button(action: { dismiss() }) {
                                    HStack {
                                        Image(systemName: "chevron.left")
                                            .foregroundColor(.orange)
                                        Text("Back")
                                            .foregroundColor(.orange)
                                    }
                                }
                                
                                Text("Donation Details")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color.black)
                            
                            // NGO Title Section
                            VStack(spacing: 4) {
                                Text(ngoName)  // Display the passed NGO name
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.orange)
                                Text("Together We Can Make A Difference")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.black.opacity(0.8))
                            
                            // Form Fields
                            VStack(spacing: 16) {
                                FormTextField(title: "Name", text: $viewModel.name)
                                FormTextField(title: "Email", text: $viewModel.email)
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                                FormTextField(title: "Mobile Number", text: $viewModel.mobileNumber)
                                    .keyboardType(.phonePad)
                                FormTextField(title: "Organization Name", text: $viewModel.organizationName)
                                FormTextField(title: "Item Quantity (e.g., 5 Kg, 3 Bags)", text: $viewModel.itemQuantity)
                                
                                // Item Type Picker
                                Menu {
                                    ForEach(viewModel.itemTypes, id: \.self) { item in
                                        Button(action: { viewModel.selectedItemType = item }) {
                                            Text(item)
                                        }
                                    }
                                } label: {
                                    HStack {
                                        Text(viewModel.selectedItemType.isEmpty ? "Select Item Type" : viewModel.selectedItemType)
                                            .foregroundColor(viewModel.selectedItemType.isEmpty ? .gray : .white)
                                        Spacer()
                                        Image(systemName: "chevron.down")
                                            .foregroundColor(.gray)
                                    }
                                    .padding()
                                    .background(Color(UIColor.systemGray6))
                                    .cornerRadius(8)
                                }
                                
                                // Additional Notes
                                TextEditor(text: $viewModel.additionalNotes)
                                    .frame(height: 100)
                                    .padding(4)
                                    .background(Color(UIColor.systemGray6))
                                    .cornerRadius(8)
                                    .foregroundColor(.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.gray.opacity(0.2))
                                    )
                                
                                // Submit Button
                                Button(action: {
                                    viewModel.submitDonation()
                                    
                                    // Show success screen after donation submission
                                    showSuccessScreen = true
                                    
                                    // After 5 seconds, transition to the NGO list view
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                        showSuccessScreen = false
                                        showNGOListView = true
                                    }
                                }) {
                                    Text("Submit Donation")
                                        .fontWeight(.semibold)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.orange)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                }
                            }
                            .padding()
                        }
                    }
                    .background(Color.black)
                    .navigationBarHidden(true)
                }
                
                // Success Screen - visible when `showSuccessScreen` is true
                if showSuccessScreen {
                    SuccessScreen(message: "Your donation has been registered successfully.")
                        .transition(.opacity)  // Fade in/out transition
                        .zIndex(1)  // Ensure SuccessScreen is above the form
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}
   // Form TextField Component
   struct FormTextField: View {
       let title: String
       @Binding var text: String
       
       var body: some View {
           TextField(title, text: $text)
               .padding()
               .background(Color(UIColor.systemGray6))
               .cornerRadius(8)
               .foregroundColor(.white)
               .overlay(
                   RoundedRectangle(cornerRadius: 8)
                       .stroke(Color.gray.opacity(0.2))
               )
       }
   }

   // ViewModel remains the same
   class DonationFormViewModel: ObservableObject {
       @Published var name = ""
       @Published var email = ""
       @Published var mobileNumber = ""
       @Published var organizationName = ""
       @Published var itemQuantity = ""
       @Published var selectedItemType = ""
       @Published var additionalNotes = ""
       
       let itemTypes = [
           "Clothing",
           "Books",
           "Electronics",
           "Furniture",
           "Medical Supplies",
           "Other"
       ]
       
       func submitDonation() {
           // Handle donation submission
           print("Donation submitted")
       }
   }


struct MapMockupView: View {
    // Example coordinates for Waghodia, Gujarat
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 22.7901, longitude: 73.1702),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    var body: some View {
        ZStack {
            // Background color
            Color(white: 0.15).edgesIgnoringSafeArea(.all)
            
            VStack {
                // MapView from MapKit
                Map(coordinateRegion: $region)
                    .frame(height: 300) // Adjust the map height as needed
                    .cornerRadius(10)
                    .shadow(radius: 5)
                
                // Location pin
                Image(systemName: "mappin.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.orange)
                
                // Location name
                Text("Waghodia, Gujarat")
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(4)
                    .background(Color(red: 0.2, green: 0.2, blue: 0.2))
                    .cornerRadius(4)
            }
        }
    }
}



struct NotificationItem: Identifiable {
    let id: Int
    let text: String
    let time: String
    let type: NotificationType
}

enum NotificationType {
    case upcoming
    case ongoing
    case completed
}

struct NotificationsView: View {
    let notifications: [NotificationItem]
    @State private var expandedNotificationId: Int?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(notifications) { notification in
                    VStack(spacing: 0) {
                        Button(action: {
                            withAnimation {
                                if notification.type == .ongoing {
                                    if expandedNotificationId == notification.id {
                                        expandedNotificationId = nil
                                    } else {
                                        expandedNotificationId = notification.id
                                    }
                                }
                            }
                        }) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(notification.text)
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                                Text(notification.time)
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(red: 0.15, green: 0.15, blue: 0.15))
                            .cornerRadius(notification.id == expandedNotificationId ? 15 : 15)
                        }
                        
                        if notification.id == expandedNotificationId {
                            VStack(alignment: .leading, spacing: 0) {
                                Rectangle()
                                    .fill(Color(red: 0.2, green: 0.2, blue: 0.2))
                                    .frame(height: 1)
                                
                                DeliveryTrackingView()
                                    .padding(.vertical)
                            }
                            .background(Color(red: 0.15, green: 0.15, blue: 0.15))
                            .cornerRadius(15)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
    }
}

struct DeliveryTrackingView: View {
    let steps = [
        TrackingStep(
            title: "Donation Registered",
            description: "Your donation has been registered with Food For All",
            status: .completed
        ),
        TrackingStep(
            title: "Pick-Up Scheduled",
            description: "Pick-up scheduled for December 31, 10:00 AM",
            status: .current
        ),
        TrackingStep(
            title: "In Transit",
            description: "Your donation is on its way to Food For All",
            status: .pending
        ),
        TrackingStep(
            title: "Delivered",
            description: "Your donation was delivered to Food For All successfully",
            status: .pending
        )
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(Array(steps.enumerated()), id: \.element.id) { index, step in
                HStack(alignment: .top, spacing: 12) {
                    // Status dot and vertical line
                    VStack(spacing: 0) {
                        Circle()
                            .fill(step.status.color)
                            .frame(width: 24, height: 24)
                            .overlay(
                                Group {
                                    if step.status == .completed {
                                        Circle()
                                            .fill(Color.white)
                                            .frame(width: 12, height: 12)
                                    }
                                }
                            )
                        
                        if index < steps.count - 1 {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 2, height: 64)
                        }
                    }
                    
                    // Text content
                    VStack(alignment: .leading, spacing: 4) {
                        Text(step.title)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Text(step.description)
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.top, 2)
                }
                .padding(.bottom, index < steps.count - 1 ? 40 : 0)
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CharityApp()
    }
}










import SwiftUI

struct SuccessScreen: View {
    let message: String
    @State private var circleScale: CGFloat = 0
    @State private var circleOpacity: Double = 0
    @State private var checkmarkProgress: CGFloat = 0
    @State private var textOffset: CGFloat = 20
    @State private var textOpacity: Double = 0
    @State private var messageOffset: CGFloat = 20
    @State private var messageOpacity: Double = 0
    
    init(message: String = "Your donation has been registered successfully.") {
        self.message = message
    }
    
    var body: some View {
        VStack {
            // Success Icon Circle
            Circle()
                .fill(Color.green)
                .frame(width: 96, height: 96)
                .overlay(
                    // Custom Checkmark Shape
                    CheckmarkShape()
                        .trim(from: 0, to: checkmarkProgress)
                        .stroke(Color.white, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                )
                .scaleEffect(circleScale)
                .opacity(circleOpacity)
                .padding(.bottom, 24)
                .onAppear {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.7, blendDuration: 0)) {
                        circleScale = 1
                        circleOpacity = 1
                    }
                    
                    withAnimation(.easeInOut(duration: 0.5).delay(0.5)) {
                        checkmarkProgress = 1
                    }
                }
            
            // Thank You Text
            Text("Thank You!")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.black)
                .offset(y: textOffset)
                .opacity(textOpacity)
                .padding(.bottom, 16)
                .onAppear {
                    withAnimation(.easeOut(duration: 0.5).delay(0.7)) {
                        textOffset = 0
                        textOpacity = 1
                    }
                }
            
            // Success Message
            Text(message)
                .font(.system(size: 18))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .offset(y: messageOffset)
                .opacity(messageOpacity)
                .onAppear {
                    withAnimation(.easeOut(duration: 0.5).delay(0.9)) {
                        messageOffset = 0
                        messageOpacity = 1
                    }
                }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}

// Custom Shape for Checkmark
struct CheckmarkShape: Shape {
    func path(in rect: CGRect) -> Path {
        let width = rect.width
        let height = rect.height
        
        var path = Path()
        path.move(to: CGPoint(x: width * 0.8, y: height * 0.25))
        path.addLine(to: CGPoint(x: width * 0.375, y: height * 0.7))
        path.addLine(to: CGPoint(x: width * 0.17, y: height * 0.5))
        
        return path
    }
}

// Preview Provider
struct SuccessScreen_Previews: PreviewProvider {
    static var previews: some View {
        SuccessScreen()
    }
}
