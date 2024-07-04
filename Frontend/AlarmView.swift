import SwiftUI
import CoreLocation

struct AlarmView: View {
    var cityName: String
    var memory: Memory

    var body: some View {
        VStack {
            VStack(alignment: .center) {
                Text(cityName)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.blue)

                Spacer().frame(height: 10)

                Text("추억이 도착했어요")
                    .font(.title)

                Spacer().frame(height: 10)

                Text("추억을 열까요?")
                    .font(.title)

                Spacer().frame(height: 30)

                NavigationLink(destination: MemoryDetailView(memory: memory)) {
                    Image("3dicons")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true) // 백 버튼 숨김
    }
}

struct AlarmView_Previews: PreviewProvider {
    static var previews: some View {
        AlarmView(cityName: "샌프란시스코", memory: Memory(
            title: "Sample Title",
            content: "Sample content goes here. This is the detailed content of the memory.",
            mediaData: [],
            location: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
            date: Date()
        ))
    }
}
