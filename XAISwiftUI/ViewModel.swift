//
//  ViewModel.swift
//  XAISwiftUI
//
//  Created by Curt McCune on 8/6/24.
//

import Foundation

class ViewModel: ObservableObject {
    
    @Published var messages: [OpenAI.ChatMessage] = []
    @Published var currentText: String = ""

    var API = OpenAI()
    
    func sendMessage() {
        messages.append(OpenAI.ChatMessage(role: "user", content: currentText))
        currentText = ""
        
        
        
        API.getChatCompletions(messages: messages) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    let text = response.choices.first?.message.content ?? ""
                    self.messages.append(OpenAI.ChatMessage(role: "assistant", content: text))
                case .failure(let error):
                    self.messages.append(OpenAI.ChatMessage(role: "assistant", content: error.localizedDescription))
                }
            }
        }
    }
}


