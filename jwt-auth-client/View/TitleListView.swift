//
//  TitleListView.swift
//  jwt-auth-client
//
//  Created by Nevertheless Good on 2022/04/24.
//

import SwiftUI

struct TitleListView: View {
    var id: Int
    var username: String
    var title: String
    var date: String
    
    var body: some View {
        GeometryReader { geometry in
//            HStack {
                NavigationLink(destination: DetailView(index: id, username: username, title: title, date: date)) {
                    
                    VStack {
                        
                        HStack {
                            Text(String(id))
                                .font(.system(size: 18))
                                .fontWeight(.medium)
                                .foregroundColor(Color.gray)
                                .lineLimit(1)
                                .frame(width: 40, alignment: .trailing)
                            
                            Spacer()
                            
                            Text(title)
                                .font(.system(size: 18))
                                .fontWeight(.medium)
                                .foregroundColor(Color("Color3"))
                                .lineLimit(1)
                                .frame(width: abs(geometry.size.width) - 50, alignment: .leading)
                        }
                        
                        HStack {
                            Text(date)
                                .font(.system(size: 12))
                                .fontWeight(.light)
                                .foregroundColor(Color.gray)
                                .lineLimit(1)
                                .frame(width: 120, alignment: .center)
                            
                            Spacer()
                            
                            Text(username)
                                .font(.system(size: 12))
                                .fontWeight(.light)
                                .foregroundColor(Color.gray)
                                .lineLimit(1)
                                .frame(width: abs(geometry.size.width) - 160, alignment: .trailing)
                                
                            Spacer(minLength: 10)
                        }
                    }
                    .frame(width: abs(geometry.size.width), alignment: .center)
                }
//            }
        }
        .frame(height: 35, alignment: .leading)
    }
}

struct TitleListView_Previews: PreviewProvider {
    static var previews: some View {
        TitleListView(id: 1, username: "test@gmail.com", title: "test", date: "2022-04-24 08:46:11")
    }
}
