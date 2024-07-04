import SwiftUI
import MapKit

/// MemoryDetailView는 특정 메모리의 상세 정보를 표시하는 뷰입니다.
struct MemoryDetailView: View {
    var memory: Memory

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                TabView {
                    ForEach(memory.mediaData, id: \.self) { data in
                        if let image = UIImage(data: data) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                        } else {
                            Image(systemName: "video")
                                .resizable()
                                .scaledToFit()
                        }
                    }
                }
                .frame(height: 300)
                .tabViewStyle(PageTabViewStyle())
                
                Text(memory.text)
                    .font(.body)
                    .padding()
                
                Text("Date: \(memory.date.formatted(date: .long, time: .shortened))")
                    .font(.caption)
                    .padding([.leading, .trailing])

                Map(coordinateRegion: .constant(MKCoordinateRegion(
                    center: memory.location,
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )))
                .frame(height: 300)
                .cornerRadius(10)
                .padding([.leading, .trailing])
            }
            .padding()
            .navigationTitle("Memory Detail")
        }
    }
}

struct MemoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MemoryDetailView(memory: Memory(text: "Sample text", mediaData: [], location: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), date: Date()))
    }
}
