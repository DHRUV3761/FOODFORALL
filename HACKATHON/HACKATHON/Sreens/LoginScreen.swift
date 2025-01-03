import SwiftUI

struct AuthView: View {
    @State private var isSignIn = true
    @State private var email = ""
    @State private var password = ""
    @State private var showPassword = false
    @State private var showLoginAlert = false
    @State private var opacity = 1.0
    @State private var userRole: UserRole? = nil // Use Identifiable struct

    let predefinedCredentials: [String: (String, String)] = [
        "DONOR": ("DONOR", "DonorDashboardView"),
        "NGO": ("NGO", "FoodDetailsView"),
        "delivery": ("delivery123", "DeliveryDashboardView")
    ]
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack {
                Spacer()

                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .shadow(radius: 10)

                Text("Sign \(isSignIn ? "In" : "Up") to your account")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 20)

                VStack(spacing: 16) {
                    TextField("Enter Your Email Address", text: $email)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                        .foregroundColor(.black)

                    HStack {
                        if showPassword {
                            TextField("Enter Your Password", text: $password)
                                .padding()
                                .background(Color(UIColor.systemGray6))
                                .cornerRadius(8)
                                .foregroundColor(.black)
                        } else {
                            SecureField("Enter Your Password", text: $password)
                                .padding()
                                .background(Color(UIColor.systemGray6))
                                .cornerRadius(8)
                                .foregroundColor(.black)
                        }
                    }
                    .overlay(
                        HStack {
                            Spacer()
                            Button(action: { showPassword.toggle() }) {
                                Image(systemName: showPassword ? "eye.fill" : "eye.slash.fill")
                                    .foregroundColor(.gray)
                            }
                            .padding(.trailing, 12)
                        }
                    )
                }

                Button(action: {
                    authenticateUser()
                }) {
                    Text("Sign \(isSignIn ? "In" : "Up")")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(Color.orange)
                        .cornerRadius(8)
                }

                if showLoginAlert {
                    Text("Please enter valid credentials.")
                        .foregroundColor(.red)
                        .padding(.top, 8)
                        .font(.subheadline)
                        .transition(.opacity)
                }

                Spacer()

                Button(action: {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        opacity = 0.0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        isSignIn.toggle()
                        resetFormFields()
                        withAnimation(.easeInOut(duration: 0.5)) {
                            opacity = 1.0
                        }
                    }
                }) {
                    Text(isSignIn ? "Don't have an account? Sign up here" : "Already have an account? Log in here")
                        .font(.subheadline)
                        .foregroundColor(.orange)
                        .opacity(opacity)
                }
                .padding(.bottom, 24)
            }
            .padding(.horizontal, 24)
        }
        .fullScreenCover(item: $userRole) { userRole in
            switch userRole.role {
            case "DonorDashboardView":
                DonorDashboardView()
            case "FoodDetailsView":
                FoodDetailsView()
            case "DeliveryDashboardView":
                DeliveryDashboardView()
            default:
                EmptyView()
            }
        }
    }

    func authenticateUser() {
        if let (validPassword, role) = predefinedCredentials[email.uppercased()], validPassword == password {
            userRole = UserRole(role: role)
        } else {
            showLoginAlert = true
        }
    }

    func resetFormFields() {
        email = ""
        password = ""
    }
}

struct UserRole: Identifiable {
    let id = UUID()
    let role: String
}

struct DonorDashboardView: View {
    var body: some View {
        DashboardView()
    }
}

struct FoodDetailsview: View {
    var body: some View {
        FoodDetailsview()
    }
}

struct DeliveryDashboardView: View {
    var body: some View {
        Text("Welcome to Delivery Dashboard!")
            .font(.largeTitle)
            .foregroundColor(.orange)
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
