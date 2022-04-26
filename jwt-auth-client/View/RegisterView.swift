//
//  RegisterView.swift
//  jwt-auth-client
//
//  Created by Nevertheless Good on 2022/04/22.
//

import SwiftUI

struct CShapeSignUp: Shape {
    func path(in rect: CGRect) -> Path {
        return Path { path in
            // left side curve...
            path.move(to: CGPoint(x: 0, y: 100))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
        }
    }
}

struct RegisterView: View {
    @EnvironmentObject var authenticatorVM: AuthenticatorViewModel
    
    @State var username = ""
    @State var password = ""
    @State var rePassword = ""
    
    @Binding var index: Int

    var body: some View {
        ZStack (alignment: .bottom) {
            VStack {
                HStack {
                    Spacer(minLength: 0)
                    VStack(spacing: 10) {
                        Text("SignUp")
                            .foregroundColor(self.index == 1 ? .white : .gray)
                            .font(.title)
                            .fontWeight(.bold)

                        Capsule()
                            .fill(self.index == 1 ? Color.blue : Color.clear)
                            .frame(width: 100, height: 5)
                    }
                }
                .padding(.top, 30)      // for top curve...

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

                VStack {
                    HStack(spacing: 15) {
                        Image(systemName: "eye.slash.fill")
                            .foregroundColor(Color("Color1"))

                        SecureField("Password", text: self.$rePassword)
                            .textContentType(.newPassword)
                            .foregroundColor(.white)
                    }

                    Divider().background(Color.white.opacity(0.5))
                }
                .padding(.horizontal)
                .padding(.top, 30)
            }
            .padding()
            .padding(.bottom, 65)
            .background(Color("Color2"))
            .clipShape(CShapeSignUp())
            .contentShape(CShapeSignUp())
            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: -5)
            .onTapGesture {
                self.index = 1
            }
            .cornerRadius(35)
            .padding(.horizontal, 20)

            Button(action: {
                authenticatorVM.register(user: username, pass: password, rePass: rePassword)
            }) {
                Text("SIGNUP")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(.vertical)
                    .padding(.horizontal, 44)
                    .background(Color("Color1"))
                    .clipShape(Capsule())
                    .shadow(color: Color.white.opacity(0.1), radius: 5, x: 0, y: 5)
            }
            .offset(y: 25)
            .opacity(self.index == 1 ? 1 : 0)
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    @State static var index = 1
    
    static var previews: some View {
        RegisterView(index: $index)
    }
}
