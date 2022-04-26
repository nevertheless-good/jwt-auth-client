//
//  ListView.swift
//  jwt-auth-client
//
//  Created by Nevertheless Good on 2022/04/20.
//

import SwiftUI

struct ListView: View {
    @EnvironmentObject var writePostVM: WritePostViewModel
    
    @StateObject var titleListVM = TitleListViewModel()
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    Text("Content count: \(titleListVM.titleLists.count)")
                        .frame(alignment: .center)
                        .foregroundColor(.gray)
                    
                    RefreshScrollView(progressTint: .gray, arrowTint: .gray) {
                        VStack {
                            if titleListVM.titleLists.isEmpty {
                                Text("There is no content")
                                    .padding(.vertical, 10.0)
                            }
                            List {
                                ForEach(titleListVM.titleLists, id: \.self.id) { i in
                                    TitleListView(id: i.id, username: i.username, title: i.title, date: i.date_last_updated)
                                }
                            }
                            .frame(width: geometry.size.width + 40, height: abs(geometry.size.height - 105), alignment: .leading)
                        }
//                        .frame(maxWidth: .infinity)
                    } onUpRefresh: {
                        self.titleListVM.getList(mode: UP)
                    } onDownRefresh: {
                        self.titleListVM.getList(mode: DOWN)
                    }
                    .onAppear {
                        if writePostVM.existSuccessPostContent {
                            writePostVM.existSuccessPostContent = false
                            self.titleListVM.getList(mode: DOWN)
                        }
                    }
                    
                    NavigationLink(destination: WriteView()) {
                        Text("New Post")
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
                .offset(x: -20, y: 0)
            }
            .navigationBarTitle("Content List", displayMode: .inline)
            .padding(5)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
            .environmentObject(WritePostViewModel())
    }
}

