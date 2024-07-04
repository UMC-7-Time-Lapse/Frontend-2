import SwiftUI
import CoreLocation

/// MemoryDetailView는 특정 메모리의 상세 정보를 표시하는 뷰입니다.
struct MemoryDetailView: View {
    var memory: Memory
    @State private var cityName: String = "Loading..."

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                /// 선택된 각 사진/동영상을 가로로 넘길 수 있는 TabView로 표시.
                GeometryReader { geometry in
                    TabView {
                        ForEach(memory.mediaData, id: \.self) { data in
                            if let image = UIImage(data: data) {
                                let aspectRatio = image.size.width / image.size.height
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(aspectRatio, contentMode: .fill)
                                    .frame(width: geometry.size.width)
                                    .clipped()
                            } else {
                                // 비디오 데이터를 표시하기 위한 로직 (여기서는 이미지로 대체)
                                Image(systemName: "video")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: geometry.size.width)
                                    .clipped()
                            }
                        }
                    }
                    .tabViewStyle(PageTabViewStyle())
                    .frame(width: geometry.size.width, height: geometry.size.width * 1.2) // 가로에 맞추고 세로 비율 설정
                    .padding(0)
                    .cornerRadius(10)
                }
                .frame(height: 490)
                
                /// 제목 표시
                Text(memory.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding([.leading, .trailing])

                /// 내용 표시
                Text(memory.content)
                    .font(.body)
                    .padding([.leading, .trailing, .bottom])

                /// 날짜 표시
                Text("Date: \(memory.date.formatted(date: .long, time: .shortened))")
                    .font(.caption)
                    .padding([.leading, .trailing])
                
                /// 위치 도시 이름 표시
                Text("Location: \(cityName)")
                    .font(.caption)
                    .padding([.leading, .trailing])
            }
            .navigationTitle("\(cityName)")
            .onAppear {
                fetchCityName(for: memory.location)
            }
        }
    }
    
    private func fetchCityName(for location: CLLocationCoordinate2D) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: location.latitude, longitude: location.longitude)
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Failed to fetch city name: \(error.localizedDescription)")
                return
            }
            if let placemark = placemarks?.first {
                self.cityName = placemark.locality ?? "Unknown location"
            }
        }
    }
}

struct MemoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MemoryDetailView(memory: Memory(
            title: "Sample Title",
            content: "Sample content goes here. This is the detailed content of the memory.",
            mediaData: [],
            location: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
            date: Date()
        ))
    }
}
