//
//  Aspen_BankDocument.swift
//  Aspen Bank
//
//  Created by Daniel Sim on 21/7/25.
//

import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static var sgqrData: UTType {
        UTType(importedAs: "sg.gov.mas.sgqr-data")
    }
}

enum EMVCoFormatError : Error {
    case invalidLength
}

public struct SGQRDocument: FileDocument {
    var fields: [ParsedField]
    
    public static let SAMPLE_DOCUMENT = "0006HELLO!"
    public static var readableContentTypes = [UTType.sgqrData]

    public init(text: String) {
        print("Initializing with text...")
        print(text)
        self.fields = DataParser.parseSGQRString(text)
    }

    public init(configuration: ReadConfiguration) throws {
        print("What the heck is going on?")
        print(configuration.file)
        guard let data = configuration.file.regularFileContents,
              let string = String(data: data, encoding: .nonLossyASCII)
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        fields = DataParser.parseSGQRString(string)
    }
    
    public func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let converted = try fields.map { i in
            guard i.value.count >= 0 && i.value.count <= 100 else {
                throw EMVCoFormatError.invalidLength
            }
            let lengthStr = String(format: "%02d", i.value.count)
            let tagStr = String(format: "%02d", i.tag)
            return "\(lengthStr)\(tagStr)\(i.value)"
        }
        
        let data = converted.joined(separator: "").data(using: .nonLossyASCII)!
        return .init(regularFileWithContents: data)
    }
}
