//
//  ContentView.swift
//  XAISwiftUI
//
//  Created by Curt McCune on 8/6/24.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        GeometryReader { geometry in
            LinearGradient(colors: [.white, .black], startPoint: .top, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            ScrollView {
                
                
                
                VStack {
                    
                    VStack {
                        Spacer()
                        ForEach(Array(viewModel.messages.enumerated()), id: \.element) { (index, message) in
                            HStack {
                                switch message.role {
                                case "user":
                                    ChatBubbleView(text: message.content)
                                    Spacer()
                                case "assistant":
                                    Spacer()
                                    ChatBubbleView(text: message.content)
                                default:
                                    ChatBubbleView(text: "Error")
                                }
                            }
                           
                        }
                    }
                    .frame(minHeight: geometry.size.height - 60)
                    
                    HStack {
                        TextField("Input", text: $viewModel.currentText)
                            .frame(height: 40)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        
                        Button {
                            viewModel.sendMessage()
                        } label: {
                            Text("Send")
                                .foregroundStyle(.white)
                        }
                        .disabled(viewModel.currentText == "")
                    }
                    .padding(.top, 20)
                }
                
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity)
            }
        }
    }
}

#Preview {
    
    let viewModel = ViewModel()
    
    viewModel.messages = [
        OpenAI.ChatMessage(role: "user", content: "Test User"),
        OpenAI.ChatMessage(role: "assistant", content: "Test assist")
        
    ]
    
    return ContentView(viewModel: viewModel)
}
