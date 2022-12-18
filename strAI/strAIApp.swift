//
//  strAIApp.swift
//  strAI
//
//  Created by Sergey Dikarev on 10.12.2022.
//

import SwiftUI

@main
struct strAIApp: App {
    var body: some Scene {
        WindowGroup {
            let model = ContentViewModel()
            ContentView(model: model)
        }
    }
}
