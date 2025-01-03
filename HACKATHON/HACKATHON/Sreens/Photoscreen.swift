
import SwiftUI

// Custom Color Extension for consistent color scheme
extension Color {
    static let primaryBackground = Color("PrimaryBackground")
    static let secondaryBackground = Color("SecondaryBackground")
    static let primaryText = Color("PrimaryText")
    static let secondaryText = Color("SecondaryText")
    static let accentColor = Color("AccentColor")
    static let heartColor = Color("HeartColor")
    static let impactBackground = Color("ImpactBackground")
    static let descriptionText = Color("DescriptionText")
}

// Model for Photo Data
struct Photo: Identifiable {
    let id: Int
    let title: String
    let image: String
    let category: String
    let date: String
    let location: String
    let description: String
    let impact: String
    let likes: Int
}

// View Model
class PhotoGridViewModel: ObservableObject {
    @Published var selectedPhoto: Photo?
    @Published var activeIndex: Int? = nil
    
    let photos = [
        Photo(id: 1, title: "Food Donation Campaign", image: "FOODDONATION", category: "Events", date: "February 10, 2025", location: "Main City Park", description: "Collected and distributed food packages to over 400 families.", impact: "400+ families helped", likes: 300),
        Photo(id: 2, title: "Soup Kitchen Outreach", image: "soup_kitchen", category: "Kitchen", date: "January 5, 2025", location: "City Center Kitchen", description: "Volunteers served hot soup and meals to homeless individuals.", impact: "350+ meals served", likes: 250),
        Photo(id: 3, title: "Youth Cooking Workshop", image: "youth_workshop", category: "Workshop", date: "December 12, 2024", location: "Community Youth Center", description: "Taught local youth the basics of cooking with donated food supplies.", impact: "50+ students participated", likes: 180),
        Photo(id: 4, title: "Senior Citizens Meal Prep", image: "senior_meal", category: "Kitchen", date: "November 25, 2024", location: "Senior Care Home", description: "Prepared nutritious meals for over 200 senior citizens.", impact: "200+ seniors served", likes: 210),
        Photo(id: 5, title: "Holiday Meal Distribution", image: "holiday_meal", category: "Events", date: "December 24, 2024", location: "City Square", description: "Distributed special holiday meals to low-income families.", impact: "500+ meals delivered", likes: 400),
        Photo(id: 6, title: "Eco-friendly Cooking Event", image: "eco_cooking", category: "Workshop", date: "October 14, 2024", location: "Eco Park", description: "Showcased sustainable cooking practices using rescued food.", impact: "100+ people educated", likes: 220),
        Photo(id: 7, title: "Mobile Food Bank Launch", image: "mobile_food_bank", category: "Events", date: "September 30, 2024", location: "Downtown District", description: "Launched a mobile food bank to bring meals to underserved communities.", impact: "150+ meals distributed", likes: 330),
        Photo(id: 8, title: "Food Drive Collection", image: "food_drive", category: "Events", date: "August 10, 2024", location: "Local Grocery Store", description: "Collected non-perishable food items for local shelters and pantries.", impact: "200+ donations collected", likes: 150)
    ]
}
import SwiftUI

// Photo Cell View
struct PhotoCellView: View {
    let photo: Photo
    let isActive: Bool
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            Image(photo.image)
                .resizable()
                .aspectRatio(1, contentMode: .fill)
                .clipped()
                .cornerRadius(12)
            
            Color.black.opacity(0.5)
                .cornerRadius(12)
                .frame(height: 200)
                .clipped()
            
            VStack(alignment: .leading) {
                Text(photo.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .truncationMode(.tail)
                Text(photo.category)
                    .font(.caption)
                    .opacity(0.8)
            }
            .foregroundColor(.white)
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(height: 200)
        .padding(.top, 16)
        .cornerRadius(12)
        .clipped()
        .background(
            colorScheme == .dark ?
                (isActive ? Color(uiColor: .systemGray6) : Color.secondaryBackground) :
                (isActive ? Color(uiColor: .systemGray5) : Color.secondaryBackground)
        )
    }
}

// Main View
struct PhotoGridPortfolio: View {
    @StateObject private var viewModel = PhotoGridViewModel()
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 16),
                        GridItem(.flexible(), spacing: 16)
                    ], spacing: 16) {
                        ForEach(viewModel.photos) { photo in
                            Button(action: {
                                viewModel.selectedPhoto = photo
                                if let index = viewModel.photos.firstIndex(where: { $0.id == photo.id }) {
                                    viewModel.activeIndex = index
                                }
                            }) {
                                PhotoCellView(
                                    photo: photo,
                                    isActive: viewModel.activeIndex == viewModel.photos.firstIndex(where: { $0.id == photo.id })
                                )
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .background(Color(UIColor(white: 0.11, alpha: 1))) // This sets the background color of the container view (photo cells' parent view)
            .sheet(item: $viewModel.selectedPhoto) { photo in
                photoDetailView(photo)
            }
        }
        .background(Color.primaryBackground)
    }
}

struct PhotoGridPortfolio_Previews: PreviewProvider {
    static var previews: some View {
        PhotoGridPortfolio()
            .preferredColorScheme(.dark)
    }
}
    private func photoDetailView(_ photo: Photo) -> some View {
        ZStack {
            VStack(spacing: 0) {
                Image(photo.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 300)
                    .clipped()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(photo.title)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                
                                Text(photo.category)
                                    .font(.subheadline)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.accentColor.opacity(0.2))
                                    .foregroundColor(Color.red)
                                    .cornerRadius(12)
                            }
                            
                            Spacer()
                            
                            HStack {
                                Image(systemName: "heart.fill")
                                    .foregroundColor(Color.heartColor)
                                Text("\(photo.likes)")
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "calendar")
                                Text(photo.date)
                            }
                            HStack {
                                Image(systemName: "mappin")
                                Text(photo.location)
                            }
                        }
                        .foregroundColor(.gray)
                        
                        Text(photo.description)
                            .foregroundColor(.descriptionText)
                        
                        VStack(alignment: .leading) {
                            Text("Impact")
                                .foregroundColor(Color.red)
                                .fontWeight(.medium)
                            Text(photo.impact)
                                .foregroundColor(.primary)
                        }
                        .padding()
                        .background(Color.impactBackground)
                        .cornerRadius(12)
                    }
                    .padding()
                }
            }
        }
        .background(Color.primaryBackground)
    }


