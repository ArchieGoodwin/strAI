//
//  ContentView.swift
//  strAI
//
//  Created by Sergey Dikarev on 10.12.2022.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var model: ContentViewModel
    @State private var selection: Int = 0
    @State var text: String = ""
    @State private var showShareSheet = false

    var body: some View {
        VStack(spacing: 20) {
            if model.working
            {
                ProgressView("Working, please wait...")
            }
            else
            {
                Picker("Select an appearence", selection: $selection) {
                    Text("Images").tag(0)
                    Text("Text").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                TextField("Enter prompt", text: $text)
                    .frame(height: 40)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                Button("Generate") {
                    if selection == 0
                    {
                        model.generateImage(prompt: text)

                    }
                    else
                    {
                        model.generateText(text: text)

                    }
                }
                .frame(height: 44)
                Spacer()
                ScrollView {
                    if selection == 0
                    {
                        AsyncImage(url: self.model.resultUrl) { phase in
                                    switch phase {
                                    case .empty:
                                        VStack {
                                            Text("Image will be here ...")
                                            ProgressView()
                                                .progressViewStyle(.circular)
                                        }
                                    case .success(let image):
                                        self.applyImage(image: image)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                    case .failure:
                                        self.applyText(text: Text("Failedsquare.and.arrow.up fetching image. Make sure to check your data connection and try again."))
                                            .foregroundColor(.red)
                                    default:
                                        EmptyView()
                                    }
                                }
                    }
                    else
                    {
                        Text(model.resultText ?? "")
                    }
                    Spacer()
                    Button {
                        showShareSheet.toggle()
                    } label: {
                        Image(systemName: "square.and.arrow.up")

                    }

                }
                
            }
            
        }
        .sheet(isPresented: $showShareSheet) {
            if selection == 1, let text = model.resultText
            {
                ShareSheet(activityItems: [text])
            }
            else if selection == 0, let url = model.resultUrl
            {
                ShareSheet(activityItems: [loadImage(url: url)])
            }
        }
        .alert(model.errorText ?? "Unknown error", isPresented: $model.showAlert) {
            Button("OK", role: .cancel) {
                model.showAlert = false
                model.errorText = nil
            }
        }
        
        .padding()
    }
    
    func loadImage(url: URL) -> UIImage
    {
        if let imageData = try? Data(contentsOf: url) {
            if let loadedImage = UIImage(data: imageData) {
                return loadedImage
            }
        }
        
        return UIImage()
    }
    
    func applyText(text: Text) -> Text
    {
        
        return text
    }
    
    func applyImage(image: Image) -> Image
    {
        
        return image
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(model: prepareModel())
    }
    
    static func prepareModel() -> ContentViewModel
    {
        let model = ContentViewModel()
        return model
    }
}
