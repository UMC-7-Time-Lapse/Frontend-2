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
                            .foregroundColor(Color.blue)
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
                    loginToServer(authorizationCode: oauthToken.accessToken)
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
                    loginToServer(authorizationCode: oauthToken.accessToken)
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
    
    func loginToServer(authorizationCode: String) {
        guard let url = URL(string: APIConstants.Auth.kakaoLogin) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["authorizationCode": authorizationCode]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        } catch {
            print("Failed to encode JSON")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Network error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let response = try JSONDecoder().decode(LoginResponse.self, from: data)
                print("Server response: \(response)")
                // 여기에서 accessToken, refreshToken 등을 처리합니다.
                // 예를 들어 UserDefaults에 저장하거나 앱의 상태를 업데이트할 수 있습니다.
                // 예: UserDefaults.standard.set(response.accessToken, forKey: "accessToken")
            } catch {
                print("Failed to decode JSON response")
            }
        }.resume()
    }
}

struct LoginResponse: Codable {
    let accessToken: String
    let refreshToken: String
    let grantType: String
    let expiresIn: Int
}

#Preview {
    LoginView()
}
