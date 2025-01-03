//import SwiftUI
//
//struct DeliveryDashboard: View {
//    @State private var isAvailable = true
//    @State private var showAlert = false
//    @State private var selectedDelivery: DeliveryRequest? = nil
//    @State private var newRequests: [DeliveryRequest] = [
//        DeliveryRequest(id: 1, donor: "John's Bakery", destination: "Hope Shelter", distance: 3.2, type: .urgent, mealCount: 20),
//        DeliveryRequest(id: 2, donor: "Fresh Market", destination: "Community Center", distance: 2.1, type: .scheduled, mealCount: 15)
//    ]
//    
//    private let colors = CustomColors()
//    let todayStats = Stats(mealsDelivered: 15, impactScore: 500)
//    
//    var body: some View {
//        ScrollView {
//            VStack(spacing: 32) {
//                headerSection
//                    .padding(.top, 16)
//                
//                if showAlert {
//                    availabilityAlert
//                        .padding(.horizontal)
//                }
//                
//                statsSection
//                    .padding(.horizontal)
//                
//                newRequestsSection
//                    .padding(.horizontal)
//            }
//            .padding(.bottom, 32)
//        }
//        .background(colors.darkGray)
//    }
//    
//    private var headerSection: some View {
//        HStack {
//            HStack(spacing: 20) {
//                ZStack {
//                    Circle()
//                        .fill(colors.beige.opacity(0.2))
//                        .frame(width: 72, height: 72)
//                    
//                    Image(systemName: "camera")
//                        .foregroundColor(colors.beige)
//                        .font(.system(size: 24))
//                }
//                
//                VStack(alignment: .leading, spacing: 8) {
//                    Text("Volunteer #12345")
//                        .font(.title2)
//                        .fontWeight(.bold)
//                        .foregroundColor(colors.softWhite)
//                    
//                    HStack(spacing: 12) {
//                        Text(isAvailable ? "Available" : "Unavailable")
//                            .font(.subheadline)
//                            .padding(.horizontal, 12)
//                            .padding(.vertical, 6)
//                            .background(isAvailable ? colors.emeraldGreen.opacity(0.2) : Color.gray.opacity(0.2))
//                            .foregroundColor(isAvailable ? colors.emeraldGreen : .gray)
//                            .clipShape(Capsule())
//                    }
//                }
//            }
//            
//            Spacer()
//            
//            Toggle("", isOn: $isAvailable)
//                .labelsHidden()
//                .tint(colors.emeraldGreen)
//        }
//        .padding(24)
//        .background(colors.darkGray.opacity(0.8))
//        .cornerRadius(16)
//        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
//        .padding(.horizontal)
//    }
//    
//    private var availabilityAlert: some View {
//        VStack(alignment: .leading, spacing: 16) {
//            Text("Are you sure you want to turn off availability? Fewer hands mean less help for the community.")
//                .foregroundColor(colors.brightOrange)
//                .fixedSize(horizontal: false, vertical: true)
//            
//            HStack(spacing: 16) {
//                Button("Confirm") {
//                    isAvailable = false
//                    showAlert = false
//                }
//                .foregroundColor(colors.softWhite)
//                .frame(maxWidth: .infinity)
//                .padding(.vertical, 12)
//                .background(colors.brightOrange)
//                .cornerRadius(12)
//                
//                Button("Cancel") {
//                    showAlert = false
//                }
//                .foregroundColor(colors.darkGray)
//                .frame(maxWidth: .infinity)
//                .padding(.vertical, 12)
//                .background(colors.beige)
//                .cornerRadius(12)
//            }
//        }
//        .padding(24)
//        .background(colors.brightOrange.opacity(0.1))
//        .cornerRadius(16)
//    }
//    
//    private var statsSection: some View {
//        VStack(alignment: .leading, spacing: 20) {
//            Text("Today's Contributions")
//                .font(.title2)
//                .fontWeight(.bold)
//                .foregroundColor(colors.softWhite)
//                .padding(.horizontal, 24)
//            
//            HStack(spacing: 20) {
//                StatCard(
//                    icon: "person.2.fill",
//                    iconColor: colors.emeraldGreen,
//                    title: "Meals Delivered",
//                    value: "\(todayStats.mealsDelivered)",
//                    backgroundColor: colors.darkGray
//                )
//                .frame(width: 180)
//                
//                StatCard(
//                    icon: "award",
//                    iconColor: colors.brightOrange,
//                    title: "Impact Score",
//                    value: "\(todayStats.impactScore)",
//                    backgroundColor: colors.darkGray
//                )
//                .frame(width: 180)
//            }
//            .padding(.horizontal, 24)
//            .padding(.bottom, 24)
//        }
//        .background(colors.darkGray.opacity(0.8))
//        .cornerRadius(16)
//    }
//    
//    private var newRequestsSection: some View {
//        VStack(alignment: .leading, spacing: 24) {
//            Text("New Requests")
//                .font(.title2)
//                .fontWeight(.bold)
//                .foregroundColor(colors.softWhite)
//                .padding(.horizontal, 24)
//            
//            VStack(spacing: 20) {
//                ForEach(newRequests) { request in
//                    RequestCard(request: request, colors: colors) {
//                        acceptRequest(request)
//                    } onDecline: {
//                        declineRequest(request)
//                    }
//                    .frame(width: 350)
//                }
//            }
//            .padding(.horizontal, 24)
//            .padding(.bottom, 24)
//        }
//        .background(colors.darkGray.opacity(0.8))
//        .cornerRadius(16)
//    }
//    
//    private func acceptRequest(_ request: DeliveryRequest) {
//        // Handle the accept action here
//        if let index = newRequests.firstIndex(where: { $0.id == request.id }) {
//            newRequests.remove(at: index)
//            print("Request Accepted: \(request.donor) - \(request.destination)")
//        }
//    }
//    
//    private func declineRequest(_ request: DeliveryRequest) {
//        // Handle the decline action here
//        if let index = newRequests.firstIndex(where: { $0.id == request.id }) {
//            newRequests.remove(at: index)
//            print("Request Declined: \(request.donor) - \(request.destination)")
//        }
//    }
//}
//
//struct StatCard: View {
//    let icon: String
//    let iconColor: Color
//    let title: String
//    let value: String
//    let backgroundColor: Color
//    
//    var body: some View {
//        HStack(spacing: 12) {
//            Image(systemName: icon)
//                .font(.system(size: 20))
//                .foregroundColor(iconColor)
//                .frame(width: 40, height: 40)
//                .background(iconColor.opacity(0.2))
//                .cornerRadius(10)
//            
//            VStack(alignment: .leading, spacing: 4) {
//                Text(title)
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//                Text(value)
//                    .font(.title3)
//                    .fontWeight(.bold)
//                    .foregroundColor(CustomColors().softWhite)
//            }
//        }
//        .padding(16)
//        .background(backgroundColor)
//        .cornerRadius(16)
//        .overlay(
//            RoundedRectangle(cornerRadius: 16)
//                .stroke(Color.gray.opacity(0.1))
//        )
//    }
//}
//
//struct RequestCard: View {
//    let request: DeliveryRequest
//    let colors: CustomColors
//    let onAccept: () -> Void
//    let onDecline: () -> Void
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 20) {
//            HStack {
//                VStack(alignment: .leading, spacing: 8) {
//                    Text(request.donor)
//                        .font(.title3)
//                        .fontWeight(.semibold)
//                        .foregroundColor(colors.softWhite)
//                    HStack(spacing: 6) {
//                        Image(systemName: "mappin")
//                        Text("\(request.destination) • \(String(format: "%.1f", request.distance)) km")
//                    }
//                    .font(.subheadline)
//                    .foregroundColor(colors.beige)
//                }
//                
//                Spacer()
//                
//                Text(request.type.rawValue)
//                    .font(.subheadline)
//                    .padding(.horizontal, 12)
//                    .padding(.vertical, 6)
//                    .background(request.type == .urgent ? colors.brightOrange.opacity(0.2) : colors.skyBlue.opacity(0.2))
//                    .foregroundColor(request.type == .urgent ? colors.brightOrange : colors.skyBlue)
//                    .cornerRadius(12)
//            }
//            
//            Text("Meals to deliver: \(request.mealCount)")
//                .font(.subheadline)
//                .foregroundColor(colors.beige)
//            
//            HStack(spacing: 16) {
//                Button(action: onAccept) {
//                    Text("Accept")
//                        .fontWeight(.semibold)
//                        .frame(maxWidth: .infinity)
//                        .padding(.vertical, 12)
//                        .background(colors.emeraldGreen)
//                        .foregroundColor(colors.softWhite)
//                        .cornerRadius(12)
//                }
//                
//                Button(action: onDecline) {
//                    Text("Decline")
//                        .fontWeight(.semibold)
//                        .frame(maxWidth: .infinity)
//                        .padding(.vertical, 12)
//                        .background(colors.beige)
//                        .foregroundColor(colors.darkGray)
//                        .cornerRadius(12)
//                }
//            }
//        }
//        .padding(24)
//        .background(colors.darkGray)
//        .cornerRadius(16)
//        .overlay(
//            RoundedRectangle(cornerRadius: 16)
//                .stroke(Color.gray.opacity(0.1))
//        )
//    }
//}
//
//struct CustomColors {
//    let darkGray = Color(red: 18/255, green: 18/255, blue: 18/255)
//    let brightOrange = Color(red: 245/255, green: 158/255, blue: 11/255)
//    let beige = Color(red: 180/255, green: 166/255, blue: 132/255)
//    let skyBlue = Color(red: 59/255, green: 130/255, blue: 246/255)
//    let emeraldGreen = Color(red: 34/255, green: 197/255, blue: 94/255)
//    let softWhite = Color(red: 245/255, green: 245/255, blue: 245/255)
//}
//
//struct DeliveryRequest: Identifiable {
//    let id: Int
//    let donor: String
//    let destination: String
//    let distance: Double
//    let type: DeliveryType
//    let mealCount: Int
//}
//
//enum DeliveryType: String {
//    case urgent = "Urgent"
//    case scheduled = "Scheduled"
//}
//
//struct Stats {
//    let mealsDelivered: Int
//    let impactScore: Int
//}
//
//struct DeliveryDashboard_Previews: PreviewProvider {
//    static var previews: some View {
//        DeliveryDashboard()
//    }
//}

//
//import SwiftUI
//
//// DonationFlowModel to manage states
//class DonationFlowModel: ObservableObject {
//    @Published var donationRequested = false
//    @Published var donationApproved = false
//    @Published var deliveryBoyAssigned = false
//    @Published var deliveryInProgress = false
//    @Published var deliveryCompleted = false
//    @Published var tpIn: String = "" // TPIN generated for verification
//
//    func generateTPIN() -> String {
//        return String(Int.random(in: 1000...9999)) // Simple TPIN generation logic
//    }
//}
//
//struct ContentView: View {
//    @StateObject var model = DonationFlowModel()
//    
//    // States to track button visibility
//    @State private var donorVerified = false
//    @State private var deliveryBoyVerified = false
//    
//    var body: some View {
//        VStack {
//            // Donation Request Button (Donor)
//            if !model.donationRequested {
//                Button("Request Donation") {
//                    model.donationRequested.toggle()
//                    model.tpIn = model.generateTPIN() // Generate TPIN for the request
//                }
//                .padding()
//                .frame(maxWidth: .infinity, alignment: .center)
//            }
//            
//            // NGO Approve Donation Button
//            if model.donationRequested && !model.donationApproved {
//                Button("Approve Donation (NGO)") {
//                    model.donationApproved.toggle()
//                }
//                .padding()
//                .frame(maxWidth: .infinity, alignment: .center)
//            }
//            
//            // Assign Delivery Boy Button (NGO)
//            if model.donationApproved && !model.deliveryBoyAssigned {
//                Button("Assign Delivery Boy") {
//                    model.deliveryBoyAssigned.toggle()
//                }
//                .padding()
//                .frame(maxWidth: .infinity, alignment: .center)
//            }
//            
//            // Swipe to Accept Delivery Button (Delivery Boy)
//            if model.deliveryBoyAssigned && !model.deliveryInProgress {
//                Button("Swipe to Accept Delivery (Delivery Boy)") {
//                    model.deliveryInProgress.toggle()
//                    model.tpIn = model.generateTPIN() // New TPIN for the delivery
//                }
//                .padding()
//                .frame(maxWidth: .infinity, alignment: .center)
//            }
//            
//            // Donor and Delivery Boy TPIN Verification
//            if model.deliveryInProgress && !model.deliveryCompleted {
//                VStack {
//                    if !donorVerified {
//                        Button("Verify TPIN (Donor)") {
//                            donorVerified = true
//                            print("Donor Verified TPIN: \(model.tpIn)")
//                        }
//                        .padding()
//                        .frame(maxWidth: .infinity, alignment: .center)
//                    }
//
//                    if !deliveryBoyVerified {
//                        Button("Verify TPIN (Delivery Boy)") {
//                            deliveryBoyVerified = true
//                            print("Delivery Boy Verified TPIN: \(model.tpIn)")
//                        }
//                        .padding()
//                        .frame(maxWidth: .infinity, alignment: .center)
//                    }
//                    
//                    // Completion of Delivery
//                    if donorVerified && deliveryBoyVerified {
//                        Button("Complete Delivery") {
//                            model.deliveryCompleted = true
//                        }
//                        .padding()
//                        .frame(maxWidth: .infinity, alignment: .center)
//                    }
//                }
//            }
//            
//            // Display Delivery Completion
//            if model.deliveryCompleted {
//                Text("Delivery Completed!")
//                    .font(.headline)
//                    .foregroundColor(.green)
//                    .padding()
//            }
//            
//            // Information about the TPIN and its verification
//            if model.donationRequested {
//                Text("TPIN for donation request: \(model.tpIn)")
//                    .padding()
//                    .frame(maxWidth: .infinity, alignment: .center)
//            }
//            
//            Spacer()
//        }
//        .padding()
//    }
//}
//
//struct CoSntentView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            ContentView()
//                .previewLayout(.sizeThatFits)
//                .padding()
//                .previewDisplayName("Donor View")
//
//            ContentView()
//                .previewLayout(.sizeThatFits)
//                .padding()
//                .previewDisplayName("NGO View")
//
//            ContentView()
//                .previewLayout(.sizeThatFits)
//                .padding()
//                .previewDisplayName("Delivery Boy View")
//        }
//    }
//}







//
//
//
//
//
//import SwiftUI
//
//// DonationFlowModel to manage states
//class DonationFlowModel: ObservableObject {
//    @Published var donationRequested = false
//    @Published var donationApproved = false
//    @Published var deliveryBoyAssigned = false
//    @Published var deliveryInProgress = false
//    @Published var deliveryCompleted = false
//    @Published var donorTPIN: String = "" // Donor TPIN for donation request
//    @Published var ngoTPIN: String = "" // NGO TPIN for verification during delivery
//    @Published var notificationMessage: String? = nil // For notifying NGO
//    
//    func generateTPIN() -> String {
//        return String(Int.random(in: 1000...9999)) // Simple TPIN generation logic
//    }
//    
//    func requestDonation() {
//        donationRequested = true
//        donorTPIN = generateTPIN() // Generate TPIN for the donor request
//        notificationMessage = "New donation request from donor with TPIN: \(donorTPIN)"
//    }
//    
//    func approveDonation() {
//        donationApproved = true
//        ngoTPIN = generateTPIN() // Generate NGO TPIN after approval
//    }
//    
//    func assignDeliveryBoy() {
//        deliveryBoyAssigned = true
//    }
//    
//    func startDelivery() {
//        deliveryInProgress = true
//        ngoTPIN = generateTPIN() // Generate new TPIN for the delivery verification
//    }
//    
//    func completeDelivery() {
//        deliveryCompleted = true
//    }
//}
//
//struct ContentView: View {
//    @StateObject var model = DonationFlowModel()
//    @State private var donorVerified = false
//    @State private var deliveryBoyVerified = false
//    
//    var body: some View {
//        NavigationView {
//            VStack {
//                // Donor Screen
//                if !model.donationRequested {
//                    Button("Request Donation") {
//                        model.requestDonation()
//                    }
//                    .padding()
//                    .frame(maxWidth: .infinity, alignment: .center)
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//                }
//                
//                // Donor TPIN Display
//                if model.donationRequested {
//                    Text("TPIN for donation request: \(model.donorTPIN)")
//                        .padding()
//                        .frame(maxWidth: .infinity, alignment: .center)
//                }
//                
//                Spacer()
//                
//                NavigationLink(destination: NGOScreen(model: model)) {
//                    Text("Go to NGO Screen")
//                        .foregroundColor(.blue)
//                }
//                .padding()
//            }
//            .navigationBarTitle("Donor Screen", displayMode: .inline)
//            .padding()
//        }
//    }
//}
//
//struct NGOScreen: View {
//    @ObservedObject var model: DonationFlowModel
//    
//    var body: some View {
//        VStack {
//            // Display notification when a donation request is received
//            if let notificationMessage = model.notificationMessage {
//                Text(notificationMessage)
//                    .padding()
//                    .frame(maxWidth: .infinity, alignment: .center)
//                    .background(Color.yellow)
//                    .cornerRadius(10)
//                    .foregroundColor(.black)
//            }
//            
//            // NGO Approve Donation Button
//            if model.donationRequested && !model.donationApproved {
//                Button("Approve Donation") {
//                    model.approveDonation()
//                }
//                .padding()
//                .frame(maxWidth: .infinity, alignment: .center)
//                .background(Color.green)
//                .foregroundColor(.white)
//                .cornerRadius(10)
//            }
//            
//            // Assign Delivery Boy Button (NGO)
//            if model.donationApproved && !model.deliveryBoyAssigned {
//                Button("Assign Delivery Boy") {
//                    model.assignDeliveryBoy()
//                }
//                .padding()
//                .frame(maxWidth: .infinity, alignment: .center)
//                .background(Color.orange)
//                .foregroundColor(.white)
//                .cornerRadius(10)
//            }
//            
//            Spacer()
//            
//            NavigationLink(destination: DeliveryBoyScreen(model: model)) {
//                Text("Go to Delivery Boy Screen")
//                    .foregroundColor(.blue)
//            }
//            .padding()
//        }
//        .navigationBarTitle("NGO Screen", displayMode: .inline)
//        .padding()
//    }
//}
//
//struct DeliveryBoyScreen: View {
//    @ObservedObject var model: DonationFlowModel
//    @State private var donorVerified = false
//    @State private var deliveryBoyVerified = false
//    
//    var body: some View {
//        VStack {
//            // Swipe to Accept Delivery Button (Delivery Boy)
//            if model.deliveryBoyAssigned && !model.deliveryInProgress {
//                Button("Swipe to Accept Delivery (Delivery Boy)") {
//                    model.startDelivery()
//                    donorVerified = false
//                    deliveryBoyVerified = false
//                }
//                .padding()
//                .frame(maxWidth: .infinity, alignment: .center)
//                .background(Color.purple)
//                .foregroundColor(.white)
//                .cornerRadius(10)
//            }
//            
//            // Donor and Delivery Boy TPIN Verification
//            if model.deliveryInProgress && !model.deliveryCompleted {
//                VStack {
//                    if !donorVerified {
//                        Button("Verify TPIN (Donor)") {
//                            donorVerified = true
//                        }
//                        .padding()
//                        .frame(maxWidth: .infinity, alignment: .center)
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                    }
//
//                    if !deliveryBoyVerified {
//                        Button("Verify TPIN (Delivery Boy)") {
//                            deliveryBoyVerified = true
//                        }
//                        .padding()
//                        .frame(maxWidth: .infinity, alignment: .center)
//                        .background(Color.green)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                    }
//                    
//                    // Completion of Delivery
//                    if donorVerified && deliveryBoyVerified {
//                        Button("Complete Delivery") {
//                            model.completeDelivery()
//                        }
//                        .padding()
//                        .frame(maxWidth: .infinity, alignment: .center)
//                        .background(Color.red)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                    }
//                }
//            }
//            
//            // Display Delivery Completion
//            if model.deliveryCompleted {
//                Text("Delivery Completed!")
//                    .font(.headline)
//                    .foregroundColor(.green)
//                    .padding()
//            }
//            
//            Spacer()
//        }
//        .navigationBarTitle("Delivery Boy Screen", displayMode: .inline)
//        .padding()
//    }
//}
//
//struct CoontentView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            ContentView()
//                .previewLayout(.sizeThatFits)
//                .padding()
//                .previewDisplayName("Donor View")
//            NGOScreen(model: DonationFlowModel())
//                .previewLayout(.sizeThatFits)
//                .padding()
//                .previewDisplayName("NGO View")
//            DeliveryBoyScreen(model: DonationFlowModel())
//                .previewLayout(.sizeThatFits)
//                .padding()
//                .previewDisplayName("Delivery Boy View")
//        }
//    }
//}

