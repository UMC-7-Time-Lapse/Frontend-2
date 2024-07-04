import SwiftUI

struct LoginView: View {
    @State private var isActive = false
    
    var body: some View {
        VStack(spacing: 50) {
            if isActive {
                MainView()
            }else {
                VStack(spacing: 40) {
                    Image("logo")
                    VStack(alignment: .leading) {
                        HStack {
                            Text("5초")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(Color.blue)
                            Text("만에")
                                .font(.title)
                        }
                        Text("타임캡슐을 만들어 봐요")
                            .font(.title)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.leading)
                }
                
                VStack {
                    HStack(alignment: .center) {
                        Text("공지 사항")
                        Text("l")
                        Text("고객 센터")
                    }
                    .font(.title3)
                    .foregroundColor(.gray)
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    isActive = true
                }
            }
        }
    }
}

#Preview {
    LoginView()
}
