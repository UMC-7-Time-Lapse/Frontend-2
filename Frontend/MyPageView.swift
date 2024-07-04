import SwiftUI
import CoreLocation

/// MyPageView는 마이 페이지 화면을 위한 뷰입니다.
struct MyPageView: View {
    @Binding var memories: [Memory]
    @ObservedObject var locationManager: LocationManager

    var body: some View {
        VStack {
            HStack {
                /// 사용자 프로필 사진
                Image(systemName: "person.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 70)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                    .padding(.trailing, 10)

                /// 사용자 이름
                Text("사용자")
                    .font(.title2)
                    .fontWeight(.bold)
                
                /// 사용자 이름
                Text("님의 페이지")
            }
            .padding()
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(memories) { memory in
                        if let userLocation = locationManager.userLocation {
                            let distance = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude).distance(from: CLLocation(latitude: memory.location.latitude, longitude: memory.location.longitude))
                            if distance <= 100 {
                                NavigationLink(destination: MemoryDetailView(memory: memory)) {
                                    MemoryThumbnailView(memory: memory)
                                }
                            } else {
                                MemoryThumbnailView(memory: memory)
                                    .overlay(
                                        Color.black.opacity(0.6)
                                            .cornerRadius(20)
                                            .overlay(
                                                Text("위치가 다릅니다.")
                                                    .foregroundColor(.white)
                                                    .font(.caption)
                                            )
                                    )
                            }
                        } else {
                            MemoryThumbnailView(memory: memory)
                        }
                    }
                }
                .padding()
            }
        }
    }
}

struct MemoryThumbnailView: View {
    var memory: Memory

    var body: some View {
        VStack(alignment: .leading) {
            TabView {
                ForEach(memory.mediaData, id: \.self) { data in
                    if let image = UIImage(data: data) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.width / 2 - 20, height: UIScreen.main.bounds.width / 1.5 - 20)
                            .cornerRadius(15)
                            .clipped()
                    } else {
                        Image(systemName: "video")
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.width / 2 - 20, height: UIScreen.main.bounds.width / 1.5 - 20)
                            .cornerRadius(15)
                            .clipped()
                    }
                }
            }
            .frame(height: UIScreen.main.bounds.width / 1.5 - 20)
            .tabViewStyle(PageTabViewStyle())
        }
    }
}

struct MyPageView_Previews: PreviewProvider {
    @State static var memories: [Memory] = []

    static var previews: some View {
        MyPageView(memories: $memories, locationManager: LocationManager())
    }
}
