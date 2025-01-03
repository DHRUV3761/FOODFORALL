//
//  HoomeScreen.swift
//  HACKATHON
//
//  Created by DHRUV on 02/01/25.
//

import Foundation

import SwiftUI

// MARK: - Home Screen
struct HoomeScreen: View {
    var body: some View {
        NavigationView { // NavigationView provides navigation bar and structure
            ScrollView { // Enables vertical scrolling for content
                VStack(spacing: 16) {
                    
                    // MARK: - Header Section
                    HStack { // Header showing user profile and location
                        HStack(spacing: 12) {
                            Image(systemName: "person.crop.circle.fill")
                                .font(.title)
                                .foregroundColor(.white)
                            VStack(alignment: .leading) {
                                Text("Hello User") // Displays user greeting
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text("Location") // Displays user location
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        Spacer()
                        Image(systemName: "fork.knife.circle") // Icon for additional functionality
                            .font(.title)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.black) // Black header background

                    // MARK: - Services Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Our Services")
                            .font(.title2)
                            .bold()
                            .padding(.horizontal)
                            .foregroundColor(.white)

                        // Grid layout for service cards
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            ForEach(serviceData, id: \.id) { service in
                                if service.title == "Chat" {
                                    // Navigation to ChatView
                                    NavigationLink(destination: ChatView()) {
                                        ServiceCard(imageName: service.icon, title: service.title)
                                    }
                                } else if service.title == "Donation" {
                                    // Navigation to DonationView
                                    NavigationLink(destination: DoonationForm()) {
                                        ServiceCard(imageName: service.icon, title: service.title)
                                    }
                                } else if service.title == "Charity" {
                                    // Navigation to CharityView
                                    NavigationLink(destination: CharityView()) {
                                        ServiceCard(imageName: service.icon, title: service.title)
                                    }
                                } else if service.title == "Funds" {
                                    // Navigation to FundsView
                                    NavigationLink(destination: FundsView()) {
                                        ServiceCard(imageName: service.icon, title: service.title)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                    // MARK: - Impact Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Our Impact So Far")
                            .font(.title2)
                            .bold()
                            .padding(.horizontal)
                            .foregroundColor(.white)

                        // Grid layout for impact cards
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            ForEach(impactData, id: \.id) { impact in
                                ImpactCard(
                                    icon: impact.icon,
                                    value: impact.value,
                                    label: impact.label,
                                    color: impact.color
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // MARK: - Call to Action Buttons
                    VStack(spacing: 16) {
                        NavigationLink(destination: BecomeAVolunteerView()) {
                            Text("Become a Volunteer")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.orange)
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 16)
                }
            }
            .background(Color.black.ignoresSafeArea()) // Black background for the entire view
        }
    }
}

// MARK: - New Views for Donation, Charity, and Funds
struct DonationView: View {
    var body: some View {
        VStack {
            Text("Donation Details")
                .font(.largeTitle)
                .bold()
            Text("Here you can learn more about donation opportunities.")
                .font(.subheadline)
                .foregroundColor(.gray)
            // Add content for donation details here
        }
        .navigationBarTitle("Donation", displayMode: .inline)
    }
}

struct CharityView: View {
    var body: some View {
        NavigationView {
            CharityApp() // Directly show CharityApp content
                .navigationBarTitle("Charity", displayMode: .inline) // Set the title for this screen
        }
    }
}

import SwiftUI

struct FundsView: View {
    @State private var donationAmount: String = "" // State for donation amount
    @State private var showAlert: Bool = false // State to show the alert
    @State private var alertMessage: String = "" // State to hold the alert message

    var body: some View {
        ScrollView {
            // Make the entire view scrollable
            VStack(spacing: 24) {
                Spacer().frame(height: 100) // Adjust the height to move the title down
                
                // Title and description
                Text("Funds Information")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .bold()
                
                // Donation Amount Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Donation Amount")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                    
                    TextField("Enter amount", text: $donationAmount)
                        .keyboardType(.numberPad)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                        .foregroundColor(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(UIColor.systemGray4), lineWidth: 1)
                        )
                }
                .padding(.top, 50)
                
                // Donate via Razorpay Button
                Button(action: processMockPayment) {
                    Text("Donate via Razorpay")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .font(.system(size: 16, weight: .semibold))
                }
                
                // Action Buttons
                HStack(spacing: 16) {
                    Button(action: {}) {
                        Text("Cancel")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 0.6, green: 0.3, blue: 0.2)) // Brown color
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .font(.system(size: 16, weight: .semibold))
                    }
                    
                    Button(action: processMockPayment) {
                        Text("Submit Donation")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 0.2, green: 0.4, blue: 0.2)) // Dark green color
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .font(.system(size: 16, weight: .semibold))
                    }
                }
            }
            .padding()
        }
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
        .alert("Donation Status", isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(alertMessage)
        }
        .navigationBarTitle("Funds", displayMode: .inline)
    }
    
    // Function to process the mock payment (donation)
    private func processMockPayment() {
        guard let amount = Double(donationAmount), amount > 0 else {
            alertMessage = "Please enter a valid donation amount."
            showAlert = true
            return
        }
        
        alertMessage = "Payment of ₹\(donationAmount) processed successfully!"
        showAlert = true
    }
}

// Preview provider for SwiftUI canvas
struct FundsView_Previews: PreviewProvider {
    static var previews: some View {
        FundsView()
    }
}
// MARK: - Service Data Model
struct Service: Identifiable {
    let id = UUID() // Unique identifier for each service
    let title: String // Service title
    let icon: String // Icon name for service
}

// MARK: - Impact Data Model
struct Impact: Identifiable {
    let id = UUID() // Unique identifier for each impact
    let icon: String // Icon name for impact
    let value: String // Impact value (e.g., numbers)
    let label: String // Description label
    let color: Color // Color for the impact card
}

// MARK: - Mock Data
let serviceData = [
    Service(title: "Donation", icon: "1"), // Replace with your asset image name
    Service(title: "Charity", icon: "2"),
    Service(title: "Funds", icon: "4"),
    Service(title: "Chat", icon: "3") // Chat service button
]

let impactData = [
    Impact(icon: "heart.fill", value: "50,000", label: "Impact", color: .pink),
    Impact(icon: "person.3.fill", value: "25,000", label: "Community", color: .blue),
    Impact(icon: "dollarsign.circle.fill", value: "75,000", label: "Support", color: .green)
]

// MARK: - Volunteer Registration View
struct VolunteerRegistrationView: View {
    var body: some View {
        VStack {
            Text("Volunteer Registration")
                .font(.largeTitle)
                .bold()
            // Add your registration form fields here
        }
        .navigationBarTitle("Volunteer Registration", displayMode: .inline)
    }
}

// MARK: - Service Card Component
struct ServiceCard: View {
    let imageName: String // Icon or image name for service
    let title: String // Title of the service

