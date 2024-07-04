import Foundation

struct APIConstants {
    static let baseURL = "https://your-api-url.com"
    
    struct Auth {
        static let kakaoLogin = baseURL + "/api/auth/kakao"
    }
    
    struct Post {
        static let create = baseURL + "/posts"
        static let createImage = baseURL + "/posts/images"
        static let getAll = baseURL + "/posts"
        static let getDetail = baseURL + "/posts/"
        static let like = baseURL + "/posts/like"
    }
    
    struct User {
        static let myPage = baseURL + "/users/mypage"
    }
}
