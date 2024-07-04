import SwiftUI

struct AlarmView: View {
    var body: some View {
        VStack {
            VStack(alignment: .center) {
                Text("샌프란시스코")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "#2E83F2"))
                
                Spacer().frame(height: 10)

                Text("추억이 도착했어요")
                    .font(.title)
                
                Spacer().frame(height: 10)

                Text("추억을 열까요?")
                    .font(.title)
                
                Spacer().frame(height: 30)

                Image("3dicons")
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}

#Preview {
    AlarmView()
}
