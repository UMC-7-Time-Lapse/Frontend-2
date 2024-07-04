import SwiftUI

struct IntroView: View {
    @State private var isActive = false

    var body: some View {
        VStack {
            if isActive {
                LoginView()
            } else {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
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
    IntroView()
}
