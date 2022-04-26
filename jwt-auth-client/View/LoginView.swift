//
//  LoginView.swift
//  jwt-auth-client
//
//  Created by Nevertheless Good on 2022/04/22.
//

import SwiftUI

struct CShapeLogin: Shape {
    func path(in rect: CGRect) -> Path {
        return Path { path in
            // right side curve...
            path.move(to: CGPoint(x: rect.width, y: 100))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: 0))
        }
    }
}

struct LoginView: View {
    @EnvironmentObject var authenticatorVM: AuthenticatorViewModel
    
    @State var username = ""
    @State var password = ""
    
    @Binding var index: Int

    var body: some View {
        ZStack (alignment: .bottom) {
            VStack {
                HStack {
                    VStack (spacing: 10) {
                        Text("Login")
                            .foregroundColor(self.index == 0 ? .white : .gray)
                            .font(.title)
                            .fontWeight(.bold)

                        Capsule()
                            .fill(self.index == 0 ? Color.blue : Color.clear)
                            .frame(width: 100, height: 5)

                    }

                    Spacer(minLength: 0)
                }
                .padding(.top, 30)

                VStack {
                    HStack(spacing: 15) {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(Color("Color1"))

                        TextField("Emal Address", text: self.$username)
                            .textContentType(.username)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                            .foregroundColor(.white)
                    }

                    Divider().background(Color.white.opacity(0.5))
                }
                .padding(.horizontal)
                .padding(.top, 40)

                VStack {
                    HStack(spacing: 15) {
                        Image(systemName: "eye.slash.fill")
                            .foregroundColor(Color("Color1"))

                        SecureField("Password", text: self.$password)
                            .textContentType(.password)
                            .foregroundColor(.white)
                    }

                    Divider().background(Color.white.opacity(0.5))
                }
                .padding(.horizontal)
                .padding(.top, 30)
                .padding(.bottom, 62)
            }
            .padding()
            .padding(.bottom, 65)
            .background(Color("Color2"))
            .clipShape(CShapeLogin())
            .contentShape(CShapeLogin())
            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: -5)
            .onTapGesture {
                self.index = 0
            }
            .cornerRadius(35)
            .padding(.horizontal,20)

            Button(action: {
                authenticatorVM.login(user: username, pass: password)
                
            }) {
                Text("LOGIN")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(.vertical)
                    .padding(.horizontal, 50)
                    .background(Color("Color1"))
                    .clipShape(Capsule())
                    // shadow...
                    .shadow(color: Color.white.opacity(0.1), radius: 5, x: 0, y: 5)
            }
            .offset(y: 25)
            .opacity(self.index == 0 ? 1 : 0)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    @State static var index = 0

    static var previews: some View {
        LoginView(index: $index)
    }
}
