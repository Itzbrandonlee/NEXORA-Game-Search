import SwiftUI

struct LoginView: View {
    @Binding var isLoggedIn: Bool
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color("NexoraBlue"), Color("NexoraPurple")],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
        VStack(spacing: 30) {
            Image("NexoraIcon")
                .resizable()
                .font(.system(size: 80))
                .foregroundColor(.white)
                .scaledToFit()
                .frame(width: 150, height: 150)
            
            VStack(spacing: 15) {
                TextField("", text: $email,
                          prompt: Text("Email").foregroundColor(.white.opacity(0.6)))
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(10)
                    .foregroundColor(.white)
                
                SecureField("", text: $password,
                                      prompt: Text("Password").foregroundColor(.white.opacity(0.6)))
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(10)
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 40)
            
            Button(action: {
                print("Sign in tapped")
            }) {
                Text("Sign In")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("NexoraPurple"))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 40)
            
            Button(action: {
                isLoggedIn = true
            }) {
                Text("Continue as Guest")
                    .foregroundColor(Color("NexoraRed"))
                    .underline()
            }
        }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(isLoggedIn: .constant(false))
    }
}
