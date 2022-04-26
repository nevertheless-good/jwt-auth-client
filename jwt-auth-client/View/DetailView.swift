//
//  DetailView.swift
//  jwt-auth-client
//
//  Created by Nevertheless Good on 2022/04/20.
//

import SwiftUI

struct DetailView: View {
    @ObservedObject var contentDetailVM = ContentDetailViewModel()
    
    @State var index: Int
    @State var username: String
    @State var title: String
    @State var date: String
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text(title)
                    .font(.system(size: 18))
                    .frame(height: 50, alignment: .center)
                
                Divider()
                    .padding(5)
                
                Text(contentDetailVM.detail)
                    .onAppear {
                        contentDetailVM.getContent(at: index)
                    }
                    .font(.system(size: 14))
                    .frame(width: geometry.size.width - 30, alignment: .leading)
                    .lineLimit(nil)
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(index: 1, username: "test@gmail.com", title: "test", date: "20202020")
    }
}
