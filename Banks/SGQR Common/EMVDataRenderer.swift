//
//  EMVDataRenderer.swift
//  Banks
//
//  Created by Daniel Sim on 9/8/25.
//

import SwiftUI

public struct EMVDataRenderer: View {
    var data: [ParsedField]
    var structuredTags: Set<String>
    
    public init(data: [ParsedField], structuredTags: Set<String>) {
        self.data = data
        self.structuredTags = structuredTags
    }
    
    public var body: some View {
        Grid {
            ForEach(data) { i in
                GridRow {
                    Text( i.tag )
                        .font(Font.custom("Avenir Next", size: 14))
                        .fontWeight(Font.Weight.bold)
                    
                    if structuredTags.contains(i.tag) {
                        let parsed = DataParser.parseSGQRString(i.value)
                        
                        EMVDataRenderer(data: parsed, structuredTags: Set())
                    } else {
                        Text(i.value)
                            .font(Font.custom("Avenir Next", size: 14))
                    }
                }
            }
        }
    }
}
