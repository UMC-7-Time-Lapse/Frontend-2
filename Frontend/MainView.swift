import SwiftUI

/// MainView는 사용자 프로필 사진, 사용자 이름, 그리고 "추억 만들기" 버튼과 "마이 페이지" 버튼을 포함하는 스크롤 가능한 메인 화면을 제공합니다.
struct MainView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    /// 사용자 프로필 사진
                    Image(systemName: "person.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                    
                    /// 사용자 이름
                    Text("사용자")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    HStack(spacing: 0){
                        Spacer()
                        /// "마이 페이지" 버튼
                        NavigationLink(destination: MyPageView()) {
                            Text("마이 페이지")
                                .font(.title3)
                                .padding()
                                .frame(width:140, height:50)
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
                        NavigationLink(destination: GeoContent()) {
                            Text("추억 만들기")
                                .font(.title3)
                                .padding()
                                .frame(width:142, height:52)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .padding(.vertical)
                        }
                        Spacer()
                    }
                    
                }
                .padding(.top, 30)
                .padding()
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
