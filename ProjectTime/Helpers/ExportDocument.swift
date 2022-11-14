//
//  ExportDocument.swift
//  ProjectTime
//
//  Created by Dirk on 24.05.22.
//

import SwiftUI
import UniformTypeIdentifiers

struct ExportDocument: FileDocument {
    
    static var readableContentTypes: [UTType] { [.plainText, .commaSeparatedText] }

    var message: String

    init(message: String) {
        self.message = message
    }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let string = String(data: data, encoding: .utf8)
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        message = string
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        return FileWrapper(regularFileWithContents: message.data(using: .utf8)!)
    }
    
}
