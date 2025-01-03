import SwiftUI
import MapKit

// MARK: - Color Constants
/// Defines custom color constants used throughout the app.
struct Colors {
    static let primaryBackground = Color.black
    static let textColor = Color.white
    static let grayText = Color.gray
    static let orangeButton = Color.orange
    static let brownButton = Color.brown
    static let pinkImpact = Color.pink
    static let blueImpact = Color.blue
    static let greenImpact = Color.green
}
struct DashboardView: View {
    @State private var selectedTab = 0
    @State private var isLoggedIn = true // Set to true to show the dashboard initially
    @State private var navigateToAuth = false // Tracks navigation to AuthView

    var body: some View {
        NavigationView {
            VStack(spacing: 0) { // Ensure no spacing between main content and tab bar
                // MARK: - Content Section
                if isLoggedIn {
                    ZStack {
                        if selectedTab == 0 {
                            HoomeScreen() // Home tab content
                        } else if selectedTab == 1 {
                            PhotoGridPortfolio() // Discover tab content
                        } else if selectedTab == 2 {
                            DoonationForm() // Donation form tab content
                        } else if selectedTab == 3 {
                            ImpactScreen() // Impact stats tab content
                        } else {
                            ProfileScreen(onLogout: performLogout) // Profile tab content
                        }
                    }

                    // MARK: - Bottom Navigation Bar
                    HStack {
                        Spacer()
                        VStack {
                            Image(systemName: "house.fill")
                                .font(.system(size: 24)) // Icon size
                                .foregroundColor(selectedTab == 0 ? Colors.greenImpact : Colors.grayText)
                            Text("Home")
                                .font(.caption2)
                                .foregroundColor(selectedTab == 0 ? Colors.greenImpact : Colors.grayText)
                        }
                        .onTapGesture {
                            selectedTab = 0 // Switch to Home tab
                        }
                        Spacer()

                        VStack {
                            Image(systemName: "photo.stack.fill")
                                .font(.system(size: 24))
                                .foregroundColor(selectedTab == 1 ? Colors.greenImpact : Colors.grayText)
                            Text("Photos")
                                .font(.caption2)
                                .foregroundColor(selectedTab == 1 ? Colors.greenImpact : Colors.grayText)
                        }
                        .onTapGesture {
                            selectedTab = 1 // Switch to Photo tab
                        }
                        Spacer()

                        VStack {
                            Image(systemName: "heart.fill")
                                .font(.system(size: 24))
                                .foregroundColor(selectedTab == 2 ? Colors.greenImpact : Colors.grayText)
                            Text("Donate")
                                .font(.caption2)
                                .foregroundColor(selectedTab == 2 ? Colors.greenImpact : Colors.grayText)
                        }
                        .onTapGesture {
                            selectedTab = 2 // Switch to Donate tab
                        }
                        Spacer()

                        VStack {
                            Image(systemName: "chart.bar.fill")
                                .font(.system(size: 24))
                                .foregroundColor(selectedTab == 3 ? Colors.greenImpact : Colors.grayText)
                            Text("Impact")
                                .font(.caption2)
                                .foregroundColor(selectedTab == 3 ? Colors.greenImpact : Colors.grayText)
                        }
                        .onTapGesture {
                            selectedTab = 3 // Switch to Impact tab
                        }
                        Spacer()

                        VStack {
                            Image(systemName: "person.fill")
                                .font(.system(size: 24))
                                .foregroundColor(selectedTab == 4 ? Colors.greenImpact : Colors.grayText)
                            Text("Profile")
                                .font(.caption2)
                                .foregroundColor(selectedTab == 4 ? Colors.greenImpact : Colors.grayText)
                        }
                        .onTapGesture {
                            selectedTab = 4 // Switch to Profile tab
                        }
                        Spacer()
                    }
                    .padding(.vertical, 8) // Adds padding to the tab bar
                    .background(Colors.primaryBackground) // Tab bar background color
                    .edgesIgnoringSafeArea(.bottom) // Extends tab bar into the safe area
                    .shadow(color: Colors.grayText.opacity(0.2), radius: 5, x: 0, y: -2) // Adds a shadow to the tab bar
                } else {
                    // This block won't appear since we navigate to AuthView on logout
                    EmptyView()
                }

                // Navigation to AuthView
                NavigationLink(
                    destination: AuthView(), // The AuthView screen
                    isActive: $navigateToAuth // Binding to trigger navigation
                ) {
                    EmptyView() // No visual component for the link
                }
            }
            .navigationBarTitleDisplayMode(.inline) // Ensures inline display for navigation bar title
        }
    }

