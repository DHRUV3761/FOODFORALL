import SwiftUI

// MARK: - Theme Colors
struct ThemeColors {
    // Primary brand colors
    static let primary = Color(r: 249, g: 162, b: 84)    // Orange #F9A254
    static let secondary = Color(r: 168, g: 146, b: 118)  // Brown #A89276
    
    // Background colors
    static let background = Color(r: 28, g: 28, b: 30)    // Dark #1C1C1E
    static let cardBg = Color.clear // Removed white background
    
    // Accent colors
    static let accent = Color(r: 52, g: 120, b: 246)      // Blue #3478F6
    static let success = Color(r: 50, g: 215, b: 75)      // Green #32D74B
    static let error = Color(r: 255, g: 67, b: 101)       // Red #FF4365
    
    // Text colors
    static let textPrimary = Color.white
    static let textSecondary = Color.white  // Now white
}

// MARK: - Color Extension
extension Color {
    init(r: Double, g: Double, b: Double, opacity: Double = 1) {
        self.init(
            .sRGB,
            red: r / 255,
            green: g / 255,
            blue: b / 255,
            opacity: opacity
        )
    }
}

// MARK: - View Models
class VolunteerRegistrationViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var phoneNumber: String = ""
    @Published var city: String = ""
    @Published var aadhaarCardNumber: String = ""
    @Published var otp: String = ""
    @Published var isSubmitting = false
    @Published var showSuccessMessage = false
    @Published var isOtpSent = false
    @Published var otpStatusMessage: String = ""
    
    func sendOtp() {
        if aadhaarCardNumber.count == 12 {
            isOtpSent = true
            otpStatusMessage = "OTP has been sent to the mobile number registered with your Aadhaar."
        } else {
            otpStatusMessage = "Invalid Aadhaar number. Please try again."
        }
    }
    
    func submitForm() {
        isSubmitting = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if self.otp == "123456" {
                self.showSuccessMessage = true
            } else {
                self.otpStatusMessage = "Invalid OTP. Please try again."
            }
            self.isSubmitting = false
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.showSuccessMessage = false
            }
        }
    }
}

// MARK: - Views
struct BecomeAVolunteerView: View {
    @StateObject private var viewModel = VolunteerRegistrationViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                ThemeColors.background
                    .ignoresSafeArea()
                
                VStack {
                    Text("Become a Volunteer")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(ThemeColors.textPrimary)
                        .padding(.top)
                    
                    Text("Help make a difference. Register to start volunteering and make an impact!")
                        .font(.subheadline)
                        .foregroundColor(ThemeColors.textSecondary)
                        .padding(.bottom, 20)
                        .multilineTextAlignment(.center)
                    
                    Form {
                        Section(header: Text("Personal Information")
                            .foregroundColor(ThemeColors.textSecondary)) {
                                customTextField("Full Name", text: $viewModel.name)
                                customTextField("Email Address", text: $viewModel.email)
                                    .keyboardType(.emailAddress)
                                customTextField("Phone Number", text: $viewModel.phoneNumber)
                                    .keyboardType(.phonePad)
                                customTextField("City", text: $viewModel.city)
                            }
                            .listRowBackground(ThemeColors.cardBg)
                        
                        Section(header: Text("Verification Details")
                            .foregroundColor(ThemeColors.textSecondary)) {
                                customTextField("Aadhaar Card Number", text: $viewModel.aadhaarCardNumber)
                                    .keyboardType(.numberPad)
                                
                                if viewModel.isOtpSent {
                                    customTextField("Enter OTP", text: $viewModel.otp)
                                        .keyboardType(.numberPad)
                                }
                                
                                if !viewModel.otpStatusMessage.isEmpty {
                                    Text(viewModel.otpStatusMessage)
                                        .font(.caption)
                                        .foregroundColor(viewModel.otpStatusMessage.contains("Invalid") ? ThemeColors.error : ThemeColors.success)
                                }
                            }
                            .listRowBackground(ThemeColors.cardBg)
                        
                        Section {
                            Button(action: {
                                if !viewModel.isOtpSent {
                                    viewModel.sendOtp()
                                } else {
                                    viewModel.submitForm()
                                }
                            }) {
                                HStack {
                                    Spacer()
                                    Text(viewModel.isOtpSent ? "Submit" : "Send OTP")
                                        .fontWeight(.bold)
                                        .foregroundColor(ThemeColors.textPrimary)
                                    Spacer()
                                }
                                .padding()
                                .background(ThemeColors.primary)
                                .cornerRadius(8)
                            }
                            .disabled(viewModel.aadhaarCardNumber.isEmpty || (viewModel.isOtpSent && viewModel.otp.isEmpty) || viewModel.isSubmitting)
                        }
                        .listRowBackground(ThemeColors.cardBg)
                    }
                    .scrollContentBackground(.hidden)
                    
                    if viewModel.showSuccessMessage {
                        Text("Thank you for registering as a volunteer! We'll get in touch with you soon.")
                            .foregroundColor(ThemeColors.success)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(ThemeColors.success.opacity(0.1))
                            .cornerRadius(8)
                    }
                    
                    Spacer()
                }
                .padding()
            }
            
        }
    }
    
    private func customTextField(_ placeholder: String, text: Binding<String>) -> some View {
        ZStack(alignment: .leading) {
            // Show placeholder with improved visibility when the text field is empty
            if text.wrappedValue.isEmpty {
                Text(placeholder)
                    .foregroundColor(Color(r: 142, g: 142, b: 147, opacity: 0.8)) // Lighter gray with opacity
                    .padding(.leading, 15)
                    .padding(.top, 12)
            }
            
            // Actual TextField without background
            TextField("", text: text)
                .padding(EdgeInsets(top: 12, leading: 15, bottom: 12, trailing: 15))
                .foregroundColor(ThemeColors.textPrimary)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(r: 168, g: 146, b: 118, opacity: 0.3), lineWidth: 1) // Lighter border
                )
        }
        .frame(height: 50)
    }
}

struct BecomeAVolunteerView_Previews: PreviewProvider {
    static var previews: some View {
        BecomeAVolunteerView()
    }
}