import SwiftUI

// DonationFlowModel to manage states
class DonationFlowModel: ObservableObject {
    @Published var donationRequested = false
    @Published var donationApproved = false
    @Published var deliveryBoyAssigned = false
    @Published var deliveryInProgress = false
    @Published var deliveryCompleted = false
    @Published var donorTPIN: String = "" // Donor TPIN for donation request
    @Published var ngoTPIN: String = "" // NGO TPIN for delivery verification
    @Published var deliveryBoyDonorTPIN: String = "" // Delivery Boy TPIN for donor verification
    @Published var deliveryBoyNGOTPIN: String = "" // Delivery Boy TPIN for NGO verification
    @Published var notificationMessage: String? = nil // For notifying NGO
    
    func generateTPIN() -> String {
        return String(Int.random(in: 1000...9999)) // Simple TPIN generation logic
    }
    
    func requestDonation() {
        donationRequested = true
        donorTPIN = generateTPIN() // Generate TPIN for the donor request
        notificationMessage = "New donation request from donor with TPIN: \(donorTPIN)"
    }
    
    func approveDonation() {
        donationApproved = true
        ngoTPIN = generateTPIN() // Generate NGO TPIN after approval for delivery
        deliveryBoyDonorTPIN = generateTPIN() // Delivery Boy TPIN for verifying the donor
        deliveryBoyNGOTPIN = generateTPIN() // Delivery Boy TPIN for verifying the NGO
        notificationMessage = "Donation approved. New TPIN generated for verification."
    }
    
