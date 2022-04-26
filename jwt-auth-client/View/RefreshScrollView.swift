//
//  RefreshScrollView.swift
//  jwt-auth-client
//
//  Created by Nevertheless Good on 2022/04/20.
//

import SwiftUI

struct RefreshScrollView<Content: View>: View {

    var content: Content
    @State var refresh = Refresh(downStarted: false, upStarted: false, released: false)
    var onUpRefresh: ()->()
    var onDownRefresh: ()->()
    var progressTint: Color
    var arrowTint: Color

    init(progressTint: Color, arrowTint: Color, @ViewBuilder content: ()->Content, onUpRefresh: @escaping ()->(), onDownRefresh: @escaping ()->()) {
        self.content = content()
        self.onUpRefresh = onUpRefresh
        self.onDownRefresh = onDownRefresh
        self.progressTint = progressTint
        self.arrowTint = arrowTint
    }

    var body: some View {

        ScrollView(.vertical, showsIndicators: false, content: {

            // geometry reader for calculating position...
            GeometryReader { reader -> AnyView in

                DispatchQueue.main.asyncAfter (deadline: .now() + 0.3){

                    if refresh.startOffset == 0 {
                        refresh.startOffset = reader.frame(in: .global).minY
                    }

                    refresh.offset = reader.frame(in: .global).minY

                    // Pull Down
                    if refresh.offset - refresh.startOffset > 50 && !refresh.downStarted {
                        refresh.downStarted = true
                        refresh.upStarted = false
                    }
                    
                    // Pull Up
                    if refresh.startOffset - refresh.offset > 50 && !refresh.upStarted {
                        refresh.upStarted = true
                        refresh.downStarted = false
                    }

                    // checking if refresh is started and drag is released...
                    if refresh.startOffset == refresh.offset && (refresh.downStarted || refresh.upStarted) && !refresh.released {
                        
                        withAnimation(Animation.linear) { refresh.released = true }
                        refresh.released = true
                        if refresh.downStarted {
                            fireUpdate(direction: DOWN)
                        }
                        else if refresh.upStarted {
                            fireUpdate(direction: UP)
                        }
                    }

                    // checking if invalid becomes valid...
                    if refresh.startOffset == refresh.offset && (refresh.upStarted || refresh.downStarted) && refresh.released && refresh.invalid {

                        refresh.invalid = false
                        if refresh.downStarted {
                            fireUpdate(direction: DOWN)
                        }
                        else if refresh.upStarted {
                            fireUpdate(direction: UP)
                        }
                    }
                }

                return AnyView(Color.black.frame(width: 0, height: 0))
            }
            .frame(width: 0, height: 0)

            ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {

                VStack {
                    content
                }
                .frame(maxWidth: .infinity)
                
                if (refresh.downStarted || refresh.upStarted) && refresh.released {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: progressTint))
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .scaleEffect(3, anchor: .center)
                }
            }
        })
    }

    func fireUpdate(direction value: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(Animation.linear) {
                if refresh.startOffset == refresh.offset {
                    if value == UP {
                        onUpRefresh()
                    } else if value == DOWN {
                        onDownRefresh()
                    }
                    refresh.released = false
                    refresh.downStarted = false
                    refresh.upStarted = false
                }
                else {
                    refresh.invalid = true
                }
            }
        }
    }
}
