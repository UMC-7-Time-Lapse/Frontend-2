import SwiftUI
import KakaoSDKAuth
import KakaoSDKUser

struct LoginView: View {
    @State private var userName: String = ""
    @State private var userMail: String = ""
    @State private var profileImage: URL?
    @State private var loginStatus: String = ""
    @State private var isLoggedIn: Bool = false

    var body: some View {
        VStack(spacing: 50) {
            VStack(spacing: 40) {
                Image("logo")
                VStack(alignment: .leading) {
                    HStack {
                        Text("5초")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: "#2E83F2"))
                        Text("만에")
                            .font(.title)
                    }
                    Text("타임캡슐을 만들어 봐요")
                        .font(.title)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
            }

            Button(action: kakaoLogin) {
                HStack {
                    Image("kakao_login_large_wide")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 50)
                }
                .frame(width: UIScreen.main.bounds.width * 0.8)
                .background(Color(hex: "#FEE500"))
                .cornerRadius(10)
            }
            
            if !loginStatus.isEmpty {
                Text(loginStatus)
                    .font(.headline)
                    .foregroundColor(.green)
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

            if !userName.isEmpty {
                Text("Name: \(userName)")
                    .font(.headline)
                    .foregroundColor(.black)
            }
            
            if !userMail.isEmpty {
                Text("Email: \(userMail)")
                    .font(.headline)
                    .foregroundColor(.gray)
            }
            
            if let profileImage = profileImage {
                AsyncImage(url: profileImage) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                } placeholder: {
                    ProgressView()
                }
            }
        }
        .padding()
        .fullScreenCover(isPresented: $isLoggedIn) {
            MainView()
        }
    }
    
    func kakaoLogin() {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                if let error = error {
                    print(error)
                } else if let oauthToken = oauthToken {
                    print(oauthToken)
                    loginStatus = "로그인 성공"
                    fetchUserInfo()
                    isLoggedIn = true
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                if let error = error {
                    print(error)
                } else if let oauthToken = oauthToken {
                    print(oauthToken)
                    loginStatus = "로그인 성공"
                    fetchUserInfo()
                    isLoggedIn = true
                }
            }
        }
    }
    
    func fetchUserInfo() {
        UserApi.shared.me { (user, error) in
            if let error = error {
                print(error)
            } else {
                if let profile = user?.kakaoAccount?.profile {
                    userName = profile.nickname ?? ""
                    profileImage = profile.profileImageUrl
                }
                userMail = user?.kakaoAccount?.email ?? ""
            }
        }
    }
}

#Preview {
    LoginView()
}
