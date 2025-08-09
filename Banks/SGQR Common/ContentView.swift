//
//  ContentView.swift
//  Aspen Bank
//
//  Created by Daniel Sim on 21/7/25.
//

import SwiftUI

public struct ContentView: View {
    @Binding var document: SGQRDocument
    var bankName: String
    var url: URL?
    
    public init(document: Binding<SGQRDocument>, bankName: String, fileURL: URL?) {
        self._document = document
        self.bankName = bankName
        self.url = fileURL
        
        print("This is my file URL \(String(describing: fileURL))")
    }

    public var body: some View {
        VStack {
            Text(bankName)
                .font(Font.custom("Avenir Next", size: 24))
                .fontWeight(Font.Weight.bold)
            EMVDataRenderer(data: document.fields, structuredTags: Set(["26"]))
        }
    }
}

#Preview {
    ContentView(document: .constant(SGQRDocument.init(text: SGQRDocument.SAMPLE_DOCUMENT)), bankName: "Sample Bank", fileURL: nil)
}