    func assignDeliveryBoy() {
        deliveryBoyAssigned = true
    }
    
    func startDelivery() {
        deliveryInProgress = true
    }
    
    func completeDelivery() {
        deliveryCompleted = true
    }
}

// Donor Screen
struct ContentView: View {
    @StateObject var model = DonationFlowModel()
    
    var body: some View {
        NavigationView {
            VStack {
                // Donor Screen
                if !model.donationRequested {
                    Button("Request Donation") {
                        model.requestDonation()
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                
                // Donor TPIN Display
                if model.donationRequested {
                    Text("TPIN for donation request: \(model.donorTPIN)")
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                
                Spacer()
                
                NavigationLink(destination: NGOScreen(model: model)) {
                    Text("Go to NGO Screen")
                        .foregroundColor(.blue)
                }
                .padding()
            }
            .navigationBarTitle("Donor Screen", displayMode: .inline)
            .padding()
        }
    }
}

// NGO Screen
struct NGOScreen: View {
    @ObservedObject var model: DonationFlowModel
    
    var body: some View {
        VStack {
            // Display notification when a donation request is received
            if let notificationMessage = model.notificationMessage {
                Text(notificationMessage)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(Color.yellow)
                    .cornerRadius(10)
                    .foregroundColor(.black)
            }
            
            // NGO Approve Donation Button
            if model.donationRequested && !model.donationApproved {
                Button("Approve Donation") {
                    model.approveDonation()
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .center)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            
            // Assign Delivery Boy Button (NGO)
            if model.donationApproved && !model.deliveryBoyAssigned {
                Button("Assign Delivery Boy") {
                    model.assignDeliveryBoy()
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .center)
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            
            Spacer()
            
            NavigationLink(destination: DeliveryBoyScreen(model: model)) {
                Text("Go to Delivery Boy Screen")
                    .foregroundColor(.blue)
            }
            .padding()
        }
        .navigationBarTitle("NGO Screen", displayMode: .inline)
        .padding()
    }
}

// Delivery Boy Screen
struct DeliveryBoyScreen: View {
    @ObservedObject var model: DonationFlowModel
    @State private var donorVerified = false
    @State private var deliveryBoyVerified = false
    
    var body: some View {
        VStack {
            // Swipe to Accept Delivery Button (Delivery Boy)
            if model.deliveryBoyAssigned && !model.deliveryInProgress {
                Button("Swipe to Accept Delivery (Delivery Boy)") {
                    model.startDelivery()
                    donorVerified = false
                    deliveryBoyVerified = false
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .center)
                .background(Color.purple)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            
            // Donor and Delivery Boy TPIN Verification
            if model.deliveryInProgress && !model.deliveryCompleted {
                VStack {
                    // TPIN Verification for Donor
                    if !donorVerified {
                        Text("Donor TPIN: \(model.donorTPIN)")
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .center)
                        Button("Verify TPIN (Donor)") {
                            donorVerified = true
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }

                    // TPIN Verification for Delivery Boy (NGO TPIN)
                    if !deliveryBoyVerified {
                        Text("NGO TPIN: \(model.ngoTPIN)")
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .center)
                        Button("Verify TPIN (NGO)") {
                            deliveryBoyVerified = true
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    
                    // Completion of Delivery
                    if donorVerified && deliveryBoyVerified {
                        Button("Complete Delivery") {
                            model.completeDelivery()
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
            }
            
            // Display Delivery Completion
            if model.deliveryCompleted {
                Text("Delivery Completed!")
                    .font(.headline)
                    .foregroundColor(.green)
                    .padding()
            }
            
            Spacer()
        }
        .navigationBarTitle("Delivery Boy Screen", displayMode: .inline)
        .padding()
    }
}

// App Entry Point

// Previews
struct CoontentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct NGOScreen_Previews: PreviewProvider {
    static var previews: some View {
        NGOScreen(model: DonationFlowModel())
    }
}

struct DeliveryBoyScreen_Previews: PreviewProvider {
    static var previews: some View {
        DeliveryBoyScreen(model: DonationFlowModel())
    }
}
