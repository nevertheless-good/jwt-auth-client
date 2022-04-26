//
//  WriteView.swift
//  jwt-auth-client
//
//  Created by Nevertheless Good on 2022/04/20.
//

import SwiftUI
//import Alamofire
//import SwiftyJSON
//import JWTDecode

struct WriteView: View {
    @EnvironmentObject var writePostVM: WritePostViewModel
    @StateObject var titleText = InputTextLimiter(limit: 50)
    @State var detailText = "Input Detail"

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    Text("Title")
                        .multilineTextAlignment(.center)
                        .frame(width: 40, height: 30, alignment: .bottom)
                    
                    Divider()
                    
                    TextField("Input Title", text: $titleText.value)
//                        .foregroundColor($titleText.hasReachedLimit.wrappedValue ? .red : Color("Color3"))
                        .frame(width: geometry.size.width - 70, height: 30, alignment: .bottom)
                }
                .frame(width: geometry.size.width - 30, height: 50, alignment: .bottom)
                    
                Divider()
                    .padding(.bottom)
                
                TextEditor(text: $detailText)
                    .foregroundColor(writePostVM.isEditContent ? .primary : .gray)
                    .onTapGesture {
                        if writePostVM.isEditContent == false {
                            detailText = ""
                            writePostVM.isEditContent = true
                        }
                    }
                    .multilineTextAlignment(writePostVM.isEditContent ? .leading : .center)
                    .frame(width: geometry.size.width - 30, alignment: .center)
                
                Spacer()
                
                Button(action: {
                    writePostVM.saveContent(title: titleText.value, detail: detailText)
                }) {
                    Text("Post")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 50)
                        .background(Color("Color1"))
                        .clipShape(Capsule())
                        // shadow...
                        .shadow(color: Color.white.opacity(0.1), radius: 5, x: 0, y: 5)
                }
            }
            .onDisappear() {
                titleText.value = ""
                writePostVM.isEditContent = false
            }
            .padding()
            .alert(isPresented: $writePostVM.existAlertMsg) {
                if writePostVM.alertMsg == "SUCCESS" {
                    return Alert(title: Text("Alert"),
                          message: Text("Posted"),
                          dismissButton: .default(Text("Close"),
                          action: {
                                writePostVM.existSuccessPostContent = true
                                self.presentationMode.wrappedValue.dismiss()

                          }))
                } else if writePostVM.alertMsg == "FAIL1"
                            || writePostVM.alertMsg == "FAIL2" {
                    return Alert(title: Text("Alert"),
                          message: Text("Fail Post"),
                          dismissButton: .default(Text("Close"), action: { self.presentationMode.wrappedValue.dismiss() }))
                } else if writePostVM.alertMsg == "FAIL3" {
                    return Alert(title: Text("Alert"),
                          message: Text("Input Title"),
                          dismissButton: .default(Text("Close")))
                } else if writePostVM.alertMsg == "FAIL4" {
                    return Alert(title: Text("Alert"),
                          message: Text("Input Detail"),
                          dismissButton: .default(Text("Close")))
                } else {
                    return Alert(title: Text("Alert"),
                          message: Text("Fail Post"),
                          dismissButton: .default(Text("Close"), action: { self.presentationMode.wrappedValue.dismiss() }))
                }
            }
        }
    }
}

struct WriteView_Previews: PreviewProvider {
    static var previews: some View {
        WriteView()
            .environmentObject(WritePostViewModel())
    }
}
