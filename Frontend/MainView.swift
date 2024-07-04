import SwiftUI
import MapKit
import PhotosUI

/// MainView는 사용자 프로필 사진, 사용자 이름, 그리고 "추억 만들기" 버튼과 "마이 페이지" 버튼을 포함하는 스크롤 가능한 메인 화면을 제공합니다.
struct MainView: View {
    @StateObject private var userLocationManager = UserLocationManager()
    @State private var isPickerPresented = false
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var selectedMediaData: [Data] = []
    @State private var isWriteContentViewPresented = false
    @State private var isMyPageViewPresented = false
    @State private var memories: [Memory] = []

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    /// 사용자 프로필 사진
                    Image(systemName: "person.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray, lineWidth: 2))

                    Spacer()

                    /// 사용자 이름
                    Text("사용자")
                        .font(.title2)
                        .fontWeight(.bold)

                    HStack(spacing: 0) {
                        Spacer()
                        /// "마이 페이지" 버튼
                        NavigationLink(destination: MyPageView(memories: $memories), isActive: $isMyPageViewPresented) {
                            Text("마이 페이지")
                                .font(.title3)
                                .padding()
                                .frame(width: 140, height: 50)
                                .background(Color.white)
                                .foregroundColor(.blue)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.blue, lineWidth: 1)
                                )
                                .padding(.vertical)
                        }
                        Spacer()
                        Spacer()
                        /// "추억 만들기" 버튼
                        Button(action: {
                            isPickerPresented = true
                        }) {
                            Text("추억 만들기")
                                .font(.title3)
                                .padding()
                                .frame(width: 142, height: 52)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .padding(.vertical)
                        }
                        .photosPicker(isPresented: $isPickerPresented, selection: $selectedItems, matching: .any(of: [.images, .videos]))
                        .onChange(of: selectedItems) { newItems in
                            Task {
                                selectedMediaData.removeAll()
                                for item in newItems {
                                    if let data = try? await item.loadTransferable(type: Data.self) {
                                        selectedMediaData.append(data)
                                    }
                                }
                                // 선택이 완료되면 WriteContentView로 이동
                                isWriteContentViewPresented = !selectedMediaData.isEmpty
                            }
                        }
                        Spacer()
                    }

                    /// 사용자 위치를 표시하는 지도
                    if let userLocation = userLocationManager.userLocation {
                        Map(coordinateRegion: .constant(MKCoordinateRegion(
                            center: userLocation,
                            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                        )))
                        .frame(height: 200)
                        .cornerRadius(10)
                        .padding()
                    } else {
                        ProgressView("Loading map...")
                            .frame(height: 200)
                            .padding()
                    }
                }
                .padding(.top, 30)
                .padding()

                /// WriteContentView로 네비게이션
                NavigationLink(
                    destination: WriteContentView(
                        selectedMediaData: selectedMediaData,
                        geofencing: Geofencing(),
                        onSave: { memory in
                            memories.append(memory)
                            isWriteContentViewPresented = false
                            isMyPageViewPresented = true
                        }
                    ),
                    isActive: $isWriteContentViewPresented
                ) {
                    EmptyView()
                }
            }
            .navigationTitle("")
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
