import SwiftUI

// MARK: - Utility Function
func colorFromHex(_ hex: String) -> Color {
    let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    var int: UInt64 = 0
    Scanner(string: hex).scanHexInt64(&int)
    let r, g, b: UInt64
    switch hex.count {
    case 3:
        (r, g, b) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
    case 6:
        (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
    default:
        (r, g, b) = (0, 0, 0)
    }
    return Color(
        .sRGB,
        red: Double(r) / 255,
        green: Double(g) / 255,
        blue: Double(b) / 255,
        opacity: 1.0
    )
}

// MARK: - Models
struct FoodData: Identifiable {
    let id: String
    let address: String
    let foodType: String
    let quantity: String
    let time: String
    let type: String
}

enum DonationStatus: String {
    case pending = "Pending"
    case accepted = "Accepted"
    case received = "Received"
    
    var color: Color {
        switch self {
        case .pending:
            return colorFromHex("FF6347") // Red for Pending
        case .accepted:
            return colorFromHex("FFD700") // Yellow for Accepted
        case .received:
            return colorFromHex("32CD32") // Lime Green for Received
        }
    }
}

// MARK: - ViewModel
class FoodDetailsViewModel: ObservableObject {
    @Published var status: DonationStatus = .pending
    @Published var tpin: String = ""
    @Published var isReceived = false
    @Published var showConfirmDialog = false
    @Published var showReceivedDialog = false
    @Published var copied = false
    @Published var showSuccessMessage = false
    @Published var showCard = true
    
    let foodData = FoodData(
        id: "-OFba4wAAkLUAC_wmqkk",
        address: "Bharuch",
        foodType: "Packed Food",
        quantity: "15",
        time: "14:10",
        type: "Kg"
    )
    
    func generateTpin() {
        tpin = String(format: "%06d", Int.random(in: 100000...999999))
    }
    
    func acceptDonation() {
        status = .accepted
        generateTpin()
    }
    
    func markReceived() {
        status = .received
        isReceived = true
        showSuccessMessage = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.showSuccessMessage = false
            self.showCard = false
        }
    }
    
    func copyTpin() {
        UIPasteboard.general.string = tpin
        copied = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.copied = false
        }
    }
}

// MARK: - Views
struct FoodDetailsView: View {
    @StateObject private var viewModel = FoodDetailsViewModel()
    let cardWidth: CGFloat = 350

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    Text("Active Donations List")
                        .font(.largeTitle.bold())
                        .foregroundColor(colorFromHex("946654"))
                    
                    Text("“Every act of kindness makes the world a better place.”")
                        .font(.subheadline.italic())
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                    
                    // Donation Card
                    if viewModel.showCard {
                        CardView {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Donation Item")
                                    .font(.headline)
                                
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        Image(systemName: "leaf.fill")
                                            .foregroundColor(colorFromHex("946654"))
                                        Text(viewModel.foodData.foodType)
                                    }
                                    HStack {
                                        Text("\(viewModel.foodData.quantity) \(viewModel.foodData.type)")
                                        Spacer()
                                        Text("Time: \(viewModel.foodData.time)")
                                    }
                                    HStack {
                                        Image(systemName: "mappin.circle.fill")
                                            .foregroundColor(colorFromHex("946654"))
                                        Text(viewModel.foodData.address)
                                            .foregroundColor(.gray)
                                    }
                                    HStack {
                                        Text("Status:")
                                            .font(.subheadline.bold())
                                        Text(viewModel.status.rawValue)
                                            .foregroundColor(viewModel.status.color)
                                    }
                                }
                            }
                            .padding()
                        }
                        .frame(width: cardWidth)
                    }
                    
                    // TPIN Card
                    if viewModel.status == .accepted && !viewModel.isReceived && viewModel.showCard {
                        CardView {
                            VStack(spacing: 16) {
                                Text("Donation in Progress")
                                    .font(.headline)
                                    .foregroundColor(viewModel.status.color)
                                
                                HStack {
                                    Text(viewModel.tpin)
                                        .font(.title.bold())
                                        .monospacedDigit()
                                    
                                    Button(action: viewModel.copyTpin) {
                                        Image(systemName: viewModel.copied ? "checkmark.circle.fill" : "doc.on.doc.fill")
                                            .foregroundColor(viewModel.copied ? .green : .gray)
                                    }
                                }
                                
                                Text("Share this TPIN with the donor for verification.")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                            }
                            .padding()
                        }
                        .frame(width: cardWidth)
                    }
                    
                    // Action Buttons
                    if viewModel.showCard {
                        VStack(spacing: 16) {
                            if viewModel.status == .pending {
                                Button("Accept Donation") {
                                    viewModel.showConfirmDialog = true
                                }
                                .buttonStyle(CustomButtonStyle())
                            }
                            if viewModel.status == .accepted && !viewModel.isReceived {
                                Button("Mark as Received") {
                                    viewModel.showReceivedDialog = true
                                }
                                .buttonStyle(CustomButtonStyle(color: viewModel.status.color))
                            }
                        }
                    }
                    
                    // Success Message
                    if viewModel.showSuccessMessage {
                        Text("Donation Received Successfully")
                            .foregroundColor(colorFromHex("32CD32"))
                            .padding()
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
                .padding()
            }
            
        }
        .alert("Confirm Acceptance", isPresented: $viewModel.showConfirmDialog) {
            Button("Cancel", role: .cancel) {}
            Button("Confirm") { viewModel.acceptDonation() }
        }
        .alert("Confirm Receipt", isPresented: $viewModel.showReceivedDialog) {
            Button("Cancel", role: .cancel) {}
            Button("Confirm") { viewModel.markReceived() }
        }
    }
}

// MARK: - Custom Button Style
struct CustomButtonStyle: ButtonStyle {
    var color: Color = colorFromHex("946654")
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

// MARK: - CardView Component
struct CardView<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack {
            content
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 6)
    }
}

// MARK: - Preview
struct ContVentView_Previews: PreviewProvider {
    static var previews: some View {
        FoodDetailsView()
    }
}
