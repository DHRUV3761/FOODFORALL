import SwiftUI

struct ProfileScreen: View {
    @State private var expandedSection: String? = nil  // Track which section is expanded
    @State private var notificationsEnabled = true  // Track notification preference
    @State private var navigateToLogin = false  // Track logout state
    var onLogout: () -> Void  // Closure passed for logout action

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)

                ScrollView {
                    VStack(spacing: 30) {
                        headerView
                            .padding(.horizontal)

                        HStack(spacing: 15) {
                            ProfileMetric(title: "24", subtitle: "Donations", icon: "gift.fill", color: .red)
                            ProfileMetric(title: "156", subtitle: "Meals", icon: "fork.knife", color: .blue)
                            ProfileMetric(title: "12", subtitle: "Hours", icon: "clock.fill", color: .green)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)

                        VStack(spacing: 20) {
                            ExpandableSection(title: "Account Settings", icon: "shield.fill", sectionKey: "account") {
                                VStack(spacing: 10) {
                                    ActionButton(title: "Edit Profile")
                                    ActionButton(title: "Privacy Settings")
                                    ActionButton(title: "Connected Accounts")
                                }
                            }

                            ExpandableSection(title: "Donation Preferences", icon: "heart.fill", sectionKey: "donation") {
                                sectionActions(["Preferred Organizations", "Donation Schedule", "Tax Receipts"])
                            }

                            ExpandableSection(title: "More Options", icon: "ellipsis", sectionKey: "moreOptions") {
                                VStack(spacing: 15) {
                                    Toggle(isOn: $notificationsEnabled) {
                                        Text("Notifications")
                                            .foregroundColor(.white)
                                    }
                                    .toggleStyle(SwitchToggleStyle(tint: .orange))

                                    sectionActions(["Share App", "Help Center", "About Us", "Rate App"])
                                }
                            }
                        }
                        .padding(.horizontal)

                        VStack(spacing: 15) {
                            ActionButton(title: "Contact Support", bgColor: .orange, textColor: .white, height: 55)
                            ActionButton(
                                title: "Log Out",
                                bgColor: .red,
                                textColor: .white,
                                height: 55
                            ) {
                                performLogout()  // Perform logout action
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding()
                }

                // Navigation destination for AuthView with fade transition
                if navigateToLogin {
                    AuthView()
                        .transition(.opacity) // Add fade animation
                        .zIndex(1) // Place it above other views
                }
            }
        }
        .animation(.easeInOut(duration: 0.3), value: navigateToLogin) // Apply animation to state change
    }

    private func performLogout() {
        // Clear UserDefaults or other persistent storage
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "username")
        defaults.removeObject(forKey: "password")
        defaults.removeObject(forKey: "isAuthenticated")
        
        // Optional: Clear Keychain or other secure storage if used
        // KeychainManager.clearAll()

        print("User credentials cleared. Logging out...")

        // Call the logout closure passed from the parent view
        onLogout()

        // Navigate to the AuthView
        navigateToLogin = true
    }

    private var headerView: some View {
        VStack(spacing: 20) {
            Circle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 100, height: 100)
                .overlay(
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.white)
                )

            VStack(spacing: 5) {
                Text("John Doe")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
        }
        .padding()
    }

    private func ProfileMetric(title: String, subtitle: String, icon: String, color: Color) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: 28, height: 28)
                .padding()
                .background(color)
                .clipShape(Circle())

            Text(title)
                .font(.headline)
                .foregroundColor(.white)

            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .frame(width: 100, height: 120)
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(15)
    }

    private func ExpandableSection<Content: View>(
        title: String,
        icon: String,
        sectionKey: String,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        VStack(spacing: 10) {
            Button(action: {
                expandedSection = (expandedSection == sectionKey ? nil : sectionKey)
            }) {
                HStack {
                    Image(systemName: icon)
                        .foregroundColor(.white)
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                    Image(systemName: expandedSection == sectionKey ? "chevron.up" : "chevron.down")
                        .foregroundColor(.white)
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            }

            if expandedSection == sectionKey {
                content()
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
            }
        }
    }

    private func sectionActions(_ titles: [String]) -> some View {
        VStack(spacing: 10) {
            ForEach(titles, id: \.self) { title in
                ActionButton(title: title)
            }
        }
    }

    private func ActionButton(title: String, bgColor: Color = .gray.opacity(0.2), textColor: Color = .white, height: CGFloat = 44, action: @escaping () -> Void = {}) -> some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .foregroundColor(textColor)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(textColor)
            }
            .padding()
            .frame(height: height)
            .background(bgColor)
            .cornerRadius(10)
        }
    }
}

struct AuthViewSCREEN: View {
    var body: some View {
        AuthView()
    }
    
    struct ProfileScreen_Previews: PreviewProvider {
        static var previews: some View {
            ProfileScreen(onLogout: { print("Logged out") })
        }
    }
}
