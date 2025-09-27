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
    var color: Color
    
    public init(document: Binding<SGQRDocument>, bankName: String, fileURL: URL?, color: Color) {
        self._document = document
        self.bankName = bankName
        self.url = fileURL
        self.color = color
        
        print("This is my file URL \(String(describing: fileURL))")
    }

    public var body: some View {
        Grid {
            Text(bankName)
                .font(Font.custom("Avenir Next", size: 24))
                .fontWeight(Font.Weight.bold)
            
            Spacer()
                .gridCellUnsizedAxes(.horizontal)
            
            Text("Pay from bank account")
                .font(Font.custom("Avenir Next", size: 20))
                .fontWeight(Font.Weight.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                
            Text("Current account 012-34567")
                .font(Font.custom("Avenir Next", size: 24))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 10)
            
            Text("Pay to")
                .font(Font.custom("Avenir Next", size: 20))
                .fontWeight(Font.Weight.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(document.dataParser.get("26", "02") ?? "(unknown)")
                .font(Font.custom("Avenir Next", size: 24))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 10)
            
            Text("Amount")
                .font(Font.custom("Avenir Next", size: 20))
                .fontWeight(Font.Weight.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("$" + (document.dataParser.get("54") ?? ""))
                .font(Font.custom("Avenir Next", size: 24))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 20)
            
            Button {
                print("Do nothing")
            } label: {
                Text("Make payment")
                    .frame(maxWidth: .infinity)
                    .font(Font.custom("Avenir Next", size: 24))
            }
                .font(Font.custom("Avenir Next", size: 24))
                .gridCellColumns(2)
                .frame(maxWidth: .infinity)
                .buttonStyle(.borderedProminent)
            
            Button {
                print("Do nothing")
            } label: {
                Text("Cancel")
                    .frame(maxWidth: .infinity)
                    .font(Font.custom("Avenir Next", size: 24))
            }
                .gridCellColumns(2)
                .buttonStyle(.bordered)
            
            Spacer()
            Divider()
            
            Text("Debug info")
                .font(Font.custom("Avenir Next", size: 14))
            EMVDataRenderer(data: document.fields, structuredTags: Set(["26"]))
        }
        .padding(30)
        .frame(maxWidth:.infinity, maxHeight: .infinity)
        .background(color)
        
    }
}

#Preview {
    ContentView(document: .constant(SGQRDocument.init(text: SGQRDocument.SAMPLE_DOCUMENT)), bankName: "Sample Bank", fileURL: nil,
                color: Color.white)
}
