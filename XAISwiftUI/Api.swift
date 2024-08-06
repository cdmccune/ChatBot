//
//  Api.swift
//  XAISwiftUI
//
//  Created by Curt McCune on 8/6/24.
//

import Foundation

import Foundation
import Combine

class OpenAI: ObservableObject {
    var API_KEY = ""
    
    struct ChatMessage: Codable, Hashable {
        let role: String
        let content: String
    }
    
    struct ChatRequest: Codable {
        let model: String
        let messages: [ChatMessage]
        let stream: Bool
        var response_format: [String:String]? = [:]
    }
    
    struct ChatResponse: Codable {
        struct Choice: Codable {
            let message: ChatResponseMessage
            
            struct ChatResponseMessage: Codable {
                let content: String
            }
        }
        let choices: [Choice]
    }
    
    struct Token: Codable {
        struct Choice: Codable {
            let delta: ChatMessage
        }
        let choices: [Choice]
    }
    
    @Published var responseText: String = ""
    private var cancellables = Set<AnyCancellable>()

    
    // Function to get chat completions
    func getChatCompletions(messages: [ChatMessage], json: Bool = false, completion: @escaping (Result<ChatResponse, Error>) -> Void) {
        // Define the endpoint URL
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        
        // Create the request body
        var requestBody = ChatRequest(model: "gpt-4-turbo", messages: messages, stream: false, response_format: ["type": json ? "json_object" : "text"])
        
        // Serialize the request body to JSON data
        guard let jsonData = try? JSONEncoder().encode(requestBody) else {
            completion(.failure(NSError(domain: "EncodingError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to encode request body"])))
            return
        }
        
        // Create the URLRequest object
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(API_KEY)", forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
        
        // Create the URLSession data task
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle errors
            if let error = error {
                print("ERROR")
                completion(.failure(error))
                return
            }
            
            // Ensure we have data in the response
            guard let data = data else {
                completion(.failure(NSError(domain: "ResponseError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            
            if let dataString = String(data: data, encoding: .utf8) {
                debugPrint("data: \(dataString)")
            }
            
            // Parse the JSON response
            do {
                let chatResponse = try JSONDecoder().decode(ChatResponse.self, from: data)
                print("hit success")
                completion(.success(chatResponse))
            } catch {
                print("hit error", error)
                completion(.failure(error))
            }
        }
        
        // Start the task
        task.resume()
    }
}