    var body: some View {
        VStack {
            Image(imageName) // Displays the service icon
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
                .padding()
                .background(Color.gray.opacity(0.2)) // Light gray background
                .clipShape(Circle()) // Makes the image circular
            Text(title) // Service title
                .font(.headline)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.gray.opacity(0.2)) // Card background
        .cornerRadius(16)
    }
}

// MARK: - Impact Card Component
struct ImpactCard: View {
    let icon: String // Icon name for impact
    let value: String // Impact value
    let label: String // Description label
    let color: Color // Card color theme

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon) // Displays the icon
                .font(.largeTitle)
                .foregroundColor(color) // Icon color
                .padding()
                .background(color.opacity(0.2)) // Light background
                .clipShape(Circle()) // Makes the icon background circular

            VStack(spacing: 4) {
                Text(value) // Value display (e.g., numbers)
                    .font(.headline)
                    .bold()
                    .foregroundColor(.white)
                Text(label) // Label description
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.gray.opacity(0.2)) // Card background
        .cornerRadius(16)
    }
}

// MARK: - Preview
struct HoomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HoomeScreen()
    }
}





import SwiftUI

// MARK: - Question Struct
/// Represents a question with a unique identifier and text.
struct Question: Identifiable {
    let id = UUID() // Unique ID for each question
    let text: String // Question text
}

// MARK: - QADatabase Singleton
/// Singleton class for storing and retrieving Q&A data.
class QADatabase {
    static let shared = QADatabase() // Singleton instance

    /// Dictionary to store questions and their corresponding answers.
    let qaData: [String: String] = [
        "What is the minimum amount I can donate?": "The minimum donation amount is $5. Every contribution helps.",
        "Can I make a one-time donation?": "Yes, one-time donations are supported.",
        "How can I track my donations?": "You can track your donations via your account dashboard.",
        "Are my donations tax-deductible?": "Yes, all donations are tax-deductible. A receipt will be provided.",
        "Can I donate anonymously?": "Yes, we support anonymous donations."
    ]
    
