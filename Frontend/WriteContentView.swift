import SwiftUI
import AVKit
import CoreLocation

/// WriteContentView 뷰는 사용자가 선택한 사진/동영상을 표시하고, 글을 작성할 수 있도록 하는 UI를 제공합니다.
struct WriteContentView: View {
    /// 사용자가 작성한 제목을 저장하는 변수.
    @State private var title: String = ""

    /// 사용자가 작성한 내용을 저장하는 변수.
    @State private var content: String = ""

    /// 사용자가 선택한 미디어 데이터를 저장하는 변수 배열.
    var selectedMediaData: [Data]

    /// Geofencing 클래스의 인스턴스. 위치 업데이트 및 지오펜싱을 관리합니다.
    @ObservedObject var geofencing: Geofencing

    /// 저장 후 호출되는 클로저.
    var onSave: (Memory) -> Void

    /// 현재 위치를 저장하는 변수.
    @State private var currentLocation: CLLocationCoordinate2D?

    var body: some View {
        VStack {
            /// 선택된 각 사진/동영상을 가로로 넘길 수 있는 TabView로 표시.
            TabView {
                ForEach(selectedMediaData, id: \.self) { data in
                    if let image = UIImage(data: data) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                    } else {
                        // 비디오 데이터를 표시하기 위한 로직 (여기서는 이미지로 대체)
                        Image(systemName: "video")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .frame(height: 220) // TabView 높이 설정

            /// 사용자가 제목을 작성할 수 있는 TextField.
            TextField("제목을 입력하세요", text: $title)
                .padding()
                .font(.title)
                .background(Color.clear)

            /// 사용자가 내용을 작성할 수 있는 TextField.
            TextField("내용을 입력하세요", text: $content)
                .padding()
                .font(.body)
                .background(Color.clear)

            /// 사용자가 글을 저장하고 현재 위치에 지오펜싱을 설정하는 '생성' 버튼.
            Button(action: {
                geofencing.setupGeofenceAtCurrentLocation()
                if let location = geofencing.userLocation {
                    let memory = Memory(
                        title: title,
                        content: content,
                        mediaData: selectedMediaData,
                        location: location,
                        date: Date()
                    )
                    onSave(memory)
                }
            }) {
                Text("생성")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .navigationBarTitle("글 작성", displayMode: .inline)
        .onAppear {
            geofencing.requestLocation()
        }
    }
}

struct WriteContentView_Previews: PreviewProvider {
    static var previews: some View {
        WriteContentView(
            selectedMediaData: [],
            geofencing: Geofencing(),
            onSave: { _ in }
        )
    }
}