    private func performLogout() {
        // Trigger navigation to AuthView on logout
        print("User has logged out.")
        isLoggedIn = false // Update the login state
        navigateToAuth = true // Navigate to AuthView
    }
}



import SwiftUI
import MapKit
import SwiftUI
import MapKit

struct DoonationForm: View {
    // Enum for Donation Types (Food)
    enum DonationType: String, CaseIterable {
        case food = "Food"
    }
    
    // Enum for Food Types (Cooked, Packed, Groceries)
    enum FoodType: String, CaseIterable {
        case cooked = "Cooked Food"
        case packed = "Packed Food"
        case groceries = "Groceries"
    }
    
    // State variables to manage the form's state
    @State private var selectedDonationType: DonationType = .food
    @State private var selectedFoodType: FoodType = .packed
    @State private var quantity: String = ""
    @State private var selectedUnit: String = "Kg"
    @State private var pickupAddress: String = ""
    @State private var pickupDate: Date = Date()
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    // Custom Colors for the app's design
    private let backgroundColor = Color.black
    private let cardBackgroundColor = Color(hex: "1C1C1E")
    private let accentOrange = Color(hex: "FFA500")
    private let accentOrangeHover = Color(hex: "FF9000")
    private let borderColor = Color(hex: "1A1A1A")
    private let inputBackgroundColor = Color.black
    
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                VStack(spacing: 24) {
                    Spacer().frame(height: 60) // Space for fixed title
                    
                    // Donation Type Selector (Food)
                    HStack(spacing: 16) {
                        ForEach(DonationType.allCases, id: \.self) { type in
                            Button(action: {
                                selectedDonationType = type
                            }) {
                                Text("Donate \(type.rawValue)") // Button text for Donation Type
                                    .font(.system(size: 16, weight: .semibold))
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(cardBackgroundColor)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(selectedDonationType == type ? accentOrange : Color.clear, lineWidth: 2)
                                    )
                            }
                            .foregroundColor(selectedDonationType == type ? .white : Color.gray)
                            .cornerRadius(8)
                        }
                    }
                    
                    VStack(spacing: 24) {
                        if selectedDonationType == .food {
                            // Food Donation Form
                            VStack(alignment: .leading, spacing: 16) {
                                // Food Type Picker
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Food Type")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white)
                                    Menu {
                                        ForEach(FoodType.allCases, id: \.self) { type in
                                            Button(type.rawValue) {
                                                selectedFoodType = type
                                            }
                                        }
                                    } label: {
                                        HStack {
                                            Text(selectedFoodType.rawValue) // Displays selected food type
                                                .foregroundColor(.white)
                                            Spacer()
                                            Image(systemName: "chevron.down")
                                                .foregroundColor(.white)
                                        }
                                        .padding()
                                        .background(inputBackgroundColor)
                                        .cornerRadius(8)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(borderColor, lineWidth: 1)
                                        )
                                    }
                                }
                                
                                // Quantity Input with Dropdown Menu for Units
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Quantity")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white)
                                    HStack {
                                        TextField("Enter quantity", text: $quantity) // Input for quantity
                                            .keyboardType(.numberPad)
                                            .foregroundColor(.white)
                                            .padding()
                                            .background(inputBackgroundColor)
                                            .cornerRadius(8)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(borderColor, lineWidth: 1)
                                            )
                                            .frame(width: 250)
                                        Menu {
                                            Button("Person") {
                                                selectedUnit = "Person"
                                            }
                                            Button("Bag") {
                                                selectedUnit = "Bag"
                                            }
                                            Button("Packets") {
                                                selectedUnit = "Packets"
                                            }
                                        } label: {
                                            HStack {
                                                Text(selectedUnit) // Displays selected unit
                                                    .foregroundColor(.white)
                                                Spacer()
                                                Image(systemName: "chevron.down")
                                                    .foregroundColor(.white)
                                            }
                                            .padding()
                                            .background(inputBackgroundColor)
                                            .cornerRadius(8)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(borderColor, lineWidth: 1)
                                            )
                                        }
                                        .frame(width: 100, height: 40)
                                    }
                                }
                                
                                // Pickup Address Input
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Pickup Address")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white)
                                    HStack {
                                        TextField("Enter address", text: $pickupAddress) // Input for address
                                            .foregroundColor(.white)
                                            .padding()
                                            .background(inputBackgroundColor)
                                            .cornerRadius(8)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(borderColor, lineWidth: 1)
                                            )
                                            .frame(width: 350)
                                        Image(systemName: "location.fill")
                                            .foregroundColor(.white)
                                            .padding(.trailing, 8)
                                    }
                                }
                                
                                // Pickup Date Picker
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Pickup Time")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white)
                                    HStack {
                                        DatePicker("", selection: $pickupDate) // Date picker for pickup time
                                            .colorScheme(.dark)
                                            .labelsHidden()
                                        Spacer()
                                    }
                                    .padding()
                                    .background(inputBackgroundColor)
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(borderColor, lineWidth: 1)
                                    )
                                }
                                
                                // Map View for Pickup Location
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Pin PickUp Location on Map")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white)
                                    Map(coordinateRegion: $region) // Map to show pickup location
                                        .frame(height: 200)
                                        .cornerRadius(8)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(borderColor, lineWidth: 1)
                                        )
                                }
                            }
                        }
                    }
                    
                    // Action Buttons (Cancel, Submit Donation)
                    HStack(spacing: 16) {
                        Button(action: resetFields) {
                            Text("Cancel") // Cancel button
                                .font(.system(size: 16, weight: .semibold))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red.opacity(0.3))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        
                        Button(action: submitDonation) {
                            Text("Submit Donation") // Submit button
                                .font(.system(size: 16, weight: .semibold))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green.opacity(0.2))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                    .padding(.bottom, 24)
                }
                .padding()
            }
            .background(backgroundColor.edgesIgnoringSafeArea(.all))

            // Fixed Title on Top
            Text("Donation Form")
                .font(.largeTitle.bold())
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(cardBackgroundColor)
                .zIndex(1)
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(""),
                message: Text(alertMessage), // Displays alert message
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    // MARK: - Functions
    
    // Function to reset form fields
    private func resetFields() {
        selectedFoodType = .packed
        quantity = ""
        selectedUnit = "Kg"
        pickupAddress = ""
        pickupDate = Date()
    }
    
    // Function to show alert with a custom message
    private func showAlertMessage(_ message: String) {
        alertMessage = message
        showAlert = true
    }
    
    // Function to submit the donation (checks required fields)
    private func submitDonation() {
        if quantity.isEmpty || pickupAddress.isEmpty || region.center.latitude == 0 || region.center.longitude == 0 {
            showAlertMessage("Please fill in all required fields for food donation.")
            return
        }
        showAlertMessage("Food donation submitted successfully!")
    }
}

