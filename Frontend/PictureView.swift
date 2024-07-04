import SwiftUI

struct PictureView: View {
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Image(systemName: "chevron.left")
                    .font(.title)
                    .foregroundColor(.black)
                Spacer()
            }
            .padding(.horizontal)
            
            Image("pic_1")
                .resizable()
                .scaledToFit()
                .frame(height: 500)
                .cornerRadius(10)
            
            HStack {
                Image(systemName: "person.circle")
                    .font(.system(size: 24))
                
                Text("홍길동")
                    .font(.title3)
                    .fontWeight(.bold)
                
                Spacer()
                
                Image(systemName: "heart.fill")
                
                Text("10")
                    .font(.subheadline)
            }
            .padding(.horizontal)
            
            HStack {
                Text("금문교에서")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                Text("2024.03.24")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
    }
}

struct PictureView_Previews: PreviewProvider {
    static var previews: some View {
        PictureView()
    }
}
