//
//  AIEndpoint.swift
//  strAI
//
//  Created by Sergey Dikarev on 10.12.2022.
//

import Foundation

enum Endpoint {
    case completions
    case images
}

extension Endpoint {
    var path: String {
        switch self {
        case .completions:
            return "/v1/completions"
        case .images:
            return "/v1/images/generations"
        }
    }
    
    var method: String {
        switch self {
        case .completions:
            return "POST"
        case .images:
            return "POST"
        }
    }
    
    func baseURL() -> String {
        switch self {
        case .completions:
            return "https://api.openai.com"
        case .images:
            return "https://api.openai.com"
        }
    }
}
