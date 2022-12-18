//
//  ContentViewModel.swift
//  strAI
//
//  Created by Sergey Dikarev on 10.12.2022.
//

import Foundation

class ContentViewModel: ObservableObject
{
    @Published var resultText: String?
    @Published var resultUrl: URL?
    @Published var working: Bool = false
    @Published var imageLoading: Bool = false

    @Published var showAlert: Bool = false
    @Published var errorText: String?

    func generateText(text: String)
    {
        working = true
        let ai = AISwift(authToken: Constants.aiToken())
        ai.sendCompletion(with: text) { result in
            DispatchQueue.main.async {
                self.working = false
                self.imageLoading = true
            }
            switch result
            {
            case .success(let object):
                DispatchQueue.main.async {
                    self.resultText = object.choices.map({ $0.text }).joined(separator: " __________ ")
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorText = error.localizedDescription
                    self.showAlert = true
                }
               
                break
            }
        }
    }
    
    func generateImage(prompt: String)
    {
        working = true
        let ai = AISwift(authToken: Constants.aiToken())
        ai.imageGeneration(with: prompt) { result in
            DispatchQueue.main.async {
                self.working = false
            }
            switch result
            {
            case .success(let object):
                DispatchQueue.main.async {
                    if let urlString = object.data.first?.url, let url = URL(string: urlString)
                    {
                        self.resultUrl = url
                    }
                }
            case .failure(let error):
               
                DispatchQueue.main.async {
                    self.errorText = error.localizedDescription
                    self.showAlert = true
                }
                break
            }
        }
    }
}
