//
//  ChatBubbleView.swift
//  XAISwiftUI
//
//  Created by Curt McCune on 8/6/24.
//

import SwiftUI

struct ChatBubbleView: View {
    
    var text: String
    
    var body: some View {
        ZStack {
            Text(text)
                .padding()
        }
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 10.0))
    }
}



#Preview {
    GeometryReader { geometry in
        LinearGradient(colors: [.white, .black], startPoint: .top, endPoint: .bottomTrailing)
            .ignoresSafeArea()
        
        VStack{
            Spacer()
            HStack{
                Spacer()

                ChatBubbleView(text: "Test")
                Spacer()
            }
            Spacer()
        }
    }
}