extension Color {
    // Custom initializer to create Color from a hex string
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// Preview provider to show the DoonationForm in dark mode during development
struct DonationForm_Previews: PreviewProvider {
    static var previews: some View {
        DoonationForm()
            .preferredColorScheme(.dark)
    }
}
// Impact Screen Content
import SwiftUI
import Charts

// MARK: - Custom Colors
// Defining custom colors for consistent styling across the screen
let primaryBackground = Color.black // Pure black background
let cardBackground = Color(red: 0.07, green: 0.07, blue: 0.07) // #121212 - Dark background for cards
let primaryText = Color.white // White text for main content
let secondaryText = Color(red: 0.61, green: 0.61, blue: 0.61) // #9B9B9B - Lighter gray text
let primaryButton = Color(red: 1.00, green: 0.60, blue: 0.22) // #FF9838 - Orange for buttons
let secondaryButton = Color(red: 0.55, green: 0.45, blue: 0.33) // #8B7355 - Brown for secondary buttons
let highlightRed = Color(red: 1.00, green: 0.29, blue: 0.38) // #FF4B60 - Highlight color for important elements
let highlightBlue = Color(red: 0.23, green: 0.51, blue: 0.96) // #3B82F6 - Highlight blue
let highlightGreen = Color(red: 0.13, green: 0.77, blue: 0.37) // #22C55E - Highlight green
let iconBackground = Color(red: 0.10, green: 0.10, blue: 0.10) // #1A1A1A - Dark background for icons

struct ImpactScreen: View {
    // Sample data for mock screen to demonstrate impact statistics and milestones
    @State private var donations: Int = 24
    @State private var meals: Int = 156
    @State private var hours: Int = 12

    // Sample milestones for the user
    @State private var milestones: [Milestone] = [
        Milestone(title: "First Donation", description: "Made your first food donation", date: "Jan 15, 2024"),
        Milestone(title: "50 Meals", description: "Helped provide 50 meals", date: "Mar 1, 2024"),
        Milestone(title: "Regular Donor", description: "Donated for 3 consecutive months", date: "Mar 15, 2024")
    ]

    // Chart data representing donations over months
    @State private var chartData: [ChartData] = [
        ChartData(month: "Jan", value: 14),
        ChartData(month: "Feb", value: 21),
        ChartData(month: "Mar", value: 18),
        ChartData(month: "Apr", value: 25)
    ]

