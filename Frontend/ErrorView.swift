import SwiftUI

struct ErrorView: View {
    var body: some View {
        VStack {
            VStack(spacing: 20) {
                
                Spacer().frame(height: 10)
                
                Image("pic_1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                    .cornerRadius(10)
                
                
                VStack {
                    Text("이 추억은")
                        .font(.title)
                    
                    Spacer().frame(height: 10)
                    
                    HStack {
                        Text("샌프란시스코")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: "#2E83F2"))
                        
                        Text("에서")
                            .font(.title)
                    }
                    
                    
                    Spacer().frame(height: 10)


                    Text("볼 수 있어요!")
                        .font(.title)
                    
                    Spacer().frame(height: 20)

                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.horizontal)
            }
            .padding(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.blue, lineWidth: 2)
            )
            
            // 확인 버튼
            Button(action: {
            }) {
                Text("확인")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.blue)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.blue, lineWidth: 3)
                            .background(Color.white)
                            .cornerRadius(10)
                    )
            }
            .padding()
        }
        .padding(.horizontal)
    }
}

#Preview {
    ErrorView()
}