    /// Returns all questions as a list of `Question` objects.
    var allQuestions: [Question] {
        return qaData.keys.map { Question(text: $0) }
    }
    
    /// Fetches the answer for a given question.
    /// - Parameter question: The question string.
    /// - Returns: The answer string if found, otherwise `nil`.
    func getAnswer(for question: String) -> String? {
        return qaData[question]
    }
}

// MARK: - Message Struct
/// Represents a single chat message with user, timestamp, and text.
struct Message: Identifiable {
    let id = UUID() // Unique ID for each message
    let text: String // Message content
    let isUser: Bool // True if the message is from the user
    let timestamp: String // Time when the message was sent
}

// MARK: - ChatSession Struct
/// Represents a chat session containing multiple messages and a date.
struct ChatSession: Identifiable {
    let id = UUID() // Unique ID for each session
    let messages: [Message] // List of messages in the session
    let date: String // Date of the session
}

// MARK: - ChatViewModel
/// ViewModel to handle chat functionality and manage messages and sessions.
class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = [] // Current chat messages
    @Published var chatHistory: [ChatSession] = [] // List of previous chat sessions
    let qaDatabase = QADatabase.shared // Reference to QADatabase

    /// Clears the current chat and adds a welcome message.
    func clearChat() {
        messages.removeAll()
        messages.append(welcomeMessage())
    }

    /// Starts a new chat session and saves the current session to history.
    func newChat() {
        saveCurrentChatToHistory()
        messages.removeAll()
        messages.append(welcomeMessage())
    }

    /// Deletes the current chat session and saves it to history.
    func deleteConversation() {
        saveCurrentChatToHistory()
        messages.removeAll()
    }

    /// Resumes a selected chat session.
    /// - Parameter session: The session to resume.
    func resumeChat(session: ChatSession) {
        messages = session.messages
    }

    /// Saves the current chat session to history.
    private func saveCurrentChatToHistory() {
        guard !messages.isEmpty else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        let date = dateFormatter.string(from: Date())
        let session = ChatSession(messages: messages, date: date)
        chatHistory.insert(session, at: 0)
    }

    /// Generates a welcome message.
    private func welcomeMessage() -> Message {
        return Message(
            text: "👋 Welcome! I'm your AI donation assistant. How can I help you make a difference today?",
            isUser: false,
            timestamp: getCurrentTime()
        )
    }

    /// Fetches the current time as a string.
    private func getCurrentTime() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: Date())
    }
}

// The rest of the code remains similarly commented for clarity.

// MARK: - Colors
struct AppColors {
    let background = Color(hexValue: "1C1E26")  // Neutral Dark
    let listRowBackground = Color(hexValue: "2A2D3A") // Neutral Gray
    let primary = Color(hexValue: "FFA500")     // Primary Blue
    let textPrimary = Color.white          // Text Primary
    let textSecondary = Color(hexValue: "9BA1B0") // Text Secondary
}

