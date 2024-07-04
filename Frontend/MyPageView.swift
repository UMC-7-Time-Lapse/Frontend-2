import SwiftUI

/// MyPageView는 마이 페이지 화면을 위한 뷰입니다.
struct MyPageView: View {
    @Binding var memories: [Memory]

    var body: some View {
        VStack {
            Text("마이 페이지")
                .font(.largeTitle)
                .padding()

            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(memories) { memory in
                        NavigationLink(destination: MemoryDetailView(memory: memory)) {
                            VStack(alignment: .leading) {
                                TabView {
                                    ForEach(memory.mediaData, id: \.self) { data in
                                        if let image = UIImage(data: data) {
                                            Image(uiImage: image)
                                                .resizable()
                                                .scaledToFill() // 이미지가 전체를 채우도록 설정
                                                .frame(width: UIScreen.main.bounds.width / 2 - 20, height: UIScreen.main.bounds.width / 1.5 - 20) // 세로 길이를 더 길게
                                                .cornerRadius(15) // 모서리를 둥글게
                                                .clipped() // 이미지가 프레임을 벗어나지 않도록 잘라내기
                                        } else {
                                            Image(systemName: "video")
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: UIScreen.main.bounds.width / 2 - 20, height: UIScreen.main.bounds.width / 1.5 - 20)
                                                .cornerRadius(15) // 모서리를 둥글게
                                                .clipped()
                                        }
                                    }
                                }
                                .frame(height: UIScreen.main.bounds.width / 1.5 - 20) // TabView 높이 설정
                                .tabViewStyle(PageTabViewStyle())

                                Text(memory.text)
                                    .padding([.leading, .trailing, .bottom])
                            }
                        }
                    }
                }
                .padding()
            }
        }
    }
}

struct MyPageView_Previews: PreviewProvider {
    @State static var memories: [Memory] = []

    static var previews: some View {
        MyPageView(memories: $memories)
    }
}