    var body: some View {
        ZStack {
            primaryBackground.edgesIgnoringSafeArea(.all) // Apply background to the entire screen

            VStack(spacing: 20) {
                // Sticky Header: Title "Your Impact"
                Text("Your Impact")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(primaryText) // Apply primary text color
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.horizontal)
                    .padding(.top, 20)
                    .background(primaryBackground) // Set the background to primaryBackground
                    .zIndex(1) // Ensures the header stays at the top

                // Scrollable content
                ScrollView {
                    VStack(spacing: 20) {
                        // Stats Section
                        HStack(spacing: 16) {
                            StatView(icon: "cart", value: donations, label: "Donations", accentColor: highlightRed)
                            StatView(icon: "fork.knife", value: meals, label: "Meals", accentColor: highlightBlue)
                            StatView(icon: "clock", value: hours, label: "Hours", accentColor: highlightGreen)
                        }
                        .padding(.horizontal)

                        // Chart Section: Displays donations over time
                        ChartView(data: chartData)

                        // Milestones Section
                        Text("Milestones")
                            .font(.headline)
                            .foregroundColor(primaryText)
                            .padding(.top)

                        // Loop through milestones and display each one
                        ForEach(milestones) { milestone in
                            MilestoneView(milestone: milestone)
                        }

                        // Share Button
                        Button(action: {
                            print("Share Impact") // Placeholder for share functionality
                        }) {
                            Text("Share Your Impact")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(primaryButton) // Apply primary button color
                                .foregroundColor(.white) // White text for button
                                .cornerRadius(10) // Rounded corners for the button
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
    }
}

// MARK: - Supporting Views

// StatView: Displays individual stats with an icon, value, and label
struct StatView: View {
    var icon: String
    var value: Int
    var label: String
    var accentColor: Color

    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(iconBackground) // Background color for icon
                    .frame(width: 50, height: 50)
                Image(systemName: icon) // System icon for the stat
                    .font(.title2)
                    .foregroundColor(accentColor) // Icon color
            }
            Text("\(value)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(primaryText) // Apply primary text color
            Text(label)
                .font(.footnote)
                .foregroundColor(secondaryText) // Lighter text for the label
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(cardBackground) // Apply background for the stat card
        .cornerRadius(10)
    }
}

// ChartView: Displays a line chart with donation data over time
struct ChartView: View {
    var data: [ChartData]

    var body: some View {
        Chart {
            ForEach(data) { point in
                LineMark(
                    x: .value("Month", point.month),
                    y: .value("Value", point.value)
                )
                .symbol(Circle()) // Use circle markers for data points
                .foregroundStyle(highlightGreen) // Line color
            }
        }
        .frame(height: 250) // Set the height of the chart
        .padding()
        .background(cardBackground) // Background for the chart
        .cornerRadius(10)
        .chartXAxis {
            AxisMarks(values: .automatic) // Automatic x-axis marks
        }
        .chartYAxis {
            AxisMarks(values: .automatic) // Automatic y-axis marks
        }
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(primaryText.opacity(0.1), lineWidth: 1) // Add subtle border
        )
    }
}

// MilestoneView: Displays each milestone with a trophy icon, title, description, and date
struct MilestoneView: View {
    var milestone: Milestone

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            ZStack {
                Circle()
                    .fill(iconBackground) // Background color for the icon
                    .frame(width: 40, height: 40)
                Image(systemName: "trophy") // Trophy icon for the milestone
                    .font(.title2)
                    .foregroundColor(primaryButton) // Icon color
            }
            VStack(alignment: .leading) {
                Text(milestone.title)
                    .font(.headline)
                    .foregroundColor(primaryText) // Title in primary text color
                Text(milestone.description)
                    .font(.subheadline)
                    .foregroundColor(secondaryText) // Description in secondary text color
                Text(milestone.date)
                    .font(.caption)
                    .foregroundColor(secondaryText) // Date in secondary text color
            }
            Spacer()
        }
        .padding()
        .background(cardBackground) // Background for the milestone card
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

// MARK: - Models

// ChartData: Model representing a data point for the chart (month and value)
struct ChartData: Identifiable {
    var id = UUID()
    var month: String
    var value: Int
}

// Milestone: Model representing a milestone (title, description, date)
struct Milestone: Identifiable {
    var id = UUID()
    var title: String
    var description: String
    var date: String
}

// MARK: - Preview

// Preview: Used for showing the ImpactScreen in the SwiftUI preview
struct ImpactScreen_Previews: PreviewProvider {
    static var previews: some View {
        ImpactScreen() // Display the ImpactScreen view in preview
    }
}

// Preview for another screen (assuming it's intended for a different view)
struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
