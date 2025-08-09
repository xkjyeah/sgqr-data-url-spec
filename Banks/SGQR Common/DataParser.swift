//
//  DataParser.swift
//  Aspen Bank
//
//  Created by Daniel Sim on 27/7/25.
//
public struct ParsedField : Identifiable {
    public let tag: String
    public let value: String
    
    public let id: Int
}

public class DataParser {
    static func parseSGQRString(_ sgqrString: String) -> [ParsedField] {
        var fields: [ParsedField] = []
        var index = sgqrString.startIndex
        var idCounter = 0
        
        while index < sgqrString.endIndex {
            // Each field in SGQR format: TTLLVVV... where TT=tag, LL=length, VVV=value
            guard index < sgqrString.index(sgqrString.endIndex, offsetBy: -4) else { break }
            
            let tagEnd = sgqrString.index(index, offsetBy: 2)
            let lengthEnd = sgqrString.index(tagEnd, offsetBy: 2)
            
            let tag = String(sgqrString[index..<tagEnd])
            let lengthStr = String(sgqrString[tagEnd..<lengthEnd])
            
            guard let length = Int(lengthStr) else { break }
    
            let valueEndOpt = sgqrString.index(lengthEnd, offsetBy: length, limitedBy: sgqrString.endIndex)
            
            guard let valueEnd = valueEndOpt else {break}
            
            let value = String(sgqrString[lengthEnd..<valueEnd])
            
            fields.append(ParsedField(tag: tag, value: value, id: idCounter))
            
            idCounter += 1
            index = valueEnd
        }
        
        return fields
    }
    
}
