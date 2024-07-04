import SwiftUI
import CoreLocation

struct MyPageView: View {
    @Binding var memories: [Memory]
    @StateObject private var userLocationManager = UserLocationManager()
    @State private var showAlert = false
    @State private var selectedMemory: Memory?

    var body: some View {
        VStack {
            HStack {
                Image(systemName: "person.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 70)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                    .padding(.trailing, 10)

                Text("사용자")
                    .font(.title2)
                    .fontWeight(.bold)
                Text("님의 페이지")
            }
            .padding()

            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(memories) { memory in
                        Button(action: {
                            if let userLocation = userLocationManager.userLocation {
                                let distance = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude).distance(from: CLLocation(latitude: memory.location.latitude, longitude: memory.location.longitude))
                                if distance < 100 {
                                    selectedMemory = memory
                                } else {
                                    showAlert = true
                                }
                            }
                        }) {
                            VStack(alignment: .leading) {
                                TabView {
                                    ForEach(memory.mediaData, id: \.self) { data in
                                        if let image = UIImage(data: data) {
                                            Image(uiImage: image)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: UIScreen.main.bounds.width / 2 - 24, height: UIScreen.main.bounds.width / 2 - 24)
                                                .cornerRadius(15)
                                                .clipped()
                                        } else {
                                            Image(systemName: "video")
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: UIScreen.main.bounds.width / 2 - 24, height: UIScreen.main.bounds.width / 2 - 24)
                                                .cornerRadius(15)
                                                .clipped()
                                        }
                                    }
                                }
                                .frame(height: UIScreen.main.bounds.width / 2 - 24)
                                .tabViewStyle(PageTabViewStyle())

                                Text(memory.text)
                                    .padding([.leading, .trailing, .bottom])
                            }
                            .background(Color.white)
                            .cornerRadius(15)
                            .shadow(radius: 5)
                            .padding(.horizontal, 8)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .alert(isPresented: $showAlert) {
                            Alert(title: Text("잠김"), message: Text("이 추억은 지정된 위치에서 열려요!"), dismissButton: .default(Text("확인")))
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
            }
        }
        .padding(.top, 20)
        .sheet(item: $selectedMemory) { memory in
            MemoryDetailView(memory: memory)
        }
        .onAppear {
            userLocationManager.requestUserLocation()
        }
    }
}

struct MyPageView_Previews: PreviewProvider {
    @State static var memories: [Memory] = []

    static var previews: some View {
        MyPageView(memories: $memories)
    }
}