extension Color {
    init(hexValue: String) {
        let hex = hexValue.trimmingCharacters(in: .alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}

// MARK: - HeaderView
import UIKit

extension UIColor {
    // Create a color from a hex string
    static func fromHex(_ hex: String) -> UIColor {
        var hexSanitized = hex.replacingOccurrences(of: "#", with: "")
        
        // Add alpha value if missing (defaults to 100% opacity)
        if hexSanitized.count == 6 {
            hexSanitized = "FF" + hexSanitized // Assuming alpha 100%
        }
        
        // Convert hex string to RGB
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        // Extract RGBA components from hex
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        let alpha = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}

struct HeaderView: View {
    @ObservedObject var viewModel: ChatViewModel
    @State private var showingChatHistory = false

    var body: some View {
        HStack {
            Circle()
                .fill(Color(UIColor.fromHex("7B68EE")))
                .frame(width: 50, height: 50)
                .overlay(
                    Image(systemName: "sparkles.tv")
                        .foregroundColor(.white)
                        .font(.system(size: 24))
                )
            VStack(alignment: .leading) {
                Text("Donation Assistant")
                    .foregroundColor(.white)
                    .font(.headline)
                Text("Always here to help")
                    .foregroundColor(.gray)
                    .font(.subheadline)
            }
            Spacer()
            Menu {
                Button(action: { viewModel.newChat() }) {
                    Label("New Chat", systemImage: "plus.circle")
                }
                Button(action: { viewModel.clearChat() }) {
                    Label("Clear Chat", systemImage: "trash")
                }
                Button(action: { viewModel.deleteConversation() }) {
                    Label("Delete Conversation", systemImage: "xmark.circle")
                }
                Button(action: { showingChatHistory.toggle() }) {
                    Label("Chat History", systemImage: "clock")
                }
            } label: {
                Image(systemName: "ellipsis.circle")
                    .font(.system(size: 24))
                    .foregroundColor(.white)
            }
        }
        .padding()
        .background(AppColors().background)
        .sheet(isPresented: $showingChatHistory) {
            ChatHistoryView(viewModel: viewModel)
        }
    }
}

// MARK: - ChatHistoryView
struct ChatHistoryView: View {
    @ObservedObject var viewModel: ChatViewModel
    @Environment(\.presentationMode) var presentationMode
    private let colors = AppColors()

    var body: some View {
        NavigationView {
            List(viewModel.chatHistory) { session in
                Button(action: {
                    viewModel.resumeChat(session: session)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    VStack(alignment: .leading) {
                        Text(session.date)
                            .font(.headline)
                            .foregroundColor(colors.textPrimary)
                        Text(session.messages.first?.text ?? "No messages")
                            .font(.subheadline)
                            .foregroundColor(colors.textSecondary)
                            .lineLimit(1)
                    }
                }
                .listRowBackground(colors.listRowBackground)
            }
            .navigationTitle("Chat History")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { presentationMode.wrappedValue.dismiss() }
                        .foregroundColor(colors.primary)
                }
            }
            .background(colors.background)
        }
        .background(colors.background)
    }
}

// MARK: - QuestionSuggestionView
struct QuestionSuggestionView: View {
    let questions: [Question]
    let onQuestionSelected: (String) -> Void
    
    let buttonColor = Color(UIColor.fromHex("9B59B6").withAlphaComponent(0.2))  // Light transparent purple
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(questions) { question in
                    Button(action: { onQuestionSelected(question.text) }) {
                        Text(question.text)
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(buttonColor)  // Apply the light transparent purple color here
                            .cornerRadius(20)
                            .lineLimit(1)
                    }
                }
            }
            .padding(.horizontal)
        }
        .frame(height: 40)
    }
}

// MARK: - ChatView
struct ChatView: View {
    @StateObject private var viewModel = ChatViewModel()
    @State private var currentMessage: String = ""

    var body: some View {
        VStack(spacing: 0) {
            HeaderView(viewModel: viewModel)

            ScrollView {
                VStack(spacing: 15) {
                    ForEach(viewModel.messages) { message in
                        MessageBubble(message: message)
                    }
                }
                .padding()
            }

            QuestionSuggestionView(questions: Array(viewModel.qaDatabase.allQuestions.prefix(5))) { question in
                sendMessage(text: question)
            }
            .padding(.vertical, 8)
            .background(AppColors().background)

            HStack(spacing: 10) {
                TextField("Type your message...", text: $currentMessage)
                    .padding()
                    .background(AppColors().listRowBackground)
                    .cornerRadius(20)
                    .foregroundColor(.white)

                Button(action: { sendMessage(text: currentMessage) }) {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .padding()
                        .background(AppColors().primary)
                        .clipShape(Circle())
                }
            }
            .padding()
            .background(AppColors().background)
        }
        .background(AppColors().background)
    }

    private func sendMessage(text: String) {
        guard !text.isEmpty else { return }
        viewModel.messages.append(Message(text: text, isUser: true, timestamp: getCurrentTime()))
        currentMessage = ""

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let response = viewModel.qaDatabase.getAnswer(for: text) {
                viewModel.messages.append(Message(text: response, isUser: false, timestamp: getCurrentTime()))
            } else {
                viewModel.messages.append(Message(
                    text: "I'm sorry, I don't have specific information about that.",
                    isUser: false,
                    timestamp: getCurrentTime()
                ))
            }
        }
    }

    private func getCurrentTime() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: Date())
    }
}

// MARK: - MessageBubble
struct MessageBubble: View {
    let message: Message
    
    let bubbleColor = Color.blue.opacity(0.3)  // Light transparent blue
    
    var body: some View {
        VStack(alignment: message.isUser ? .trailing : .leading) {
            HStack {
                if message.isUser { Spacer() }
                Text(message.text)
                    .padding()
                    .background(message.isUser ? bubbleColor : AppColors().listRowBackground)
                    .foregroundColor(.white)
                    .cornerRadius(15)
                if !message.isUser { Spacer() }
            }
            Text(message.timestamp)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}

