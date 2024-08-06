//
//  XAISwiftUIApp.swift
//  XAISwiftUI
//
//  Created by Curt McCune on 8/6/24.
//

import SwiftUI

@main
struct XAISwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: ViewModel())
        }
    }
}
